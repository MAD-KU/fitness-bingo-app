import 'package:flutter/material.dart';
import 'package:application/models/article_model.dart';

class ArticleController extends ChangeNotifier {
  final List<ArticleModel> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ArticleModel> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Article
  void addArticle(ArticleModel article) {
    _articles.add(article);
    notifyListeners();
  }

  // Update an existing Article
  void updateArticle(String id, ArticleModel updatedArticle) {
    final index = _articles.indexWhere((article) => article.id == id);
    if (index != -1) {
      _articles[index] = updatedArticle;
      notifyListeners();
    } else {
      _errorMessage = 'Article not found';
    }
  }

  // Delete an Article by ID
  void deleteArticle(String id) {
    _articles.removeWhere((article) => article.id == id);
    notifyListeners();
  }

  // Get an Article by ID
  ArticleModel? getArticleById(String id) {
    try {
      return _articles.firstWhere((article) => article.id == id);
    } catch (e) {
      _errorMessage = 'Article not found';
      return null;
    }
  }

  // Get all Articles
  List<ArticleModel> getAllArticles() {
    return _articles;
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
