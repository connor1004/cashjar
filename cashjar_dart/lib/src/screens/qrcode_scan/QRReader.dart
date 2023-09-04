
import 'dart:async';
import 'dart:html';

class QRReader {
  bool active = false;
  VideoElement videoElement;
  ImageElement imageElement;
  CanvasImageSource imageSource;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  Worker decorder;
  Timer timer;
  bool isIOS = false;
  Function callback;
  MediaStream videoStream;

  static bool noCameraPermission = false;

  QRReader({this.callback}) {
    isIOS = ['iPad', 'iPhone', 'iPod'].contains(window.navigator.platform);
    videoElement = window.document.querySelector('video.scan-video');
    imageElement = window.document.querySelector('img.scan-image');

    String baseurl = '';
    decorder = Worker(baseurl + 'decoder.js');
    decorder.addEventListener('message', onDecoderMessage);
  }
  
  void setCanvas() {
    canvas = window.document.createElement('canvas');
    ctx = canvas.getContext('2d');
  }

  void setPhotoSourceToScan(bool forSelectedPhotos) {
    if (!forSelectedPhotos && MediaStream.supported) {
      imageSource = videoElement;
    }
    else {
      imageSource = imageElement;
    }
  }

  void setCanvasProperties() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  }

  void startCapture(dynamic constraints) {
    window.navigator
      .getUserMedia(audio: false, video: constraints)
      .then((stream) {
        print('get media success');
        videoStream = stream;
        videoElement.srcObject = stream;
        videoElement.setAttribute('playsinline', 'true');
        videoElement.setAttribute('controls', 'true');
        Timer.run(() => videoElement.removeAttribute('controls'));
      })
      .catchError((err) {
        print('Error occurred $err');
        showErrorMsg();
      });
  }

  void showErrorMsg() {
    noCameraPermission = true;
  }

  void init() {
    bool streaming = false;

    setPhotoSourceToScan(false);

    setCanvas();
    if (MediaStream.supported) {
      videoElement.addEventListener('play', (event) {
        if (!streaming) {
          setCanvasProperties();
          streaming = true;
        }
      }, false);
    }
    else {
      setCanvasProperties();
    }

    if (MediaStream.supported) {
      print('before enumerate');
      // window.navigator
      //   .mediaDevices
      //   .enumerateDevices()
      //   .then((List<MediaDeviceInfo> devices) {
      //     print('within enumerate');
      //     var device = devices.where((MediaDeviceInfo dev) {
      //       return dev.kind == 'videoinput';
      //     });

      //     Map constraints;
      //     if (device.length > 1) {
      //       constraints = {
      //         'mandatory': {
      //           'sourceId': device.elementAt(1).deviceId != '' ? device.elementAt(1).deviceId : null
      //         }
      //       };

      //       if (isIOS) {
      //         constraints['facingMode'] = 'environment';
      //       }

      //       startCapture(constraints);
      //     } else if (device.isNotEmpty) {
      //       constraints = {
      //         'mandatory': {
      //           'sourceId': device.first.deviceId != '' ? device.first.deviceId : null
      //         }
      //       };

      //       if (isIOS) {
      //         constraints['facingMode'] = 'environment';
      //       }

      //       startCapture(constraints);
      //     } else {
            startCapture({'facingMode': 'environment'});
      //     }
      //   })
      //   .catchError((err) {
      //     showErrorMsg();
      //     print('Error occurred : $err');
      //   });
    }
  }

  void scan(bool forSelectedPhotos) {
    active = true;
    setPhotoSourceToScan(forSelectedPhotos);
    newDecoderFrame();
  }

  void onDecoderMessage(event) {
    if (event.data.length > 0) {
      var qrid = event.data[0][2];
      if (active) {
        active = false;
        callback(qrid);
      }
    }
    else {
      Timer(Duration(milliseconds: 20), newDecoderFrame);
    }
  }

  void newDecoderFrame() {
    if (!active) return;
    try {
      ctx.drawImageScaled(imageSource, 0, 0, canvas.width, canvas.height);
      var imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);

      if (imgData.data != null && imgData.data.isNotEmpty) {
        decorder.postMessage(imgData);
      }
    } catch (e) {
      print('error: $e');
      // if (e == 'NS_ERROR_NOT_AVAILABLE') Timer.run(newDecoderFrame);
    }
  }

  void stopScanning() {
    if (videoStream == null) return;
    for (int i = 0; i < videoStream.getTracks().length; i++) {
      videoStream.getTracks()[i].stop();
    }
    videoStream = null;
  }
}