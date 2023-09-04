import 'package:cashjar_common/model/offer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OfferEvent extends Equatable {
  OfferEvent([List props = const []]) : super(props);
}

class LoadOffer extends OfferEvent {
  final String offerId;

  LoadOffer({@required this.offerId})
    : super([offerId]);

  @override
  String toString() {
    return 'LoadOffer { offerId: $offerId }';
  }
}

class UpdateOffer extends OfferEvent {
  final Offer offer;

  UpdateOffer({@required this.offer})
      : super([offer]);

  @override
  String toString() {
    return 'UpdateOffer { offer: $offer }';
  }
}