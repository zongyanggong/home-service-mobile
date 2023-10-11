import 'package:flutter/material.dart';
import 'package:user/services/service_category.dart';

class ServiceProvider{
  late int _pid;
  int get pid => _pid;

  late String _name;
  String get name => _name;

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

  late String _description;
  String get description => _description;

  late ServiceCategory service;
  late double score;
}