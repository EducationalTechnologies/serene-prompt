class AssessmentResult {
  String userId;
  Map<String, String> results;
  String assessmentType;
  DateTime submissionDate;

  AssessmentResult(
      this.userId, this.results, this.assessmentType, this.submissionDate);

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "results": this.results,
      "assessmentType": this.assessmentType,
      "submissionDate": this.submissionDate.toIso8601String()
    };
  }

  AssessmentResult.fromDocument(dynamic document) {
    this.submissionDate = DateTime.parse(document["submissionDate"]);
    this.assessmentType = document["assessmentType"];
  }
}
