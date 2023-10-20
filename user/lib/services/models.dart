import 'package:json_annotation/json_annotation.dart';
import 'package:user/services/record_status.dart';
part 'models.g.dart';

@JsonSerializable()
class User {
  String? uid;
  String? name;
  String? email;
  String? address;
  String? phone;
  String? imgPath;
  String? fcmToken;

  User({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.address = "",
    this.phone = "",
    this.imgPath = "",
    this.fcmToken = "",
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Service {
  final String sid;
  final String name;

  Service({
    this.sid = "",
    this.name = "",
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}

@JsonSerializable()
class ServiceRecord {
  final String rid;
  final String uid;
  final String sid;
  final String pid;
  final RecordStatus status;
  final int createdTime;
  final int acceptedTime;
  final int actualStartTime;
  final int actualEndTime;
  final int bookingStartTime;
  final int bookingEndTime;
  final String appointmentNotes;
  final double score;
  final String review;
  final double price;

  ServiceRecord({
    this.rid = "",
    this.uid = "",
    this.sid = "",
    this.pid = "",
    this.status = RecordStatus.pending,
    this.createdTime = 0,
    this.acceptedTime = 0,
    this.actualStartTime = 0,
    this.actualEndTime = 0,
    this.bookingStartTime = 0,
    this.bookingEndTime = 0,
    this.appointmentNotes = "",
    this.score = 0.0,
    this.review = "",
    this.price = 0.0,
  });

  factory ServiceRecord.fromJson(Map<String, dynamic> json) =>
      _$ServiceRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceRecordToJson(this);
}

@JsonSerializable()
class Provider {
  final String pid;
  final String name;
  final String email;
  final String address;
  final String phone;
  final String sid; //service he can prodive, only one service for now
  final double price;
  final String description;
  final String imgPath;
  final String fcmToken;

  Provider({
    this.pid = "",
    this.name = "",
    this.email = "",
    this.address = "",
    this.phone = "",
    this.sid = "",
    this.price = 0.0,
    this.description = "",
    this.imgPath = "",
    this.fcmToken = "",
  });

  factory Provider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderToJson(this);
}

//Notification
@JsonSerializable()
class Notification {
  final String uid;
  final String pid;
  final String rid;
  final String title;
  final String message;
  final int timeStamp;

  Notification({
    this.uid = "",
    this.pid = "",
    this.rid = "",
    this.title = "",
    this.message = "",
    this.timeStamp = 0,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
