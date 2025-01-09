class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? role = 'user';
  String? imageUrl = "assets/images/profile.png";

  UserModel({this.id, this.name, this.email, this.role, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}
