import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;

@Injectable()
class AuthService {
  fb.User user;
  fb.GoogleAuthProvider fbGoogleAuthProvider;
  fb.Auth _fbAuth;
  
  AuthService() {
    _fbAuth = fb.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
  }
  
  Future getCurrentUser() async {
    if (user == null) {
      await for (var newUser in _fbAuth.onAuthStateChanged) {
        user = newUser;
        return newUser;
      }
    } else {
      return user;
    }
  }
  
  void _authChanged(fb.User fbUser) {
    user = fbUser;
  }

  Future<bool> isLoggedIn() async {
    fb.User currentUser = await getCurrentUser();
    return currentUser != null;
  }

  Future signOut() async {
    await _fbAuth.signOut();
  }
}