import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String? name;
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
  final int rid;
  final int uid;
  final int sid;
  final int pid;
  final RecordStatus status;
  final int createdTime;
  final int startTime;
  final int endTime;

  ServiceRecord({
    this.rid = 0,
    this.uid = 0,
    this.sid = 0,
    this.pid = 0,
    this.status = RecordStatus.pending,
    this.createdTime = 0,
    this.startTime = 0,
    this.endTime = 0,
  });

  factory ServiceRecord.fromJson(Map<String, dynamic> json) =>
      _$ServiceRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceRecordToJson(this);
}

@JsonSerializable()
class Provider {
  final int pid;
  final String name;
  final String email;
  final String address;
  final String phone;
  final int sid; //service he can prodive, only one service for now
  final double price;
  final String description;

  Provider({
    this.pid = 0,
    this.name = "",
    this.email = "",
    this.address = "",
    this.phone = "",
    this.sid = 0,
    this.price = 0,
    this.description = "",
  });

  factory Provider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderToJson(this);
}
