import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/track_bingocard_model.dart';

class TrackBingoCardController extends ChangeNotifier {
  // State variables
  List<String> _todayMarkedBingoCards = [];
  List<TrackBingoCardModel> _allBingoCards = [];
  TrackBingoCardModel? _trackBingoCard;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<String> get todayMarkedBingoCards => _todayMarkedBingoCards;

  List<TrackBingoCardModel> get allBingoCards => _allBingoCards;

  TrackBingoCardModel? get trackBingoCard => _trackBingoCard;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Update Bingo Card Status
  Future<void> updateBingoCardStatus(String bingoCardId, String userId) async {
    _setLoading(true);
    try {
      // Check if all activities are completed
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('trackActivities')
          .where('bingoCardId', isEqualTo: bingoCardId)
          .where('userId', isEqualTo: userId)
          .get();

      bool allCompleted =
          snapshot.docs.every((doc) => doc['isTodayCompleted'] == true);

      // Fetch trackBingoCard for the given bingoCardId and userId
      QuerySnapshot<Map<String, dynamic>> trackBingoSnapshot =
          await FirebaseFirestore.instance
              .collection('trackBingoCards')
              .where('bingoCardId', isEqualTo: bingoCardId)
              .where('userId', isEqualTo: userId)
              .get();

      if (trackBingoSnapshot.docs.isNotEmpty) {
        // Update existing record
        await FirebaseFirestore.instance
            .collection('trackBingoCards')
            .doc(trackBingoSnapshot.docs.first.id)
            .update({
          'isTodayCompleted': allCompleted,
          'totalCompletes': allCompleted
              ? (trackBingoSnapshot.docs.first['totalCompletes'] ?? 0) + 1
              : trackBingoSnapshot.docs.first['totalCompletes'] - 1,
          'updatedAt': DateTime.now(),
        });

        if (allCompleted) {
          _todayMarkedBingoCards.add(bingoCardId);
          await _updateUserPoints(userId, 50); // Add 50 points
        } else {
          _todayMarkedBingoCards.remove(bingoCardId);
          await _updateUserPoints(userId, -50);
        }
      } else {
        // Create new record if it doesn't exist
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
          await _updateUserPoints(userId, 50); // Add 50 points
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

  // Update User Points
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
    // Define achievement levels
    final List<Map<String, dynamic>> achievementLevels = [
      {"title": "Bronze Medal", "pointsRequired": 1000},
      {"title": "Silver Medal", "pointsRequired": 3000},
      {"title": "Gold Medal", "pointsRequired": 5000},
      {"title": "Platinum Medal", "pointsRequired": 8000},
      {"title": "Diamond Medal", "pointsRequired": 10000},
    ];

    // Find the highest achievement for the given points
    String? achievement;
    for (var level in achievementLevels) {
      if (points >= level['pointsRequired']) {
        achievement =
            level['title']; // Assign achievement if points meet the requirement
      }
    }

    if (achievement != null) {
      try {
        // Save the achievement in 'achievements' collection
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('achievements')
            .where('userId', isEqualTo: userId)
            .where('achievement',
                isEqualTo: achievement) // Check if already saved
            .get();

        if (querySnapshot.docs.isEmpty) {
          // Save only if the achievement is not already saved
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

  // Fetch Marked Bingo Cards
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

  // Helper Method - Set Loading State
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
