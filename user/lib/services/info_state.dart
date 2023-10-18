import 'package:flutter/material.dart';
import 'package:user/services/record_status.dart';
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

  ServiceRecord _serviceRecord = ServiceRecord(
    rid: "1",
    uid: "1",
    sid: "1",
    pid: "1",
    status: RecordStatus.pending,
    createdTime: 0,
    acceptedTime: 0,
    actualStartTime: 0,
    actualEndTime: 0,
    bookingStartTime: 0,
    bookingEndTime: 0,
    score: 0.0,
    review: "",
  );

  ServiceRecord get serviceRecord => _serviceRecord;

  setServiceRecord(ServiceRecord value) {
    _serviceRecord = value;
    notifyListeners();
  }
}
