import 'package:cashjar_common/model/offer.dart';

abstract class OfferServiceApi {
  Stream<Offer> getOfferStream(String offerId);

  Future<Offer> getOffer(String offerId);

  Future<String> createOffer(Offer offer);
  
  // Future<void> deleteOffer(String uid);

  Future<void> updateOffer(Offer offer);
}