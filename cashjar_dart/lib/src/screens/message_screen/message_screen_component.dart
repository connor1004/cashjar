import 'dart:convert';
import 'dart:typed_data';
import 'dart:web_audio';
import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:exifdart/exifdart.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'package:exifdart/exifdart_html.dart';

import 'package:cashjar_common/model/offer.dart';
import 'package:cashjar_common/model/message.dart';
import 'package:cashjar_common/bloc/messaging/messaging.dart';

import 'package:cashjar_dart/src/api/storage_service_api_impl.dart';
import 'package:cashjar_dart/src/services/title_service.dart';
import 'package:cashjar_dart/src/api/message_service_api_impl.dart';
import 'package:cashjar_dart/src/api/offer_service_firestore.dart';
import 'package:cashjar_dart/src/components/message_input/message_input_component.dart';
import 'package:cashjar_dart/src/routes/route_paths.dart';

@Component(
  selector: 'message-screen',
  templateUrl: 'message_screen_component.html',
  styleUrls: ['message_screen_component.css'],
  directives: [
    coreDirectives,
    materialDirectives,
    MaterialInputComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialFabComponent,
    MaterialMultilineInputComponent,
    MessageInputComponent,
    MaterialProgressComponent,
  ],
  providers: [materialProviders, ClassProvider(MessagingBloc)]
)
class MessageScreenComponent implements OnActivate {
  Offer offer;
  List<Message> messages;
  String offerId = '';
  String userId = '';
  bool isPromotor = false;
  String inputText = "";

  MessagingBloc _messagingBloc;
  String urlError = "";
  String imageClass = "";
  bool showTicker = false;
  Timer timer;
  String exTicker = "";

  MutationObserver _mo;
  Map<StreamSubscription, bool> loadSubs = {};

  int exheight = 0;
  int bottomHeight = 50;

  String attachedImageSrc = '';
  Blob attachedBlob;
  String attachedFileName = '';
  String attachedFileType = '';
  bool showSendButton;
  int progressValue = 0;
  bool isUploading = false;
  bool isLoading = false;

  bool isRecording = false;
  bool showingMic = false;
  Timer micTimer;
  DateTime startedTime;
  MediaStreamAudioSourceNode source;
  ScriptProcessorNode processor;
  MediaStream audioStream;
  num sampleRate;
  List<Float32List> recordedData;
  int recordedLength;
  int buffersize = 4096;
  Blob audioBlob;
  String attachImageClass = '';

  final Router _router;
  TitleService _titleService;

  MessageScreenComponent(this._router, this._titleService);

  @override
  void onActivate(_, RouterState current) {
    _titleService.showTitle = true;
    Map<String, String> queryParams = current.queryParameters;
    if (queryParams.isEmpty || queryParams['offer'] == null) {
      urlError = "Please provide an offer";
      return;
    } else {
      if (queryParams['client'] != null) {
        isPromotor = false;
        userId = queryParams['client'];
      }
      else if (queryParams['promotor'] != null) {
        isPromotor = true;
        userId = queryParams['promotor'];
      }
      else {
        urlError = "Please provide client or promotor";
        return;
      }
    }

    if (isPromotor) {
      bottomHeight = 90;
    }
    window.document.querySelector('.offer-message').style.paddingBottom = (bottomHeight + 15).toString() + 'px';

    urlError = "";
    
    _messagingBloc = MessagingBloc(MessageServiceApiImple(), OfferServiceFirestore(), StorageServiceApiImpl());
    _messagingBloc.dispatch(LoadInitialData(offerId: queryParams['offer']));
    _messagingBloc.state.listen((state) {
      if (state is MessagingFailure) {
        urlError = state.error;
      }
      else if (state is CreateOfferSuccess) {
        print('create offer success');
        _router.navigate(
          RoutePaths.createOffer.toUrl(),
          NavigationParams(queryParameters: {'offer': state.offerId, 'promotor': offer.context.promotorId}),
        );
      }
      else {
        if (state.isLoading) {
          isLoading = true;
        }
        else {
          isLoading = false;
          offer = state.offer;
          messages = state.messages;
          String title = 'Offer';
          if (offer != null) {
            urlError = "";
            if (isPromotor && userId != offer.context.promotorId) {
              urlError = "Invalid promotor: $userId!";
              messages = [];
            }
            else if (!isPromotor && userId != offer.context.cChatId) {
              urlError = "Invalid client: $userId!";
              messages = [];
            }
            title = offer.offerSiteName + ' - ' + offer.offerName;
            if (offer.ticker != null && offer.ticker != '') {
              if (exTicker != offer.ticker) {
                showTicker = true;
                if (timer != null && timer.isActive) {
                  timer.cancel();
                }
                timer = Timer(Duration(seconds: 5), () {
                  showTicker = false;
                });
                exTicker = offer.ticker;
              }
            }
            else {
              showTicker = false;
              exTicker = "";
            }
          }
          else {
            showTicker = false;
            exTicker = "";
          }
          window.document.querySelector("title").setInnerHtml(title);
          _titleService.title = title;
        }
      }
    });
    window.onScroll.listen((Event event) {
      Element element = window.document.querySelector('html');
      // print('here,' + event.target.toString());
      Element elBody = window.document.querySelector('body');
      if (element.scrollTop == 0 && elBody.scrollTop == 0) {
        imageClass = "";
      }
      else {
        imageClass = "sticky";
      }
    });

    Element element = window.document.querySelector('.offer-message');
    _mo = MutationObserver(_mutation);
    _mo.observe(element, childList: true, subtree: true);
  }

