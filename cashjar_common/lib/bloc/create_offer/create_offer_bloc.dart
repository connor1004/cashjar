import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cashjar_common/api/offer_service_api.dart';
import 'package:cashjar_common/model/offer.dart';
// import 'package:meta/meta.dart';
import './create_offer_event.dart';
import './create_offer_state.dart';

class CreateOfferBloc extends Bloc<OfferEvent, OfferState> {
  final OfferServiceApi _offerService;
  // final StorageServiceApi _storageServiceApi;

  CreateOfferBloc(this._offerService);

  @override
  OfferState get initialState => OfferState();

  @override
  Stream<OfferState> mapEventToState(OfferEvent event) async* {
    if (event is LoadOffer) {
      yield currentState.loading();
      try {
        Offer offer = await _offerService.getOffer(event.offerId);
        yield currentState.update(offer: offer);
        yield currentState.idle();
      } catch (e) {
        print(e);
        yield OfferFailure(error: 'Unable to get the offer');
      }
    }
    else if (event is UpdateOffer) {
      yield currentState.loading();
      try {
        await _offerService.updateOffer(event.offer);
        yield currentState.update(offer: event.offer);
        yield currentState.idle();
      } catch (e) {
        print(e);
        yield OfferFailure(error: 'Unable to update the offer');
      }
    }
  }
}
