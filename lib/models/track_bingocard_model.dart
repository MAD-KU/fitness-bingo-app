import 'package:cloud_firestore/cloud_firestore.dart';

class TrackBingoCardModel {
  String? id;
  String? userId;
  String? bingoCardId;
  bool? isTodayCompleted;
  int? totalCompletes;
  DateTime? createdAt;
  DateTime? updatedAt;

  TrackBingoCardModel({
    this.id,
    this.userId,
    this.bingoCardId,
    this.isTodayCompleted = false,
    this.totalCompletes = 0,
    this.createdAt,
    this.updatedAt,
  });

  TrackBingoCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    bingoCardId = json['bingoCardId'];
    isTodayCompleted = json['isTodayCompleted'] ?? false;
    totalCompletes = json['totalCompletes'] ?? 0;
    createdAt = (json['createdAt'] as Timestamp).toDate();
    updatedAt = (json['updatedAt'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['bingoCardId'] = bingoCardId;
    data['isTodayCompleted'] = isTodayCompleted;
    data['totalCompletes'] = totalCompletes;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
