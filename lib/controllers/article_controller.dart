import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/article_model.dart';

class ArticleController extends ChangeNotifier {
  List<ArticleModel> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ArticleModel> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Article
  void addArticle(ArticleModel article) async {
    try {
      // Add to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('articles')
          .add(article.toJson());

      // Update the article with the generated ID
      article.id = docRef.id;

      // Add to local list
      _articles.add(article);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Update an existing Article
  void updateArticle(String id, ArticleModel updatedArticle) async {
    try {
      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(id)
          .update(updatedArticle.toJson());

      // Update in local list
      final index = _articles.indexWhere((article) => article.id == id);
      if (index != -1) {
        _articles[index] = updatedArticle;
        notifyListeners();
      } else {
        _setError('Article not found');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Delete an Article by ID
  void deleteArticle(String id) async {
    try {
      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(id)
          .delete();

      // Delete from local list
      _articles.removeWhere((article) => article.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Get an Article by ID
  Future<ArticleModel?> getArticleById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('articles')
          .doc(id)
          .get();

      if (doc.exists) {
        return ArticleModel.fromJson(doc.data()!);
      } else {
        _setError('Article not found');
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Get all Articles
  Future<void> getAllArticles() async {
    try {
      _setLoading(true);

      // Get articles from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('articles').get();

      // Map documents to ArticleModel
      _articles = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Add the document ID to the data
        return ArticleModel.fromJson(data);
      }).toList();

      _setError(null); // Clear any existing errors
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    notifyListeners();
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