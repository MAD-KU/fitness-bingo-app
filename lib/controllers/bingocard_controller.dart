import 'package:application/models/bingocard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BingoCardController extends ChangeNotifier {
  List<BingoCardModel> _bingoCards = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BingoCardModel> get bingoCards => _bingoCards;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Add a new BingoCard
  void addBingoCard(BingoCardModel bingoCard) async {
    await FirebaseFirestore.instance
        .collection('bingoCards')
        .add(bingoCard.toJson());

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
  Future<void> getAllBingoCards() async {
    try {
      _setLoading(true); // Set loading state
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('bingoCards').get();

      // Map documents to BingoCardModel
      _bingoCards = snapshot.docs
          .map((doc) => BingoCardModel.fromJson(doc.data()))
          .toList();

      _errorMessage = null; // Clear errors
    } catch (e) {
      _errorMessage = e.toString(); // Set error message
    } finally {
      _setLoading(false); // Reset loading state
    }
    notifyListeners();
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
