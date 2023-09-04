// import 'dart:html';
// import 'dart:io';
import 'package:cashjar_common/api/offer_service_api.dart';
import 'package:cashjar_common/model/offer.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:firebase/firestore.dart' as fs;

// import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_web.dart';
import 'package:cashjar_dart/src/protobuf/cashjar.pbgrpc.dart' as grpc;
import 'package:cashjar_dart/src/protobuf/cashjar.pb.dart' as pb;

const serverIp = "35.222.8.249";
const serverPort = 80;

class OfferServiceApiImpl extends OfferServiceApi {
  GrpcWebClientChannel _clientChannel;
  // ClientChannel _clientChannel;
  grpc.OfferServiceClient _client;

  @override
  Stream<Offer> getOfferStream(String offerId) {
    try {
      fs.Firestore firestore = firebase.firestore();
      return firestore.collection('offers').doc(offerId).onSnapshot.map(
          (DocumentSnapshot documentSnapshot) {
              if (!documentSnapshot.exists) {
                return null;
              }
              Offer offer = Offer.fromMap(documentSnapshot.data());
              offer.id = documentSnapshot.id;
              return offer;
          });
              
    } catch (e) {
      print(e);
      return null;
    }
  }

  void createClientChannel() {
    if (_clientChannel == null) {
      _clientChannel = GrpcWebClientChannel.xhr(Uri.parse('http://35.222.8.249'));
      _client = grpc.OfferServiceClient(_clientChannel, options: CallOptions(
        timeout: Duration(seconds: 10),
      ));
      // _clientChannel = ClientChannel(
      //   serverIp,
      //   port: serverPort,
      //   options: ChannelOptions(
      //     credentials: ChannelCredentials.insecure(),
      //     idleTimeout: Duration(seconds: 10),
      //   )
      // );
    }
  }

  @override
  Future<Offer> getOffer(String offerId) async {
    createClientChannel();

    pb.OfferId request = pb.OfferId.create();
    request.id = offerId;
    pb.Offer pbOffer = await _client.getOffer(request);
    if (pbOffer != null) {
      Offer offer = Offer(
        id: pbOffer.id,
        name: pbOffer.name,
        price: pbOffer.price.toInt(),
        priceText: pbOffer.priceText,
        description: '',
        imageUrl: pbOffer.imageUrl,
        ticker: pbOffer.ticker,
        offerName: pbOffer.offerName,
        offerSiteName: pbOffer.offerSiteName,
        context: Context(
          cChatId: pbOffer.offerContext.cChatId,
          clientName: pbOffer.offerContext.clientName,
          customerId: pbOffer.offerContext.customerId,
          promotorId: pbOffer.offerContext.promotorId,
        ),
      );
      return offer;
    } else {
      return null;
    }
  }

  @override
  Future<String> createOffer(Offer offer) async {
    createClientChannel();
    pb.Offer pbOffer = getPbOffer(offer);
    print('before call grpc service');
    // pb.OfferResponse response = await _client.createOffer(pbOffer);
    String offerId;

    await _client.createOffer(pbOffer).then((value) {
      print('offer creation success:' + value.toString());
      offerId = value.id;
    }).catchError((error) {
      print('error in offer creation:' + error.toString());
      offerId = null;
    });

    print('after call grpc service, offerId:' + offerId);
    return offerId;
  }
  
  // @override
  // Future<void> deleteOffer(String uid) async {

  // }

  @override
  Future<void> updateOffer(Offer offer) async {
    createClientChannel();
    var response = await _client.updateOffer(getPbOffer(offer));
    if (response == null) {
      return Future.error('error in updating offer');
    }
  }

  Offer getDartOffer(pb.Offer pbOffer) {
    return Offer(
        id: pbOffer.id,
        name: pbOffer.name,
        price: pbOffer.price.toInt(),
        priceText: pbOffer.priceText,
        description: '',
        imageUrl: pbOffer.imageUrl,
        ticker: pbOffer.ticker,
        offerName: pbOffer.offerName,
        offerSiteName: pbOffer.offerSiteName,
        context: Context(
          cChatId: pbOffer.offerContext.cChatId,
          clientName: pbOffer.offerContext.clientName,
          customerId: pbOffer.offerContext.customerId,
          promotorId: pbOffer.offerContext.promotorId,
        ),
      );
  }

  pb.Offer getPbOffer(Offer offer) {
    pb.Offer pbOffer = pb.Offer.create();
    pbOffer.id = offer.id;
    pbOffer.name = offer.name;
    pbOffer.price = offer.price.toDouble();
    pbOffer.priceText = offer.priceText;
    // pbOffer.description = offer.description;
    pbOffer.imageUrl = offer.imageUrl;
    pbOffer.ticker = offer.ticker;
    pbOffer.offerName = offer.offerName;
    pbOffer.offerSiteName = offer.offerSiteName;
    pb.OfferContext pbContext = pb.OfferContext.create();
    pbContext.cChatId = offer.context.cChatId;
    pbContext.clientName = offer.context.clientName;
    pbContext.customerId = offer.context.customerId;
    pbContext.promotorId = offer.context.promotorId;
    pbOffer.offerContext = pbContext;
    return pbOffer;
  }
}