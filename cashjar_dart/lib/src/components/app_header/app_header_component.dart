import 'package:angular/angular.dart';
import 'package:cashjar_dart/src/services/title_service.dart';

@Component(
  selector: 'app-header',
  templateUrl: 'app_header_component.html',
  styleUrls: ['app_header_component.css'],
  directives: [coreDirectives],
)
class AppHeaderComponent {
  TitleService titleService;

  AppHeaderComponent(this.titleService);
}