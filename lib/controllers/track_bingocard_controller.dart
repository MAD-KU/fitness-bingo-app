import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/track_bingocard_model.dart';

class TrackBingoCardController extends ChangeNotifier {
  List<String> _todayMarkedBingoCards = [];
  List<TrackBingoCardModel> _allBingoCards = [];
  TrackBingoCardModel? _trackBingoCard;
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get todayMarkedBingoCards => _todayMarkedBingoCards;

  List<TrackBingoCardModel> get allBingoCards => _allBingoCards;

  TrackBingoCardModel? get trackBingoCard => _trackBingoCard;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> updateBingoCardStatus(String bingoCardId, String userId) async {
  _setLoading(true);
  try {
  
    QuerySnapshot<Map<String, dynamic>> activitiesSnapshot = await FirebaseFirestore
        .instance
        .collection('activities')
        .where('bingoCardId', isEqualTo: bingoCardId)
        .get();

    bool allCompleted = true;

    for (var activityDoc in activitiesSnapshot.docs) {
      String activityId = activityDoc.id;

    
      QuerySnapshot<Map<String, dynamic>> trackActivitiesSnapshot =
          await FirebaseFirestore.instance
              .collection('trackActivities')
              .where('bingoCardId', isEqualTo: bingoCardId)
              .where('userId', isEqualTo: userId)
              .where('activityId', isEqualTo: activityId)
              .get();

    
      if (trackActivitiesSnapshot.docs.isEmpty) {
        allCompleted = false;
        break;
      }

    
      for (var trackDoc in trackActivitiesSnapshot.docs) {
        if (trackDoc['isTodayCompleted'] != true) {
          allCompleted = false;
          break;
        }
      }

    
      if (!allCompleted) break;
    }

  
    QuerySnapshot<Map<String, dynamic>> trackBingoSnapshot = await FirebaseFirestore
        .instance
        .collection('trackBingoCards')
        .where('bingoCardId', isEqualTo: bingoCardId)
        .where('userId', isEqualTo: userId)
        .get();

    if (trackBingoSnapshot.docs.isNotEmpty) {
    
      await FirebaseFirestore.instance
          .collection('trackBingoCards')
          .doc(trackBingoSnapshot.docs.first.id)
          .update({
        'isTodayCompleted': allCompleted,
        'totalCompletes': allCompleted
            ? (trackBingoSnapshot.docs.first['totalCompletes'] ?? 0) + 1
            : (trackBingoSnapshot.docs.first['totalCompletes'] ?? 0) > 0
                ? (trackBingoSnapshot.docs.first['totalCompletes'] ?? 0) - 1
                : 0,
        'updatedAt': DateTime.now(),
      });

      if (allCompleted) {
        _todayMarkedBingoCards.add(bingoCardId);
        await _updateUserPoints(userId, 50);
      } else {
        _todayMarkedBingoCards.remove(bingoCardId);
        await _updateUserPoints(userId, -50);
      }
    } else {
    
      await FirebaseFirestore.instance.collection('trackBingoCards').add({
        'bingoCardId': bingoCardId,
        'userId': userId,
        'isTodayCompleted': allCompleted,
        'totalCompletes': allCompleted ? 1 : 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      if (allCompleted) {
        _todayMarkedBingoCards.add(bingoCardId);
        await _updateUserPoints(userId, 50);
      }
    }

    _errorMessage = null;
  } catch (e) {
    _errorMessage = e.toString();
  } finally {
    _setLoading(false);
  }
  notifyListeners();
}


  Future<void> _updateUserPoints(String userId, int points) async {
    DocumentReference pointsRef =
        FirebaseFirestore.instance.collection('points').doc(userId);
    DocumentSnapshot pointsSnapshot = await pointsRef.get();

    if (pointsSnapshot.exists) {
      int currentPoints = pointsSnapshot['points'] ?? 0;
      await pointsRef.update({'points': currentPoints + points});
      _updateAchievement(currentPoints + points, userId);
    } else {
      await pointsRef.set({'points': points, 'userId': userId});
      _updateAchievement(points, userId);
    }
  }

  void _updateAchievement(int points, String userId) async {
    final List<Map<String, dynamic>> achievementLevels = [
      {"title": "Bronze Medal", "pointsRequired": 1000},
      {"title": "Silver Medal", "pointsRequired": 3000},
      {"title": "Gold Medal", "pointsRequired": 5000},
      {"title": "Platinum Medal", "pointsRequired": 8000},
      {"title": "Diamond Medal", "pointsRequired": 10000},
    ];

    String? achievement;
    for (var level in achievementLevels) {
      if (points >= level['pointsRequired']) {
        achievement = level['title'];
      }
    }

    if (achievement != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('achievements')
            .where('userId', isEqualTo: userId)
            .where('achievement', isEqualTo: achievement)
            .get();

        if (querySnapshot.docs.isEmpty) {
          await FirebaseFirestore.instance.collection('achievements').add({
            'userId': userId,
            'achievement': achievement,
            'achievedAt': DateTime.now(),
          });
        }
      } catch (e) {
        print('Error updating achievement: $e');
      }
    }
  }

  Future<void> getMarkedBingoCards(String userId) async {
    try {
      _setLoading(true);

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('trackBingoCards')
          .where('userId', isEqualTo: userId)
          .where('isTodayCompleted', isEqualTo: true)
          .get();

      _todayMarkedBingoCards = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data['bingoCardId'] as String;
      }).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> updateBingoCardIsTodayCompleted() async {
    try {
      _setLoading(true);

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('trackBingoCards').get();

      DateTime today = DateTime.now();

      for (var doc in snapshot.docs) {
        var data = doc.data();

        DateTime updatedAt = (data['updatedAt'] as Timestamp).toDate();

        if (DateTime(updatedAt.year, updatedAt.month, updatedAt.day)
            .isBefore(DateTime(today.year, today.month, today.day))) {
          await FirebaseFirestore.instance
              .collection('trackBingoCards')
              .doc(doc.id)
              .update({'isTodayCompleted': false});
        }
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
