import 'package:flutter/material.dart';
import './models.dart';

class Info extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  setUser(User? value) {
    _currentUser = value;
    notifyListeners();
  }

  resetInfo() {
    // sleepValue = 3;
  }
}
