import 'package:flutter/material.dart';
import 'package:user/services/service_category.dart';

class CurrentUser with ChangeNotifier{
  late int _uid;
  int get uid => _uid;
  set uid(int value){
    _uid = value;
    notifyListeners();
  }

  late String _name;
  String get name => _name;
  set name(String value){
    _name = value;
    notifyListeners();
  }

  late String _email;
  String get email => _email;
  set email(String value){
    _email = value;
    notifyListeners();
  }

  late String _address;
  String get address => _address;
  set address(String value){
    _address = value;
    notifyListeners();
  }

  late String _phone;
  String get phone => _phone;
  set phone(String value){
    _phone = value;
    notifyListeners();
  }

  late String _imgPath;
  String get imgPath => _imgPath;
  set imgPath(String value){
    _imgPath = value;
    notifyListeners();
  }
}