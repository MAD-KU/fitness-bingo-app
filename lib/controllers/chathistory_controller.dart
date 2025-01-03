import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/chathistory_model.dart';

class ChatHistoryController extends ChangeNotifier {
  List<ChatHistoryModel> _chatHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ChatHistoryModel> get chatHistory => _chatHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Chat History entry
  Future<void> addChatHistory(ChatHistoryModel chatHistoryEntry) async {
    try {
      // Add to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('chatHistory')
          .add(chatHistoryEntry.toJson());

      // Update the entry with the generated ID
      chatHistoryEntry.id = docRef.id;

      // Add to local list
      _chatHistory.add(chatHistoryEntry);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Update an existing Chat History entry
  Future<void> updateChatHistory(String id, ChatHistoryModel updatedChatHistory) async {
    try {
      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('chatHistory')
          .doc(id)
          .update(updatedChatHistory.toJson());

      // Update in local list
      final index = _chatHistory.indexWhere((chat) => chat.id == id);
      if (index != -1) {
        _chatHistory[index] = updatedChatHistory;
        notifyListeners();
      } else {
        _setError('Chat history entry not found');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Delete a Chat History entry by ID
  Future<void> deleteChatHistory(String id) async {
    try {
      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('chatHistory')
          .doc(id)
          .delete();

      // Delete from local list
      _chatHistory.removeWhere((chat) => chat.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Get a Chat History entry by ID
  Future<ChatHistoryModel?> getChatHistoryById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('chatHistory')
          .doc(id)
          .get();

      if (doc.exists) {
        return ChatHistoryModel.fromJson(doc.data()!);
      } else {
        _setError('Chat history entry not found');
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Get all Chat History entries
  Future<void> getAllChatHistory() async {
    try {
      _setLoading(true);

      // Get chat history from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('chatHistory').get();

      // Map documents to ChatHistoryModel
      _chatHistory = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Add the document ID to the data
        return ChatHistoryModel.fromJson(data);
      }).toList();

      _setError(null); // Clear any existing errors
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> getUserChatHistory(String userId) async {
    try {
      _setLoading(true);

      // Get chat history for the specific user from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('chatHistory')
          .where('userId', isEqualTo: userId)
          .get();

      _chatHistory = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Add the document ID to the data
        return ChatHistoryModel.fromJson(data);
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
