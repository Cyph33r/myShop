import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  final _authProvider = FirebaseAuth.instance;

  User? get user => _authProvider.currentUser;

  bool get isLoggedIn => _authProvider.currentUser != null;

  Future<bool> loginIn(
      {required String email, required String password}) async {
    try {
      await _authProvider.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
    return true;
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      await _authProvider.createUserWithEmailAndPassword(
          email: email, password: password);
    } on Exception catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
    return true;
  }

  Future signOut() async {
    _authProvider.signOut();
    notifyListeners();
  }
}
