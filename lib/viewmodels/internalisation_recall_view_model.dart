import 'package:serene/models/internalisation.dart';
import 'package:serene/models/recall_task.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationRecallViewModel extends BaseViewModel {
  DataService _dataService;
  RecallTask _recallTask = RecallTask();
  InternalisationRecallViewModel(this._dataService) {
    _recallTask.startDate = DateTime.now();
  }

  submit(String text) {
    _recallTask.completionDate = DateTime.now();
    _recallTask.recalledSentence = text;
    _dataService.saveRecallTask(_recallTask);
  }
}
