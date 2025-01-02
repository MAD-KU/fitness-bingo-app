class ActivityModel {
  String? id;
  String? name;
  String? imageUrl;
  String? status = "active";
  String? category; //default or custom
  String? userId;
  String? bingoCardId;

  ActivityModel(
      {this.id,
      this.name,
      this.imageUrl,
      this.status,
      this.category,
      this.userId,
      this.bingoCardId});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    category = json['category'];
    userId = json['userId'];
    bingoCardId = json['bingoCardId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['status'] = this.status;
    data['category'] = this.category;
    data['userId'] = this.userId;
    data['bingoCardId'] = this.bingoCardId;
    return data;
  }
}
