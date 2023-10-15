import 'package:flutter/material.dart';
import 'package:user/services/models.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_category.dart';

class TempServiceRecord{
  late int rid;
  late String name;
  late String address;
  late String imgPath;
  late double price;
  late RecordStatus status;
  late int uid;
  late int sid;
  late int pid;
  late DateTime createTime;
  late DateTime? acceptedTime;
  late DateTime expectedDate;
  late DateTime actualDate;
  late int bookingStartTime;
  late int bookingEndTime;
  late DateTime? actualStartTime;
  late DateTime? actualEndTime;
  late String? review;
  late double? score;
}