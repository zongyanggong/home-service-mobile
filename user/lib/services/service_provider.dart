// ignore_for_file: unused_import, unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:user/services/service_category.dart';

class ServiceProvider{
  late int _pid;
  int get pid => _pid;
  set pid(int value){
    _pid = value;
  }

  late String _name;
  String get name => _name;
  set name(String value){
    _name = value;
  }

  late String _email;
  String get email => _email;

  late String _address;
  String get address => _address;

  late String _phone;
  String get phone => _phone;

  late int _sid;
  int get sid => _sid;

  late String _imgPath;
  String get imgPath => _imgPath;
  set imgPath(String value){
    _imgPath = value;
  }

  late int _price;
  int get price => _price;
  set price(int value){
    _price = value;
  }

  late String _description;
  String get description => _description;
  set description(String value){
    _description = value;
  }

  late ServiceCategory service;
  late double score;
}