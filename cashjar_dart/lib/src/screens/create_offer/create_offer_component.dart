@JS()
library create_offer_component;

import 'dart:async';

import 'package:cashjar_dart/src/routes/routes.dart';
import 'package:exifdart/exifdart_html.dart';
import 'package:js/js.dart';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_router/angular_router.dart' as prefix0;
import 'package:cashjar_dart/src/api/storage_service_api_impl.dart';
import 'package:cashjar_dart/src/services/title_service.dart';
import 'dart:html';
import 'package:angular_components/angular_components.dart';
import 'package:cashjar_common/model/offer.dart';
import 'package:cashjar_common/bloc/create_offer/create_offer.dart';
import 'package:cashjar_dart/src/api/offer_service_firestore.dart';
import 'package:cashjar_dart/src/components/message_input/message_input_component.dart';

import 'dart:js';
import 'dart:convert';
 
// @JS("dynamsoft.BarcodeReader")
// class DynamsoftBarcodeReader {
//   external factory DynamsoftBarcodeReader();
//   external Promise<JsArray> decodeFileInMemory(File file);
// }

// @JS()
// class Promise<T> {
//   external Promise then(Function(T result));
// }

@JS("JSON.stringify")
external String stringify(obj);

@Component(
  selector: 'create-offer',
  templateUrl: 'create_offer_component.html',
  styleUrls: ['create_offer_component.css'],
  directives: [
    coreDirectives,
    materialDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    MessageInputComponent
  ],
  providers: [materialProviders, ClassProvider(CreateOfferBloc), prefix0.Location, StorageServiceApiImpl]
)
class CreateOfferComponent implements OnActivate {
  Offer offer;
  String offerId = '';
  String userId = '';
  String inputText = "";
  String publishLink = "";

  CreateOfferBloc _offerBloc;
  String urlError = "";
  bool syntaxError = false;
  String imageClass = "";

  int exheight = 0;
  
  final TitleService _titleService;
  String backUrl = '';
  final prefix0.Location _location;
  final StorageServiceApiImpl _storageService;
  final Router _router;
  // DynamsoftBarcodeReader reader;
  Timer timer;
  String showNoBarcodes = '';

  CreateOfferComponent(this._titleService, this._location, this._storageService, this._router);

  @override
  void onActivate(RouterState prev, RouterState current) {
    _titleService.showTitle = true;
    backUrl = '';
    if (prev != null) {
      backUrl = prev.toUrl();
    }

    Map<String, String> queryParams = current.queryParameters;
    
    if (queryParams.isEmpty || queryParams['offer'] == null) {
      urlError = "Please provide an offer";
      return;
    } else {
      if (queryParams['promotor'] != null) {
        userId = queryParams['promotor'];
      }
      else {
        urlError = "Please provide promotor";
        return;
      }
    }

    urlError = "";
    
    _offerBloc = CreateOfferBloc(OfferServiceFirestore());
    _offerBloc.dispatch(LoadOffer(offerId: queryParams['offer']));
    _offerBloc.state.listen((state) {
      if (state is OfferFailure) {
        urlError = state.error;
      }
      else if (state.isLoading) {

      }
      else {
        offer = state.offer;
        
        String title = 'Offer';
        if (offer != null) {
          urlError = "";
          if (userId != offer.context.promotorId) {
            urlError = "Invalid promotor: $userId!";
          }
          if (offer.offerSiteName != '') {
            title = offer.offerSiteName;
          }
          if (offer.offerName != '') {
            title += ' - ' + offer.offerName;
          }

          publishLink = "https://cashjar.app/?offer=${offer.id}&client=${offer.context.cChatId}";
        }
        else {
          publishLink = "";
        }
        
        window.document.querySelector("title").setInnerHtml(title);
        _titleService.title = title;
      }
    });

    // reader = DynamsoftBarcodeReader();
  }

  void updateOffer() {
    String text = inputText.trim();
    if (text.isEmpty) {
      return;
    }
    bool updated = false;
    Map<String, dynamic> offerMap = offer.toMap();
    Map<String, String> keyMap = {
      'title': 'name',
      'priceText': 'priceText',
      'desc': 'description',
      'offerName': 'offerName',
    };
    keyMap.forEach((key, value) {
      if (text.startsWith('set #$key ')) {
        updated = true;
        offerMap[value] = text.substring('set #$key '.length);
      }
    });
    if (!updated) {
      Map<String, String> contextKeyMap = {
        'client': 'cChatId',
        'customerId': 'customerId',
        'clientName': 'clientName'
      };
      contextKeyMap.forEach((key, value) {
        if (text.startsWith('set #$key ')) {
          updated = true;
          offerMap['context'][value] = text.substring('set #$key '.length);
        }
      });
    }
    
    if (updated) {
      _offerBloc.dispatch(UpdateOffer(offer: Offer.fromMap(offerMap)));
      inputText = "";
      if (exheight > 100) {
        exheight = 90;
        window.document.querySelector('.offer-message').style.paddingBottom = (exheight + 15).toString() + 'px';
      }
      syntaxError = false;
    }
    else if (text != '') {
      syntaxError = true;
    }
    else {
      syntaxError = false;
    }
  }
  
  void handleKeyPress() {
    int inputHeight = window.document.querySelector('.bottom-part').offsetHeight;
    if (exheight != inputHeight) {
      exheight = inputHeight;
      window.document.querySelector('.offer-message').style.paddingBottom = (inputHeight + 15).toString() + 'px';
    }
  }

  void handleCloseButton() {
    _location.back();
  }

  void setImage(FileList files) async {
    if (files.isNotEmpty && files.first.type.startsWith('image/')) {
      Blob imageBlob = files.first;
      var imageReader = FileReader()..readAsDataUrl(files.first);
        
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
        imageBlob = await canvas.toBlob(files.first.type);
      }

      String imageUrl = await _storageService.uploadBlob('offers', files.first.name, imageBlob);
      Offer updatedOffer = Offer.fromMap(offer.toMap());
      updatedOffer.imageUrl = imageUrl;
      _offerBloc.dispatch(UpdateOffer(offer: updatedOffer));
    }
  }

  void handleButtonClick(String key) {
    inputText = 'set #$key ';
  }

  void handleCameraChange(FileList files) {
    // if (files.isNotEmpty && files.first.type.startsWith('image/') && reader != null) {
    //   reader.decodeFileInMemory(files.first).then(
    //     allowInterop(getResults)
    //   );
    // }
  }

  void getResults(JsArray barcodes) {
    int len = barcodes.length;
    if (len < 1) {
      showNoBarcodes = 'show';
      if (timer != null && timer.isActive) {
        timer.cancel();
      }
      timer = Timer(Duration(seconds: 3), () {
        showNoBarcodes = '';
      });
      return;
    }
    var json = jsonDecode(stringify(barcodes));
    window.open("https://lumbungrempah123.web.app/commodity/create?ptani=$userId&qrCode=${json[0]['BarcodeText']}", '_blank');
  }

  void handleCameraClicked() {
    _router.navigate(
      RoutePaths.qrcodeScan.toUrl()
    );
  }
}