import 'package:cashjar_common/model/message.dart';
import 'package:cashjar_common/model/offer.dart';
import 'package:meta/meta.dart';

@immutable
class OfferState {
  final bool isLoading;
  final Offer offer;

  OfferState(
      {this.isLoading = false,
      this.offer});

  OfferState idle() => copyWith(isLoading: false);

  OfferState loading() => copyWith(isLoading: true);

  OfferState update({Offer offer}) =>
      copyWith(offer: offer);

  OfferState copyWith({Offer offer, bool isLoading}) {
    return OfferState(
      isLoading: isLoading ?? this.isLoading,
      offer: offer ?? this.offer,
    );
  }
}

class OfferFailure extends OfferState {
  final String error;

  OfferFailure({@required this.error}) : super();

  @override
  String toString() => 'OfferFailure { error: $error }';
}