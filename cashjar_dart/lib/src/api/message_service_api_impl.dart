import 'package:cashjar_common/model/message.dart';
import 'package:cashjar_common/api/message_service_api.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:firebase/firestore.dart' as fs;

class MessageServiceApiImple extends MessageServiceApi {
  @override
  Stream<List<Message>> getMessageList(String offerId) {
    fs.Firestore firestore = firebase.firestore();
    return firestore.collection('offers/' + offerId + '/messages').orderBy('sentOn', 'asc').onSnapshot.map(
      (QuerySnapshot query) =>
        query.docs
          .map((DocumentSnapshot document) {
            Message message = Message.fromMap(document.data());
            message.id = document.id;
            return message;
          })
          .toList());
  }
  
  @override
  Stream<Message> getMessage(String offerId, String uid) {
    try {
      fs.Firestore firestore = firebase.firestore();
      return firestore.collection('offers/' + offerId + '/messages').doc(uid).onSnapshot.map(
        (DocumentSnapshot documentSnapshot) {
          Message message = Message.fromMap(documentSnapshot.data());
          message.id = documentSnapshot.id;
          return message;
        });
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  @override
  Future<void> createMessage(String offerId, Message message) async {
    try {
      fs.Firestore firestore = firebase.firestore();
      await firestore.collection('offers/' + offerId + '/messages').add(message.toMap());
    } catch (e, s) {
      print('createMessage error: $e, $s');
      return Future.error(e);
    }
  }
  
  @override
  Future<void> deleteMessage(String offerId, String uid) async {
    try {
      fs.Firestore firestore = firebase.firestore();
      await firestore.collection('offers/' + offerId + '/messages').doc(uid).delete();
    } catch (e, s) {
      print('deleteMessage error: $e, $s');
      return Future.error(e);
    }
  }

  @override
  Future<void> updateMessage(String offerId, Message message) async {
    try {
      fs.Firestore firestore = firebase.firestore();
      await firestore.collection('offers/' + offerId + '/messages').doc(message.id).set(message.toMap());
    } catch (e, s) {
      print('updateMessage error: $e, $s');
      return Future.error(e);
    }
  }
}