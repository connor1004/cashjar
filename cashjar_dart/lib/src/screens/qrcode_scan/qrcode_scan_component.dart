import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:cashjar_dart/src/screens/qrcode_scan/QRReader.dart';
import 'package:cashjar_dart/src/services/title_service.dart';

@Component(
  selector: 'qrcode-scan',
  templateUrl: 'qrcode_scan_component.html',
  styleUrls: ['qrcode_scan_component.css'],
  directives: [coreDirectives, MaterialFabComponent, MaterialIconComponent],
  providers: [materialProviders],
)
class QrcodeScanComponent implements OnActivate {
  final TitleService _titleService;
  String imageUrl = '';
  QRReader _reader;

  QrcodeScanComponent(this._titleService);

  @override
  void onActivate(RouterState previous, RouterState current) {
    _titleService.title = '';
    _titleService.showTitle = false;
    _reader = QRReader(callback: handleQrCodeScanned);
    _reader.init();
    Timer(Duration(seconds: 1), () {
      if (MediaStream.supported) {
        scan(false);
      }
    });
  }

  void handleQrCodeScanned(String qrcode) {
    print('scanned qrcode : $qrcode');
    window.alert('scanned qrcode: $qrcode');
  }

  void handleFileChange(FileList files) async {
    if (files.isNotEmpty && files.first.type.startsWith('image/')) {
      var imageReader = FileReader()..readAsDataUrl(files.first);
      await imageReader.onLoadEnd.first;
      imageUrl = imageReader.result;
      Timer.run(() => scan(true));
    }
    else {
      imageUrl = '';
      _reader.stopScanning();
      Timer.run(() {
        if (MediaStream.supported) {
          scan(false);
        }
      });
    }
  }

  void scan(bool forSelectedPhotos) {
    _reader.scan(forSelectedPhotos);
  }
}