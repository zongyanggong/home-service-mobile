import 'package:flutter/material.dart';
import './models.dart';

class Info extends ChangeNotifier {
  Provider _currentUser = Provider(
    pid: "",
    name: "",
    email: "",
    phone: '',
    sid: 0,
    price: 0.0,
    description: "",
    imgPath: "",
  );

  Provider get currentUser => _currentUser;

  setProvider(Provider value) {
    _currentUser = value;
    notifyListeners();
  }

  resetProvider() {
    _currentUser = Provider(
      pid: "",
      name: "",
      email: "",
      phone: '',
      sid: 0,
      price: 0.0,
      description: "",
      imgPath: "",
    );
  }

  List<String> _currentServiceList = [];

  getService() {
    return _currentServiceList;
  }

  setService(List<String> value) {
    _currentServiceList = value;
    notifyListeners();
  }
}
