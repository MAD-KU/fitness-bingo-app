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
      // Fetch users, excluding admins
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where('role', isNotEqualTo: 'admin').get();

      // Create a list to hold the leaderboard entries
      List<LeaderboardEntry> entries = [];

      // Iterate through each user and calculate their score
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        // Fetch achievements for the current user
        QuerySnapshot achievementsSnapshot = await _firestore
            .collection('achievements')
            .where('userId', isEqualTo: userId)
            .get();

        // Calculate the total score for the user (e.g., number of achievements)
        int totalScore = achievementsSnapshot.docs.length;

        // Add the user and their score to the list
        entries.add(LeaderboardEntry(
          userId: userId,
          userName: userDoc.get('name') ?? 'Unknown',
          score: totalScore,
        ));
      }

      // Sort the entries by score in descending order
      entries.sort((a, b) => b.score.compareTo(a.score));

      // Update the leaderboard entries
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