import 'package:serene/models/tag.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

enum EditTagsMode { view, editTag, newTag }

class EditTagsViewModel extends BaseViewModel {
  EditTagsMode _mode = EditTagsMode.view;

  EditTagsMode get mode => _mode;

  set mode(EditTagsMode mode) {
    _mode = mode;
    notifyListeners();
  }

  List<TagModel> _tags = [
    TagModel(id: "1", name: "Lernen"),
    TagModel(id: "2", name: "Arbeiten")
  ];
  get tags => _tags;

  DataService _dataService;

  EditTagsViewModel(this._dataService) {}

  saveNewTags() async {
    //Save all the tags that are not in the cache
    for (var tag in _tags) {
      await this._dataService.saveTag(tag);
    }
  }

  deleteTag(TagModel tag) {}
}
