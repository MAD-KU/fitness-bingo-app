import 'package:application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  UserModel? _selectedUser;
  UserModel? get selectedUser => _selectedUser;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Pagination fields
  int _usersPerPage = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreUsers = true;
  bool get hasMoreUsers => _hasMoreUsers;

  // Keep a copy of the original fetched users
  List<UserModel> _originalUsers = [];

  // Fetch all users (for Manage Users screen)
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs
          .map((doc) => UserModel.fromJson(
          {'id': doc.id, ...doc.data() as Map<String, dynamic>}))
          .toList();
      // Initialize _originalUsers with the fetched users
      _originalUsers = List.from(_users);
    } catch (e) {
      _errorMessage = "Failed to fetch users: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a specific user by ID (for User Details screen)
  Future<void> fetchUserById(String userId) async {
    _isLoading = true;
    _errorMessage = "";
    _selectedUser = null;
    notifyListeners();

    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _selectedUser = UserModel.fromJson(
            {'id': doc.id, ...doc.data() as Map<String, dynamic>});
      } else {
        _errorMessage = "User not found";
      }
    } catch (e) {
      _errorMessage = "Failed to fetch user: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search users (case-insensitive)
  void searchUsers(String query) {
    if (query.isEmpty) {
      // If query is empty, reset to the original list and DO NOT reset pagination or fetch initial data
      _users = List.from(_originalUsers);
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();

      try {
        // Filter the original list based on the query
        _users = _originalUsers.where((user) {
          final name = user.name?.toLowerCase() ?? '';
          final email = user.email?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase());
        }).toList();
      } catch (e) {
        _errorMessage = "Error during search: $e";
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Sort users alphabetically by name (case-insensitive)
  void sortUsersByName() {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _users.sort((a, b) => a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase()));
    } catch (e) {
      _errorMessage = "Error during sorting: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to set users (used for restoring the original list)
  void setUsers(List<UserModel> users) {
    _users = users;
    notifyListeners();
  }

  // Fetch users with pagination
  Future<void> fetchUsersWithPagination() async {
    if (!_hasMoreUsers || _isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Query query = _firestore
          .collection('users')
          .orderBy('name')
          .limit(_usersPerPage);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        final List<UserModel> fetchedUsers = querySnapshot.docs
            .map((doc) => UserModel.fromJson(
            {'id': doc.id, ...doc.data() as Map<String, dynamic>}))
            .toList();
        _users.addAll(fetchedUsers);
        // Update _originalUsers with newly fetched data
        _originalUsers.addAll(fetchedUsers);
      } else {
        _hasMoreUsers = false;
      }
    } catch (e) {
      _errorMessage = 'Error fetching users: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset pagination (call this when you want to start fetching from the beginning)
  void resetPagination() {
    _lastDocument = null;
    _hasMoreUsers = true;
    _users = [];
  }
}