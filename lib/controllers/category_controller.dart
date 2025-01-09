import 'package:flutter/material.dart';
import 'package:application/models/category_model.dart';

class CategoryController extends ChangeNotifier {
  final List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Category
  void addCategory(CategoryModel category) {
    _categories.add(category);
    notifyListeners();
  }

  // Update an existing Category
  void updateCategory(String id, CategoryModel updatedCategory) {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index != -1) {
      _categories[index] = updatedCategory;
      notifyListeners();
    } else {
      _errorMessage = 'Category not found';
      notifyListeners();
    }
  }

  // Delete a Category by ID
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  // Get a Category by ID
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      _errorMessage = 'Category not found';
      notifyListeners();
      return null;
    }
  }

  // Get all Categories
  List<CategoryModel> getAllCategories() {
    return _categories;
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
