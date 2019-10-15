class AssessmentModel {
  String userId;
  Map<String, String> results;
  String assessmentType;
  DateTime submissionDate;

  AssessmentModel(
      this.userId, this.results, this.assessmentType, this.submissionDate);

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "results": this.results,
      "assessmentType": this.assessmentType,
      "submissionDate": this.submissionDate.toIso8601String()
    };
  }
}