  Map<String, bool> getMessageClass(Message msg) {
    return <String, bool>{
      'message': true,
      'other': userId != msg.senderId,
      'fixed-width' : msg.type != 'text' && msg.type != 'other',
    };
  }

  String getFormattedTime(DateTime time) {
    DateTime currentTime = DateTime.now().toLocal();
    DateTime sentTime = time.toLocal();
    if (sentTime.year != currentTime.year) {
      return DateFormat.yMd().add_jm().format(sentTime);
    }
    else if (sentTime.month != currentTime.month || sentTime.day != currentTime.day) {
      return DateFormat.Md().add_jm().format(sentTime);
    }
    else {
      return DateFormat.jm().format(sentTime);
    }
  }

  void sendMessage() {
    String type = 'text';
    String messageText = inputText.trim();
    if (!isRecording && messageText.isEmpty && attachedFileType == '') {
      return;
    }
    if (isRecording) {
      handleCancelClicked();		
      makeWavBlob();
      type = 'voice';
    } else if (attachedFileType != '') {
      type = attachedFileType;
    }
    _messagingBloc.dispatch(CreateMessage(
      message: Message(
        senderId: userId,
        sentOn: DateTime.now().toUtc(),
        text: messageText,
        type: type,
        url: '',
        filename: attachedFileName,
      ),
      blob: attachedBlob,
      audioBlob: audioBlob,
      onUploading: this.handleUploading,
      onFinished: this.handleFinishedUploading,
    ),
    );
    inputText = "";
    if (exheight > bottomHeight + 10) {
      exheight = bottomHeight;
      window.document.querySelector('.offer-message').style.paddingBottom = (exheight + 15).toString() + 'px';
      _scrollToBottom();
    }
  }

