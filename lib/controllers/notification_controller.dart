import 'package:flutter/material.dart';
import 'package:application/models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Notification
  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  // Update an existing Notification
  void updateNotification(String id, NotificationModel updatedNotification) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = updatedNotification;
      notifyListeners();
    } else {
      _errorMessage = 'Notification not found';
    }
  }

  // Delete a Notification by ID
  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  // Get a Notification by ID
  NotificationModel? getNotificationById(String id) {
    try {
      return _notifications.firstWhere((notification) => notification.id == id);
    } catch (e) {
      _errorMessage = 'Notification not found';
      return null;
    }
  }

  // Get all Notifications
  List<NotificationModel> getAllNotifications() {
    return _notifications;
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
