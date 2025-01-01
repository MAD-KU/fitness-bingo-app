class NotificationModel {
  String? id;
  String? message;
  String? createdAt;
  String? userId;

  NotificationModel({this.id, this.message, this.createdAt, this.userId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['createdAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['userId'] = this.userId;
    return data;
  }
}