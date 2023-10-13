import 'package:flutter/material.dart';
import './models.dart';

class Info extends ChangeNotifier {
  late User _currentUser;
  User get currentUser => _currentUser;

  setUser(User value) {
    _currentUser = value;
    notifyListeners();
  }

  resetInfo() {
    // sleepValue = 3;
  }
}
