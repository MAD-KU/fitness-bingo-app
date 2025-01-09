// store_controller.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/store_model.dart';

class StoreController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<StoreModel> storeItems = [];
  bool isLoading = false;
  String? errorMessage;
  String selectedCategory = 'All';

  // Predefined gym equipment categories
  final List<String> categories = [
    'All',
    'Cardio Equipment',
    'Strength Training',
    'Weights',
    'Yoga & Pilates',
    'Accessories',
    'Recovery & Wellness'
  ];

  Future<void> getAllStoreItems({String? category}) async {
    try {
      isLoading = true;
      notifyListeners();

      Query<Map<String, dynamic>> query = _firestore.collection('store');
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      storeItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return StoreModel.fromJson(data)..id = doc.id;
      }).toList();

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load store items: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStoreItem(StoreModel item) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestore.collection('store').add(item.toJson());
      await getAllStoreItems(category: selectedCategory != 'All' ? selectedCategory : null);
    } catch (e) {
      errorMessage = 'Failed to add store item: $e';
      notifyListeners();
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStoreItem(StoreModel item) async {
    try {
      if (item.id == null) throw 'Item ID is required for update';

      isLoading = true;
      notifyListeners();

      await _firestore.collection('store').doc(item.id).update(item.toJson());
      await getAllStoreItems(category: selectedCategory != 'All' ? selectedCategory : null);
    } catch (e) {
      errorMessage = 'Failed to update store item: $e';
      notifyListeners();
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStoreItem(String itemId) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestore.collection('store').doc(itemId).delete();
      await getAllStoreItems(category: selectedCategory != 'All' ? selectedCategory : null);
    } catch (e) {
      errorMessage = 'Failed to delete store item: $e';
      notifyListeners();
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> launchAmazonUrl(String? url) async {
    if (url == null || url.isEmpty) {
      errorMessage = 'Invalid Amazon URL';
      notifyListeners();
      return;
    }

    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      errorMessage = 'Failed to launch Amazon URL: $e';
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory = category;
    getAllStoreItems(category: category == 'All' ? null : category);
  }
}