import 'dart:async';

import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase.dart';

@Injectable()
class FireBaseService {
  FireBaseService();

  fb.DatabaseReference ref;

  static App CashJarFirebaseApp;

  static App get CashJarApp => CashJarFirebaseApp;

  static set setCashJarApp(App CashJarApp) {
    FireBaseService.CashJarFirebaseApp = CashJarApp;
  }

  /// Firebase credentials for CashJar app
  static String API_KEY = "AIzaSyB0QhiKwIatBH3pQT7UoikK8PjEI1Helc0";
  static String AUTH_DOMAIN = "cashjarapp.firebaseapp.com";
  static String DATABASE_URL = "https://cashjarapp.firebaseio.com";
  static String STORAGE_BUCKET = "cashjarapp.appspot.com";
  static String PROJECT_ID = "cashjarapp";

  Future initFirebase() async {
    try {
      final App CashJarApp = await fb.initializeApp(
        apiKey: API_KEY,
        authDomain: AUTH_DOMAIN,
        databaseURL: DATABASE_URL,
        projectId: PROJECT_ID,
        storageBucket: STORAGE_BUCKET,
      );
      setCashJarApp = CashJarApp;
    } catch (e) {
      print(e.toString());
    }
  }
}
