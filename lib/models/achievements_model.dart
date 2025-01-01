class AchievementsModel {
  String? id;
  String? title;
  String? description;
  String? userId;

  AchievementsModel({this.id, this.title, this.description, this.userId});

  AchievementsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['userId'] = this.userId;
    return data;
  }
}
