import 'package:cashjar_common/model/message.dart';
import 'package:cashjar_common/model/offer.dart';
import 'package:meta/meta.dart';

@immutable
class MessagingState {
  final bool isLoading;
  final List<Message> messages;
  final Offer offer;

  MessagingState(
      {this.isLoading = false,
      this.messages = const [],
      this.offer});

  MessagingState idle() => copyWith(isLoading: false);

  MessagingState loading() => copyWith(isLoading: true);

  MessagingState update({List<Message> messages, Offer offer}) =>
      copyWith(messages: messages, offer: offer);

  MessagingState copyWith({List<Message> messages, Offer offer, bool isLoading, bool isUploading, int uploadPercent}) {
    return MessagingState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      offer: offer ?? this.offer,
    );
  }
}

class MessagingFailure extends MessagingState {
  final String error;

  MessagingFailure({@required this.error}) : super();

  @override
  String toString() => 'MessagingFailure { error: $error }';
}

class CreateOfferSuccess extends MessagingState {
  final String offerId;

  CreateOfferSuccess({@required this.offerId}) : super();

  @override
  String toString() => 'CreateOfferSuccess { offerId: $offerId }';
}