class ActivityModel {
  String? id;
  String? name;
  String? status;
  String? userId;

  ActivityModel({this.id, this.name, this.status, this.userId});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['userId'] = this.userId;
    return data;
  }
}