  void _mutation(List<dynamic> mutations, MutationObserver observer) {
    for (dynamic mutation in mutations) {
      for (Node node in (mutation as MutationRecord).addedNodes) {
        if (node is Element) {
          ElementList images = node.querySelectorAll("img");

          for (ImageElement img in images) {
            StreamSubscription loadSub;
            loadSub = img.onLoad.listen((_) {
              _scrollToBottom();

              if (loadSubs.containsKey(loadSub)) {
                loadSub.cancel();
                loadSubs.remove(loadSub);
              }
            });

            loadSubs[loadSub] = true;
          }
        }
      }
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Element _elHtml = window.document.querySelector('html');
    Element _elBody = window.document.querySelector('body');
    _elHtml.scrollTop = _elHtml.scrollHeight;
    _elBody.scrollTop = _elBody.scrollHeight;
  }

  void handleKeyPress() {
    int inputHeight = window.document.querySelector('.bottom-part').offsetHeight;
    if (exheight != inputHeight) {
      exheight = inputHeight;
      window.document.querySelector('.offer-message').style.paddingBottom = (inputHeight + 15).toString() + 'px';
      _scrollToBottom();
    }
  }

  void handleCreateOffer() {
    if (offer == null || urlError != '') {
      return;
    }
    var newOffer = Offer(
      id: '',
      name: '',
      price: 0,
      priceText: '',
      description: '',
      imageUrl: '',
      ticker: '',
      offerName: '',
      offerSiteName: offer.offerSiteName,
      context: Context(
        promotorId: offer.context.promotorId,
        cChatId: '',
        clientName: '',
        customerId: '',
      ),
    );
    _messagingBloc.dispatch(CreateOffer(offer: newOffer));
  }

  void handleFileChange(FileList files) async {
    attachedFileType = '';
    attachedImageSrc = '';
    attachedBlob = null;
    attachedFileName = '';
    showSendButton = false;
    if (files.isNotEmpty) {
      attachedBlob = files.first;
      attachedFileName = files.first.name;
      if (attachedBlob.type.startsWith('image/')) {
        attachedFileType = 'image';
        var imageReader = FileReader()..readAsDataUrl(attachedBlob);
        
        await imageReader.onLoadEnd.first;
        String dataUrl = imageReader.result;

        var image = ImageElement();
        image.src = dataUrl;
        await image.onLoad.first;

        int width = image.width;
        int height = image.height;
        bool shouldResized = false;
        if (width >= height && width > 1000) {
          height = height * 1000 ~/ width;
          width = 1000;
        }
        else if (height > 1000) {
          shouldResized = true;
          width = width * 1000 ~/ height;
          height = 1000;
        }

        Map<String, dynamic> tags = await readExifFromBlob(files.first);
        bool shouldRotated = tags != null && tags['Orientation'] != null;
        int orientation = shouldRotated ? (tags['Orientation'] as int) : 0;
        if (shouldResized || shouldRotated) {
          var canvas = CanvasElement();
          CanvasRenderingContext2D ctx = canvas.getContext('2d');

          if (orientation > 4 && orientation < 9) {
            canvas.width = height;
            canvas.height = width;
          } else {
            canvas.width = width;
            canvas.height = height;
          }

          if (shouldRotated) {
            switch (orientation) {
              case 2: ctx.transform(-1, 0, 0, 1, width, 0); break;
              case 3: ctx.transform(-1, 0, 0, -1, width, height); break;
              case 4: ctx.transform(1, 0, 0, -1, 0, height); break;
              case 5: ctx.transform(0, 1, 1, 0, 0, 0); break;
              case 6: ctx.transform(0, 1, -1, 0, height, 0); break;
              case 7: ctx.transform(0, -1, -1, 0, height, width); break;
              case 8: ctx.transform(0, -1, 1, 0, 0, width); break;
              default: break;
            }
          }

          ctx.drawImageScaled(image, 0, 0, width, height);
          attachedImageSrc = canvas.toDataUrl(files.first.type);
          attachedBlob = await canvas.toBlob(files.first.type);
        } else {
          attachedImageSrc = dataUrl;
        }
      }
      else if (attachedBlob.type.startsWith('audio/')) {
        attachedFileType = 'audio';
      }
      else if (attachedBlob.type.startsWith('video/')) {
        attachedFileType = 'video';
      }
      else {
        attachedFileType = 'other';
      }
      showSendButton = true;
    }
  }

  void handleCloseAttach() {
    attachedFileType = '';
    attachedImageSrc = '';
    attachedBlob = null;
    showSendButton = false;
  }

  void handleUploading(int percent) {
    isUploading = true;
    progressValue = percent;
  }

  void handleFinishedUploading() {
    isUploading = false;
    progressValue = 0;
    attachedBlob = null;
    attachedFileType = '';
    attachedImageSrc = '';
    showSendButton = false;
  }

  void handleMicClicked() {
    audioBlob = null;
    window.navigator.getUserMedia(audio: true, video: false).then(handleAudioSuccess).catchError(handleAudioError);
  }

  void handleAudioError(dynamic error) {
		window.alert('Unable to access the microphone.');
  }

  void handleAudioSuccess(MediaStream stream) {
    audioStream = stream;
    AudioContext context = AudioContext();
    source = context.createMediaStreamSource(stream);
    processor = context.createScriptProcessor(buffersize, 1, 1);

    source.connectNode(processor);
    processor.connectNode(context.destination);

    processor.onAudioProcess.listen((AudioProcessingEvent event) {
      // print(event.inputBuffer.toString());
      if (!isRecording) {
        return;
      }

      recordedData.add(Float32List.fromList(event.inputBuffer.getChannelData(0)));
      recordedLength += event.inputBuffer.getChannelData(0).length;
    });

    isRecording = true;
    showingMic = true;
    startedTime = DateTime.now();
    inputText = '00:00';
    sampleRate = context.sampleRate;
    recordedData = List();
    recordedLength = 0;

    micTimer = Timer.periodic(Duration(milliseconds: 500), (Timer val) {
      showingMic = !showingMic;
      int seconds = DateTime.now().difference(startedTime).abs().inSeconds;
      int minutes = seconds ~/ 60;
      seconds = seconds % 60;
      String str = (minutes > 9 ? '' : '0') + minutes.toString() + ':';
      str += (seconds > 9 ? '' : '0') + seconds.toString();
      inputText = str;
    });
  }

  void handleCancelClicked() {
    isRecording = false;
    showingMic = false;
    micTimer.cancel();
    inputText = '';
    showSendButton = false;
    source.disconnect();
    processor.disconnect();
    // audioStream.getAudioTracks().forEach((MediaStreamTrack track) => track.stop());
    var tracks = audioStream.getTracks();
    for (int i = 0; i < tracks.length; i++) {
      tracks[i].stop();
    }
    audioStream = null;
  }

  void makeWavBlob() {
    Float32List data = Float32List(recordedLength);
    int offset = 0;
    for (int i = 0; i < recordedData.length; i++) {
      Float32List buffer = recordedData[i];
      data.setRange(offset, offset + buffer.length, buffer);
      offset += buffer.length;
    }

    int dataLength = data.length;

    // create wav file
    // var buffer = new ArrayBuffer(44 + dataLength * 2);
    var view = ByteData(44 + dataLength * 2);
    // var view = new DataView(buffer);

    writeUTFBytes(view, 0, 'RIFF'); // RIFF chunk descriptor/identifier
    view.setUint32(4, 44 + dataLength * 2, Endian.little); // RIFF chunk length
    writeUTFBytes(view, 8, 'WAVE'); // RIFF type
    writeUTFBytes(view, 12, 'fmt '); // format chunk identifier, FMT sub-chunk
    view.setUint32(16, 16, Endian.little); // format chunk length
    view.setUint16(20, 1, Endian.little); // sample format (raw)
    view.setUint16(22, 1, Endian.little); // mono (1 channel)
    view.setUint32(24, sampleRate, Endian.little); // sample rate
    view.setUint32(28, sampleRate * 2, Endian.little); // byte rate (sample rate * block align)
    view.setUint16(32, 2, Endian.little); // block align (channel count * bytes per sample)
    view.setUint16(34, 16, Endian.little); // bits per sample
    writeUTFBytes(view, 36, 'data'); // data sub-chunk identifier
    view.setUint32(40, dataLength * 2, Endian.little); // data chunk length

    // write the PCM samples
    var index = 44;
    for (var i = 0; i < dataLength; i++) {
      view.setInt16(index, (data[i] * 0x7FFF).toInt(), Endian.little);
      index += 2;
    }

    audioBlob = Blob([view], 'audio/wav');
  }

  void writeUTFBytes(ByteData view, int offset, String string) {
    var lng = string.length;
    for (var i = 0; i < lng; i++) {
      view.setUint8(offset + i, string.codeUnitAt(i));
    }
  }

  void getImageOrientation(String url) {
    if (url != '') {
      
    }
  }
}