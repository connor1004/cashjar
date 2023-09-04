import 'package:angular_router/angular_router.dart';

class RoutePaths {
  static final createOffer = RoutePath(path: 'create-offer');
  static final messaging = RoutePath(path: '', useAsDefault: true);
  static final login = RoutePath(path: 'login');
  static final qrcodeScan = RoutePath(path: 'qrcode-scan');
}