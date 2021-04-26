import 'package:prompt/models/recall_task.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/base_view_model.dart';

class InternalisationRecallViewModel extends BaseViewModel {
  final ExperimentService _experimentService;
  RecallTask _recallTask = RecallTask();
  InternalisationRecallViewModel(this._experimentService) {
    _recallTask.startDate = DateTime.now();
  }

  submit(String text) async {
    if (state == ViewState.busy) return false;
    setState(ViewState.busy);
    _recallTask.completionDate = DateTime.now();
    _recallTask.recall = text;
    await _experimentService.submitRecallTask(_recallTask);
    _experimentService.nextScreen(RouteNames.RECALL_TASK);
  }
}
