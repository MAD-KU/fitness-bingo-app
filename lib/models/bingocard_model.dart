class BingoCardModel {
  String? id;
  String? name;
  String? description;
  String? userId;

  BingoCardModel({this.id, this.name, this.description, this.userId});

  BingoCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['userId'] = this.userId;
    return data;
  }
}