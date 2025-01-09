class ChatHistoryModel {
  String? id;
  String? message;
  String? response;
  String? userId;

  ChatHistoryModel({this.id, this.message, this.response, this.userId});

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    response = json['response'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['response'] = this.response;
    data['userId'] = this.userId;
    return data;
  }
}