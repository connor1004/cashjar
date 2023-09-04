
import 'package:angular/angular.dart';

@Injectable()
class TitleService {
  String _title = 'Offer';
  bool _showTitle = true;

  get title => _title;
  set title(String val) => _title = val;

  get showTitle => _showTitle;
  set showTitle(bool val) => _showTitle = val;
}