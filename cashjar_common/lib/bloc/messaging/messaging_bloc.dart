import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cashjar_common/api/message_service_api.dart';
import 'package:cashjar_common/api/offer_service_api.dart';
import 'package:cashjar_common/api/storage_service_api.dart';
import 'package:cashjar_common/model/message.dart';
import 'package:cashjar_common/model/offer.dart';
// import 'package:meta/meta.dart';
import './messaging_event.dart';
import './messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessageServiceApi _messageService;
  final OfferServiceApi _offerServiceApi;
  final StorageServiceApi _storageServiceApi;

  MessagingBloc(this._messageService, this._offerServiceApi, this._storageServiceApi);

  @override
  MessagingState get initialState => MessagingState();

  @override
  Stream<MessagingState> mapEventToState(MessagingEvent event) async* {
    if (event is LoadInitialData) {
      yield currentState.loading();
      _loadData(event.offerId);
    }
    else if (event is UpdateData) {
      yield currentState.update(offer: event.offer, messages: event.messages);
      yield currentState.idle();
    }
    else if (event is CreateMessage) {
      yield currentState.loading();
      try {
        if (event.blob != null) {
          String url = await _storageServiceApi.uploadFilePercent('messages', event.message.filename, event.blob, event.onUploading, event.onFinished);
          event.message.url = url;
        }
        else if (event.audioBlob != null) {
          String url = await _storageServiceApi.uploadBlob('messages/voices', 'voice.wav', event.audioBlob);
          event.message.url = url;
        }
        await _messageService.createMessage(currentState.offer.id, event.message);
        yield currentState.idle();
      } catch (e) {
        print(e);
        yield MessagingFailure(error: 'Unable to create the message');
      }
    } else if (event is UpdateMessage) {
      yield currentState.loading();
      try {
        if (event.blob != null) {
          String url = await _storageServiceApi.uploadFilePercent('messages',  event.message.filename, event.blob, event.onUploading, event.onFinished);
          event.message.url = url;
        }
        await _messageService.updateMessage(currentState.offer.id, event.message);
        yield currentState.idle();
      } catch (e) {
        print(e);
        yield MessagingFailure(error: 'Unable to update the message');
      }
    } else if (event is DeleteMessage) {
      yield currentState.loading();
      try {
        await _messageService.deleteMessage(currentState.offer.id, event.message.id);
        yield currentState.idle();
      } catch (e) {
        print(e);
        yield MessagingFailure(error: 'Unable to delete the message');
      }
    } else if (event is InvalidOfferId) {
      yield MessagingFailure(error: event.error);
    } else if (event is CreateOffer) {
      yield currentState.loading();
      try {
        String offerId = await _offerServiceApi.createOffer(event.offer);
        yield CreateOfferSuccess(offerId: offerId);
      } catch(e) {
        print(e);
        yield MessagingFailure(error: 'Unable to create a new offer');
      }
    }
  }

  void _loadData(String offerId) {
    try {
      _messageService.getMessageList(offerId).listen((List<Message> messages) {
        dispatch(UpdateData(messages: messages));
      });
      _offerServiceApi.getOfferStream(offerId).listen((Offer offer) {
        if (offer == null) {
          dispatch(InvalidOfferId(error: 'Offer with id: $offerId does not exist!'));
        }
        dispatch(UpdateData(offer: offer));
      });
    } catch (e) {
      print(e);
    }
  }
}
