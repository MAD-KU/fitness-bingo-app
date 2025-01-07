import 'package:application/controllers/track_bingocard_controller.dart';
import 'package:application/models/track_activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TrackActivityController extends ChangeNotifier {
  final TrackBingoCardController trackBingoCardController =
  TrackBingoCardController();

  // State variables
  List<String> _todayMarkedActivities = [];
  List<TrackActivityModel> _allActivities = [];
  TrackActivityModel? _trackActivity;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<String> get todayMarkedActivities => _todayMarkedActivities;

  List<TrackActivityModel> get allActivities => _allActivities;

  TrackActivityModel? get trackActivity => _trackActivity;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Toggle Activity Mark with Points System
  Future<void> toggleActivityMark(TrackActivityModel trackActivity) async {
    try {
      _setLoading(true);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('trackActivities')
          .where('activityId', isEqualTo: trackActivity.activityId)
          .where('userId', isEqualTo: trackActivity.userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var existingData = snapshot.docs.first.data() as Map<String, dynamic>;
        bool isCompleted = existingData['isTodayCompleted'] ?? false;

        if (isCompleted) {
          await FirebaseFirestore.instance
              .collection('trackActivities')
              .doc(snapshot.docs.first.id)
              .update({
            'isTodayCompleted': false,
            'totalCompletes': (existingData['totalCompletes'] ?? 0) - 1
          });

          _todayMarkedActivities.remove(trackActivity.activityId);
          await _updatePoints(trackActivity.userId!, -10);
        } else {
          await FirebaseFirestore.instance
              .collection('trackActivities')
              .doc(snapshot.docs.first.id)
              .update({
            'isTodayCompleted': true,
            'updatedAt': DateTime.now(),
            'totalCompletes': (existingData['totalCompletes'] ?? 0) + 1,
          });

          _todayMarkedActivities.add(trackActivity.activityId!);
          await _updatePoints(trackActivity.userId!, 10);
        }
      } else {
        // Create a new entry
        trackActivity.createdAt = DateTime.now();
        trackActivity.updatedAt = DateTime.now();
        trackActivity.totalCompletes = 1;
        trackActivity.isTodayCompleted = true;

        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('trackActivities')
            .add(trackActivity.toJson());

        trackActivity.id = docRef.id;
        _todayMarkedActivities.add(trackActivity.activityId!);

        await _updatePoints(trackActivity.userId!, 10);
      }

      await trackBingoCardController.updateBingoCardStatus(
          trackActivity.bingoCardId!, trackActivity.userId!);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      getMarkedActivities(trackActivity.userId!, trackActivity.bingoCardId!);
    }
    notifyListeners();
  }

  // Fetch Marked Activities
  Future<void> getMarkedActivities(String userId, String bingoCardId) async {
    try {
      _setLoading(true);

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('trackActivities')
          .where('userId', isEqualTo: userId)
          .where('bingoCardId', isEqualTo: bingoCardId)
          .where('isTodayCompleted', isEqualTo: true)
          .get();

      _todayMarkedActivities = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data['activityId'] as String;
      }).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Update isTodayCompleted based on updatedAt (Date Check Only)
  Future<void> updateIsTodayCompleted() async {
    try {
      _setLoading(true);

      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('trackActivities').get();

      DateTime today = DateTime.now();

      for (var doc in snapshot.docs) {
        var data = doc.data();
        DateTime updatedAt = (data['updatedAt'] as Timestamp).toDate();

        if (DateTime(updatedAt.year, updatedAt.month, updatedAt.day)
            .isBefore(DateTime(today.year, today.month, today.day))) {
          await FirebaseFirestore.instance
              .collection('trackActivities')
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

  // Update Points System
  Future<void> _updatePoints(String userId, int points) async {
    try {
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('points')
          .doc(userId);

      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        int currentPoints = (docSnapshot['points'] ?? 0) + points;
        await userDoc.update({'points': currentPoints});
      } else {
        await userDoc.set({'userId': userId, 'points': points});
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  // Helper Method - Set Loading State
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
