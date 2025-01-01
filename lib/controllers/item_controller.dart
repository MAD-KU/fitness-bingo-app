import 'package:flutter/material.dart';
import 'package:application/models/item_model.dart';

class ItemController extends ChangeNotifier {
  final List<ItemModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Item
  void addItem(ItemModel item) {
    _items.add(item);
    notifyListeners();
  }

  // Update an existing Item
  void updateItem(String id, ItemModel updatedItem) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    } else {
      _errorMessage = 'Item not found';
      notifyListeners();
    }
  }

  // Delete an Item by ID
  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Get an Item by ID
  ItemModel? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      _errorMessage = 'Item not found';
      notifyListeners();
      return null;
    }
  }

  // Get all Items
  List<ItemModel> getAllItems() {
    return _items;
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
