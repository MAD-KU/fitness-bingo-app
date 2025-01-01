import 'package:flutter/material.dart';
import 'package:application/models/achievements_model.dart';

class AchievementsController extends ChangeNotifier {
  final List<AchievementsModel> _achievements = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AchievementsModel> get achievements => _achievements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Achievement
  void addAchievement(AchievementsModel achievement) {
    _achievements.add(achievement);
    notifyListeners();
  }

  // Update an existing Achievement
  void updateAchievement(String id, AchievementsModel updatedAchievement) {
    final index = _achievements.indexWhere((achievement) => achievement.id == id);
    if (index != -1) {
      _achievements[index] = updatedAchievement;
      notifyListeners();
    } else {
      _errorMessage = 'Achievement not found';
      notifyListeners();
    }
  }

  // Delete an Achievement by ID
  void deleteAchievement(String id) {
    _achievements.removeWhere((achievement) => achievement.id == id);
    notifyListeners();
  }

  // Get an Achievement by ID
  AchievementsModel? getAchievementById(String id) {
    try {
      return _achievements.firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      _errorMessage = 'Achievement not found';
      notifyListeners();
      return null;
    }
  }

  // Get all Achievements
  List<AchievementsModel> getAllAchievements() {
    return _achievements;
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Helper method to handle errors
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}
