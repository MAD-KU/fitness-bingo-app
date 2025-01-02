import 'package:application/models/bingocard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BingoCardController extends ChangeNotifier {
  List<BingoCardModel> _bingoCards = [];
  BingoCardModel? _bingoCard;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BingoCardModel> get bingoCards => _bingoCards;

  BingoCardModel? get bingoCard => _bingoCard;

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
  Future<void> updateBingoCard(
      String id, BingoCardModel updatedBingoCard) async {
    try {
      await FirebaseFirestore.instance
          .collection('bingoCards')
          .doc(id)
          .update(updatedBingoCard.toJson());

      // Update local list
      final index = _bingoCards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _bingoCards[index] = updatedBingoCard;
        notifyListeners();
      } else {
        _errorMessage = 'Bingo card not found';
      }
    } catch (e) {
      _errorMessage = e.toString(); // Capture and store error message
    }
  }

  // Delete a BingoCard by ID
  void deleteBingoCard(String id) {
    _bingoCards.removeWhere((card) => card.id == id);
    notifyListeners();
  }

  Future<void> getBingoCardById(String id) async {
    try {
      _setLoading(true);

      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('bingoCards')
          .doc(id)
          .get();

      if (doc.exists) {
        // Map Firestore data to BingoCardModel with ID
        _bingoCard = BingoCardModel.fromJson(doc.data()!..['id'] = doc.id);
        _errorMessage = null; // Clear errors
      } else {
        _errorMessage = 'Bingo card not found';
        _bingoCard = null; // Reset _bingoCard
      }
    } catch (e) {
      _errorMessage = e.toString();
      _bingoCard = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Get all BingoCards
  Future<void> getAllBingoCards() async {
    try {
      _setLoading(true); // Set loading state
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('bingoCards').get();

      // Map documents to BingoCardModel
      _bingoCards = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Add the document ID manually
        return BingoCardModel.fromJson(data); // Map to model
      }).toList();

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
