import 'package:application/models/bingocard_model.dart';
import 'package:flutter/material.dart';

class BingoCardController extends ChangeNotifier {
  final List<BingoCardModel> _bingoCards = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BingoCardModel> get bingoCards => _bingoCards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a new BingoCard
  void addBingoCard(BingoCardModel bingoCard) {
    _bingoCards.add(bingoCard);
    notifyListeners();
  }

  // Update an existing BingoCard
  void updateBingoCard(String id, BingoCardModel updatedBingoCard) {
    final index = _bingoCards.indexWhere((card) => card.id == id);
    if (index != -1) {
      _bingoCards[index] = updatedBingoCard;
      notifyListeners();
    } else {
      _errorMessage = 'Bingo card not found';
    }
  }

  // Delete a BingoCard by ID
  void deleteBingoCard(String id) {
    _bingoCards.removeWhere((card) => card.id == id);
    notifyListeners();
  }

  // Get a BingoCard by ID
  BingoCardModel? getBingoCardById(String id) {
    try {
      return _bingoCards.firstWhere((card) => card.id == id);
    } catch (e) {
      _errorMessage = 'Bingo card not found';
      return null;
    }
  }

  // Get all BingoCards
  List<BingoCardModel> getAllBingoCards() {
    return _bingoCards;
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
