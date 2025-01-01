import 'package:application/models/auth_model.dart';
import 'package:application/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  Future<String?> signup(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signin(AuthModel authModel) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: authModel.email!,
        password: authModel.password!,
      );

      DocumentSnapshot user = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return user['role'];
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> getCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDetails = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        _currentUser = UserModel(
          id: user.uid,
          name: userDetails['name'],
          email: userDetails['email'],
          role: userDetails['role'],
        );
      }
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        return user.uid;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  signOut() async {
    _auth.signOut();
  }
}
