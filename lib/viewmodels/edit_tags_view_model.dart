import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

enum EditTagsMode { view, edit }

class EditTagsViewModel extends BaseViewModel {
  EditTagsMode _mode = EditTagsMode.view;

  EditTagsMode get mode => _mode;

  set mode(EditTagsMode mode) {
    _mode = mode;
    notifyListeners();
  }

  List<String> _tags = ["Lernen", "Arbeit"];

  get tags => _tags;

  DataService _dataService;
  EditTagsViewModel(this._dataService) {}

  submit() {}
}
