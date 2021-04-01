import 'package:serene/shared/enums.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/viewmodels/multi_step_assessment_view_model.dart';

class EveningAssessmentViewModel extends MultiStepAssessmentViewModel {
  @override
  bool canMoveBack(int currentStep) {
    // TODO: implement canMoveBack
    throw UnimplementedError();
  }

  @override
  bool canMoveNext(int currentStep) {
    // TODO: implement canMoveNext
    throw UnimplementedError();
  }

  @override
  Future<Assessment> getAssessment(AssessmentTypes assessmentType) {
    // TODO: implement getAssessment
    throw UnimplementedError();
  }

  @override
  int getNextPage(int currentPage) {
    var next = step + 1;
    return next;
  }
}
