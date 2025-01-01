import 'package:flutter/material.dart';
import 'package:application/models/chathistory_model.dart';

class ChatHistoryController extends ChangeNotifier {
  final List<ChatHistoryModel> _chatHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ChatHistoryModel> get chatHistory => _chatHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new Chat History entry
  void addChatHistory(ChatHistoryModel chatHistoryEntry) {
    _chatHistory.add(chatHistoryEntry);
    notifyListeners();
  }

  // Update an existing Chat History entry
  void updateChatHistory(String id, ChatHistoryModel updatedChatHistory) {
    final index = _chatHistory.indexWhere((chat) => chat.id == id);
    if (index != -1) {
      _chatHistory[index] = updatedChatHistory;
      notifyListeners();
    } else {
      _errorMessage = 'Chat history entry not found';
    }
  }

  // Delete a Chat History entry by ID
  void deleteChatHistory(String id) {
    _chatHistory.removeWhere((chat) => chat.id == id);
    notifyListeners();
  }

  // Get a Chat History entry by ID
  ChatHistoryModel? getChatHistoryById(String id) {
    try {
      return _chatHistory.firstWhere((chat) => chat.id == id);
    } catch (e) {
      _errorMessage = 'Chat history entry not found';
      return null;
    }
  }

  // Get all Chat History entries
  List<ChatHistoryModel> getAllChatHistory() {
    return _chatHistory;
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
