import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementsModel {
  String? id;
  String? achievement;
  DateTime? achievedAt;
  String? userId;

  AchievementsModel({this.id, this.achievement, this.achievedAt, this.userId});

  AchievementsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    achievement = json['achievement'];
    achievedAt = (json['achievedAt'] as Timestamp).toDate();
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['achievement'] = this.achievement;
    data['achievedAt'] = this.achievedAt;
    data['userId'] = this.userId;
    return data;
  }
}
