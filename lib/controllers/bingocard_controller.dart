import 'package:application/models/bingocard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BingoCardController extends ChangeNotifier {
  List<BingoCardModel> _bingoCards = [];
  BingoCardModel? _bingoCard;
  bool _isLoading = false;
  String? _errorMessage;

  List<BingoCardModel> get bingoCards => _bingoCards;

  BingoCardModel? get bingoCard => _bingoCard;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  void addBingoCard(BingoCardModel bingoCard) async {
    await FirebaseFirestore.instance
        .collection('bingoCards')
        .add(bingoCard.toJson());

    getAllBingoCardsForUser(bingoCard.userId!);
    notifyListeners();
  }

  Future<void> updateBingoCard(
      String id, BingoCardModel updatedBingoCard) async {
    try {
      await FirebaseFirestore.instance
          .collection('bingoCards')
          .doc(id)
          .update(updatedBingoCard.toJson());

      final index = _bingoCards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _bingoCards[index] = updatedBingoCard;
        notifyListeners();
      } else {
        _errorMessage = 'Bingo card not found';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> deleteBingoCard(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('bingoCards')
          .doc(id)
          .delete();

      _bingoCards.removeWhere((card) => card.id == id);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
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
        _bingoCard = BingoCardModel.fromJson(doc.data()!..['id'] = doc.id);
        _errorMessage = null;
      } else {
        _errorMessage = 'Bingo card not found';
        _bingoCard = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _bingoCard = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getAllBingoCards() async {
    try {
      _setLoading(true);
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('bingoCards').get();

      _bingoCards = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return BingoCardModel.fromJson(data);
      }).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> getAllBingoCardsForUser(String userId) async {
    try {
      _setLoading(true);

      QuerySnapshot<Map<String, dynamic>> snapshotDefault =
          await FirebaseFirestore.instance
              .collection('bingoCards')
              .where('category', isEqualTo: "default")
              .get();

      QuerySnapshot<Map<String, dynamic>> snapshotUser = await FirebaseFirestore
          .instance
          .collection('bingoCards')
          .where('userId', isEqualTo: userId)
          .get();

      Set<String> uniqueIds = {};
      _bingoCards = [
        ...snapshotDefault.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          uniqueIds.add(doc.id);
          return BingoCardModel.fromJson(data);
        }),
        ...snapshotUser.docs
            .where((doc) => !uniqueIds.contains(doc.id))
            .map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return BingoCardModel.fromJson(data);
        })
      ];

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
