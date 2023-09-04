import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:cashjar_dart/src/routes/routes.dart';
import 'package:cashjar_dart/src/services/auth_service.dart';
import 'package:cashjar_dart/src/services/title_service.dart';

import 'src/components/app_header/app_header_component.dart';
import 'src/screens/message_screen/message_screen_component.dart';
import 'package:cashjar_dart/src/firebase/firebase_service.dart';
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [coreDirectives, AppHeaderComponent, MessageScreenComponent, routerDirectives],
  providers: [FireBaseService, TitleService, AuthService],
  exports: [RoutePaths, Routes],
)
class AppComponent implements OnInit {
  // Nothing here yet. All logic is in TodoListComponent.
  final FireBaseService firebaseService;

  AppComponent(this.firebaseService);

  @override
  void ngOnInit() async {
    await firebaseService.initFirebase();
  }
}
