import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'package:cashjar_dart/src/screens/message_screen/message_screen_component.template.dart' as messaging_template;
import 'package:cashjar_dart/src/screens/create_offer/create_offer_component.template.dart' as create_offer_template;
import 'package:cashjar_dart/src/screens/login/login_component.template.dart' as login_template;
import 'package:cashjar_dart/src/screens/qrcode_scan/qrcode_scan_component.template.dart' as qrcode_scan_template;

export 'route_paths.dart';

class Routes {
  static final messaging = RouteDefinition(
    routePath: RoutePaths.messaging,
    component: messaging_template.MessageScreenComponentNgFactory,
  );

  static final create_offer = RouteDefinition(
    routePath: RoutePaths.createOffer,
    component: create_offer_template.CreateOfferComponentNgFactory,
  );

  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginComponentNgFactory,
  );

  static final qrcode_scan = RouteDefinition(
    routePath: RoutePaths.qrcodeScan,
    component: qrcode_scan_template.QrcodeScanComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    create_offer,
    messaging,
    login,
    qrcode_scan,
  ];
}