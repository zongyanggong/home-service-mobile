import 'package:flutter/material.dart';

const List<String> appBarTitles = [
  "Requests",
  "Notifications",
  "Reviews",
  "Account"
];
const List<String> categories = [
  "Cleaning",
  "Plumber",
  "Electrician",
  "Painter",
  "Carpenter",
  "Gardener"
];
String format24HourTime(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
