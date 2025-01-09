import 'package:cloud_firestore/cloud_firestore.dart';

class TrackActivityModel {
  String? id;
  String? userId;
  String? activityId;
  String? bingoCardId;
  bool? isTodayCompleted;
  int? totalCompletes;
  DateTime? createdAt;
  DateTime? updatedAt;

  TrackActivityModel({
    this.id,
    this.activityId,
    this.userId,
    this.bingoCardId,
    this.isTodayCompleted,
    this.totalCompletes,
    this.createdAt,
    this.updatedAt,
  });

  TrackActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    activityId = json['activityId'];
    bingoCardId = json['bingoCardId'];
    isTodayCompleted = json['isTodayCompleted'];
    totalCompletes = json['totalCompletes'];
    createdAt = (json['createdAt'] as Timestamp).toDate();
    updatedAt = (json['updatedAt'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['activityId'] = activityId;
    data['bingoCardId'] = bingoCardId;
    data['isTodayCompleted'] = isTodayCompleted;
    data['totalCompletes'] = totalCompletes;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}