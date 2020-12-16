class LdtData {
  String blockname;
  String word;
  String condition;
  int responseTime;
  int touchTime;
  int status;

  LdtData(
      {this.blockname,
      this.word,
      this.condition,
      this.responseTime = -1,
      this.touchTime = -1,
      this.status = -1});
}
