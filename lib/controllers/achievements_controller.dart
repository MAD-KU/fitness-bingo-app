import 'package:application/models/achievements_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AchievementController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AchievementsModel> _achievements = [];
  List<AchievementsModel> get achievements => _achievements;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  // Add a new list for leaderboard entries
  List<LeaderboardEntry> _leaderboardEntries = [];
  List<LeaderboardEntry> get leaderboardEntries => _leaderboardEntries;

  Future<void> fetchAchievementsForUser(String userId) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('achievements')
          .where(
          'userId', isEqualTo: userId) // Fetch achievements for the specified user
          .get();

      _achievements = querySnapshot.docs
          .map((doc) => AchievementsModel.fromJson(
          {'id': doc.id, ...doc.data() as Map<String, dynamic>}))
          .toList();
    } catch (e) {
      _errorMessage = "Error fetching achievements: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLeaderboardData() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .get();

      List<LeaderboardEntry> entries = [];

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        QuerySnapshot pointsSnapshot = await _firestore
            .collection('points')
            .where('userId', isEqualTo: userId)
            .get();

        int totalPoints = pointsSnapshot.docs.isNotEmpty
            ? pointsSnapshot.docs.first.get('points') ?? 0
            : 0;

        if (totalPoints > 0) {
          entries.add(LeaderboardEntry(
            userId: userId,
            userName: userDoc.get('name') ?? 'Unknown',
            score: totalPoints,
          ));
        }
      }

      entries.sort((a, b) => b.score.compareTo(a.score));

      _leaderboardEntries = entries;
    } catch (e) {
      _errorMessage = "Error fetching leaderboard data: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final int score;

  LeaderboardEntry(
      {required this.userId, required this.userName, required this.score});
}