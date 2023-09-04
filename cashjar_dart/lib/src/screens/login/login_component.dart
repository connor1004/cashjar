import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_router/angular_router.dart' as prefix0;
import 'package:cashjar_dart/src/services/auth_service.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_dart_ui/firebase_dart_ui.dart';
import 'package:firebase/src/interop/firebase_interop.dart';

import "dart:html";

import 'package:js/js.dart';

import 'dart:js';

@Component(
  selector: 'login',
  templateUrl: 'login_component.html',
  styleUrls: ['login_component.css'],
  directives: [FirebaseAuthUIComponent]
)
class LoginComponent implements CanActivate {
  AuthService _authService;
  Router _router;
  prefix0.Location _location;

  LoginComponent(this._router, this._authService, this._location);

  UIConfig _uiConfig;

  Future<Null> logout() async {
    await _authService.signOut();
    // providerAccessToken = "";
  }


  // todo: We need to create a nicer wrapper for the sign in callbacks.
  PromiseJsImpl<void>  signInFailure(AuthUIError authUiError) {
    // nothing to do;
    return PromiseJsImpl<void>( () => print("SignIn Failure"));
  }

  // Example SignInSuccess callback handler
  bool signInSuccess(fb.UserCredential authResult, String redirectUrl) {
    print("sign in  success. ProviderID =  ${authResult.credential.providerId}");
    print("Info= ${authResult.additionalUserInfo}");
    _location.back();
    // returning false gets rid of the double page load (no need to redirect to /)
    return false;
  }

  /// Your Application must provide the UI configuration for the
  /// AuthUi widget. This is where you configure the providers and options.
  UIConfig getUIConfig() {
    if (_uiConfig == null) {
      var googleOptions = CustomSignInOptions(
          provider: fb.GoogleAuthProvider.PROVIDER_ID,
          scopes: ['email', 'https://www.googleapis.com/auth/plus.login'],
          customParameters:
              GoogleCustomParameters(prompt: 'select_account'));

      var callbacks = Callbacks(
          uiShown: () => print("UI shown callback"),
          signInSuccessWithAuthResult: allowInterop(signInSuccess),
          signInFailure: signInFailure
      );


      _uiConfig = UIConfig(
          signInSuccessUrl: '/',
          signInOptions: [
            googleOptions
          ],
          signInFlow: "redirect",
          //signInFlow: "popup",
          credentialHelper: ACCOUNT_CHOOSER,
          tosUrl: '/tos.html',
          callbacks: callbacks);
    }
    return _uiConfig;
  }

  bool isAuthenticated() => fb.auth().currentUser != null;

  @override
  Future<bool> canActivate(RouterState current, RouterState next) async {
    _location.back();
    return !isAuthenticated();
  }
  // String get userEmail => fb.auth().currentUser?.email;
  // String get displayName => fb.auth().currentUser?.displayName;
  // Map<String, dynamic> get userJson => fb.auth().currentUser?.toJson();
}