class TagModel {
  String name;
  String id;

  TagModel({this.name, this.id});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "name": this.name,
    };
  }

  TagModel.fromMap(dynamic map) {
    id = map["id"];
    name = map["name"];
  }
}
