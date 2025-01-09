import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/models/activity_model.dart';

class ActivityController extends ChangeNotifier {
  List<ActivityModel> _activities = [];
  ActivityModel? _activity;
  bool _isLoading = false;
  String? _errorMessage;

  List<ActivityModel> get activities => _activities;

  ActivityModel? get activity => _activity;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> addActivity(ActivityModel activity) async {
    try {
      _setLoading(true);
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('activities')
          .add(activity.toJson());

      activity.id = docRef.id;
      _activities.add(activity);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> updateActivity(String id, ActivityModel updatedActivity) async {
    try {
      _setLoading(true);
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(id)
          .update(updatedActivity.toJson());

      final index = _activities.indexWhere((activity) => activity.id == id);
      if (index != -1) {
        _activities[index] = updatedActivity;
        _errorMessage = null;
      } else {
        _errorMessage = 'Activity not found';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    try {
      _setLoading(true);
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(id)
          .delete();

      _activities.removeWhere((activity) => activity.id == id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> getActivityById(String id) async {
    try {
      _setLoading(true);
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('activities')
          .doc(id)
          .get();

      if (doc.exists) {
        _activity = ActivityModel.fromJson(doc.data()!..['id'] = doc.id);
        _errorMessage = null;
      } else {
        _errorMessage = 'Activity not found';
      }
    } catch (e) {
      _errorMessage = e.toString();
      _activity = null;
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> getAllActivities(String? bingoCardId) async {
    try {
      _setLoading(true);
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('activities')
          .where('bingoCardId', isEqualTo: bingoCardId)
          .get();

      _activities = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return ActivityModel.fromJson(data);
      }).toList();

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
