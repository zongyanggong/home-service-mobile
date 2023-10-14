import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class User {
  String? uid;
  String? name;
  String? email;
  String? address;
  String? phone;
  String? imgPath;

  User({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.address = "",
    this.phone = "",
    this.imgPath = "",
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Service {
  final int sid;
  final String name;

  Service({
    this.sid = 0,
    this.name = "",
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}

enum RecordStatus {
  pending,
  confirmed,
  started,
  completed,
  rejected,
  reviewed,
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
  });

  factory ServiceRecord.fromJson(Map<String, dynamic> json) =>
      _$ServiceRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceRecordToJson(this);
}

@JsonSerializable()
class Provider {
  String? pid;
  String? name;
  String? email;
  String? phone;
  int? sid; //service he can prodive, only one service for now
  double? price;
  String? description;
  String? imgPath;

  Provider({
    this.pid = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.sid = 0,
    this.price = 0,
    this.description = "",
    this.imgPath = "",
  });

  factory Provider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderToJson(this);
}