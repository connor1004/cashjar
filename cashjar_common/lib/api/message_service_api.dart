import 'package:cashjar_common/model/message.dart';

abstract class MessageServiceApi{
  Stream<List<Message>> getMessageList(String offerId);
  
  Stream<Message> getMessage(String offerId, String uid);
  
  Future<void> createMessage(String offerId, Message message);
  
  Future<void> deleteMessage(String offerId, String uid);

  Future<void> updateMessage(String offerId, Message message);
}