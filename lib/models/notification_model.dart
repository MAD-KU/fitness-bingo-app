class NotificationModel {
  String? id;
  String? message;
  String? createdAt;
  String? userId;
  bool? isRead;

  NotificationModel({this.id, this.message, this.createdAt, this.userId,this.isRead});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['createdAt'];
    userId = json['userId'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['userId'] = this.userId;
    data['isRead'] = this.isRead;
    return data;
  }
}