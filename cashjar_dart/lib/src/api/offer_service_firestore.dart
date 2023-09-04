// import 'dart:html';
// import 'dart:io';
import 'package:cashjar_common/api/offer_service_api.dart';
import 'package:cashjar_common/model/offer.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:firebase/firestore.dart' as fs;

class OfferServiceFirestore extends OfferServiceApi {
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

  @override
  Future<Offer> getOffer(String offerId) async {
    try {
      fs.Firestore firestore = firebase.firestore();
      Offer offer;
      await firestore.collection('offers').doc(offerId).get().then((DocumentSnapshot docSnap) {
        offer = Offer.fromMap(docSnap.data());
        offer.id = docSnap.id;
      }).catchError((error) {
        print('error in getting offer: ' + error.toString());
      });
      return offer;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<String> createOffer(Offer offer) async {
    try {
      String offerId;
      fs.Firestore firestore = firebase.firestore();
      await firestore.collection('offers').add(offer.toMap()).then((docRef) {
        offerId = docRef.id;
      }).catchError((err) {
        print('createOffer error: $err');
        offerId = null;
      });
      return offerId;
    } catch (e, s) {
      print('createMessage error: $e, $s');
      return null;
    }
  }

  @override
  Future<void> updateOffer(Offer offer) async {
    try {
      fs.Firestore firestore = firebase.firestore();
      await firestore.collection('offers').doc(offer.id).set(offer.toMap());
    } catch (e, s) {
      print('updateMessage error: $e, $s');
      return Future.error(e);
    }
  }
}