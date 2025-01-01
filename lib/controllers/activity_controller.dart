import 'package:flutter/material.dart';
import 'package:application/models/activity_model.dart';

class ActivityController extends ChangeNotifier {
  final List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Activity
  void addActivity(ActivityModel activity) {
    _activities.add(activity);
    notifyListeners();
  }

  // Update an existing Activity
  void updateActivity(String id, ActivityModel updatedActivity) {
    final index = _activities.indexWhere((activity) => activity.id == id);
    if (index != -1) {
      _activities[index] = updatedActivity;
      notifyListeners();
    } else {
      _errorMessage = 'Activity not found';
    }
  }

  // Delete an Activity by ID
  void deleteActivity(String id) {
    _activities.removeWhere((activity) => activity.id == id);
    notifyListeners();
  }

  // Get an Activity by ID
  ActivityModel? getActivityById(String id) {
    try {
      return _activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      _errorMessage = 'Activity not found';
      return null;
    }
  }

  // Get all Activities
  List<ActivityModel> getAllActivities() {
    return _activities;
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
