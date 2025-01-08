import 'package:flutter/material.dart';
import 'package:application/models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void updateNotification(String id, NotificationModel updatedNotification) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = updatedNotification;
      notifyListeners();
    } else {
      _errorMessage = 'Notification not found';
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  NotificationModel? getNotificationById(String id) {
    try {
      return _notifications.firstWhere((notification) => notification.id == id);
    } catch (e) {
      _errorMessage = 'Notification not found';
      return null;
    }
  }

  List<NotificationModel> getAllNotifications() {
    return _notifications;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
