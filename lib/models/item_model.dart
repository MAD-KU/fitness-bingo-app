class ItemModel {
  String? id;
  String? name;
  String? imageUrl;
  String? categoryId;

  ItemModel({this.id, this.name, this.imageUrl, this.categoryId});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
