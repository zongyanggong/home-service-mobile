import 'package:flutter/material.dart';
import './models.dart';

class Info extends ChangeNotifier {
  User _currentUser = User(
    uid: "",
    name: "",
    email: "",
    address: '',
    phone: '',
    imgPath: "",
  );

  User get currentUser => _currentUser;

  setUser(User value) {
    _currentUser = value;
    notifyListeners();
  }

  resetUser() {
    _currentUser = User(
      uid: "",
      name: "",
      email: "",
      address: '',
      phone: '',
      imgPath: "",
    );
  }
}
