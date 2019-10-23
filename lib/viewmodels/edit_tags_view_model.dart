import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class EditTagsViewModel extends BaseViewModel {
  List<String> _tags = ["Lernen", "Arbeit"];

  get tags => _tags;

  DataService _dataService;
  EditTagsViewModel(this._dataService) {}
}
