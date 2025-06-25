import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthState() async {
    final user = _firebaseService.getCurrentUser();
    _isAuthenticated = user != null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = await _firebaseService.signIn(email, password);
      _isAuthenticated = user != null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    try {
      final user = await _firebaseService.register(email, password);
      _isAuthenticated = user != null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }
}