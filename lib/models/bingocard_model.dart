class BingoCardModel {
  String? id;
  String? title;
  String? description;
  String? userId;
  String? category; //default or custom
  String? imageUrl;

  BingoCardModel(
      {this.id,
      this.title,
      this.description,
      this.userId,
      this.category,
      this.imageUrl});

  BingoCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['userId'];
    category = json['category'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['userId'] = this.userId;
    data['category'] = this.category;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
