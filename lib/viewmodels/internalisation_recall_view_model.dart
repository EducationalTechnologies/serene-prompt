import 'package:serene/models/recall_task.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationRecallViewModel extends BaseViewModel {
  final ExperimentService _experimentService;
  RecallTask _recallTask = RecallTask();
  InternalisationRecallViewModel(this._experimentService) {
    _recallTask.startDate = DateTime.now();
  }

  submit(String text) {
    if (state == ViewState.busy) return false;
    setState(ViewState.busy);
    _recallTask.completionDate = DateTime.now();
    _recallTask.recalledSentence = text;
    _experimentService.submitRecallTask(_recallTask);
  }
}
