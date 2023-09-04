import 'dart:html';

import 'package:cashjar_common/model/message.dart';
import 'package:cashjar_common/model/offer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MessagingEvent extends Equatable {
  MessagingEvent([List props = const []]) : super(props);
}

class LoadInitialData extends MessagingEvent {
  final String offerId;

  LoadInitialData({@required this.offerId})
    : super([offerId]);

  @override
  String toString() {
    return 'LoadInitialData { offerId: $offerId }';
  }
}

class UpdateData extends MessagingEvent {
  final Offer offer;
  final List<Message> messages;

  UpdateData({this.offer, this.messages}) : super([offer, messages]);

  @override
  String toString() {
    return 'UpdateData { offer: $offer, messages: $messages }';
  }
}

class InvalidOfferId extends MessagingEvent {
  final String error;

  InvalidOfferId({@required this.error})
    : super([error]);

  @override
  String toString() {
    return 'InvalidOfferId { error: $error }';
  }
}

class CreateMessage extends MessagingEvent {
  final Message message;
  final Blob blob;
  final Function onUploading;
  final Function onFinished;
  final Blob audioBlob;

  CreateMessage({@required this.message, this.blob, this.onUploading, this.onFinished, this.audioBlob})
      : super([message, blob, onFinished, onUploading, audioBlob]);

  @override
  String toString() {
    return 'CreateMessage { message: $message }';
  }
}

class UpdateMessage extends MessagingEvent {
  final Message message;
  final Blob blob;
  final Function onUploading;
  final Function onFinished;
  final Blob audioBlob;

  UpdateMessage({@required this.message, this.blob, this.onUploading, this.onFinished, this.audioBlob})
      : super([message, blob, onFinished, onUploading, audioBlob]);

  @override
  String toString() {
    return 'UpdateMessage { message: $message }';
  }
}

class DeleteMessage extends MessagingEvent {
  final Message message;

  DeleteMessage({@required this.message})
      : super([message]);

  @override
  String toString() {
    return 'DeleteMessage { message: $message }';
  }
}

class CreateOffer extends MessagingEvent {
  final Offer offer;

  CreateOffer({@required this.offer})
      : super([offer]);

  @override
  String toString() {
    return 'CreateOffer { offer: $offer }';
  }
}