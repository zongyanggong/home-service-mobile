// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      address: json['address'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
    };

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      sid: json['sid'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      category: json['category'] as String? ?? "",
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'sid': instance.sid,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
    };

ServiceRecord _$ServiceRecordFromJson(Map<String, dynamic> json) =>
    ServiceRecord(
      rid: json['rid'] as int? ?? 0,
      uid: json['uid'] as int? ?? 0,
      sid: json['sid'] as int? ?? 0,
      pid: json['pid'] as int? ?? 0,
      status: $enumDecodeNullable(_$RecordStatusEnumMap, json['status']) ??
          RecordStatus.pending,
      createdTime: json['createdTime'] as int? ?? 0,
      startTime: json['startTime'] as int? ?? 0,
      endTime: json['endTime'] as int? ?? 0,
    );

Map<String, dynamic> _$ServiceRecordToJson(ServiceRecord instance) =>
    <String, dynamic>{
      'rid': instance.rid,
      'uid': instance.uid,
      'sid': instance.sid,
      'pid': instance.pid,
      'status': _$RecordStatusEnumMap[instance.status]!,
      'createdTime': instance.createdTime,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

const _$RecordStatusEnumMap = {
  RecordStatus.pending: 'pending',
  RecordStatus.confirmed: 'confirmed',
  RecordStatus.started: 'started',
  RecordStatus.completed: 'completed',
  RecordStatus.rejected: 'rejected',
  RecordStatus.reviewed: 'reviewed',
};

Provider _$ProviderFromJson(Map<String, dynamic> json) => Provider(
      pid: json['pid'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      address: json['address'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      sid: json['sid'] as int? ?? 0,
    );

Map<String, dynamic> _$ProviderToJson(Provider instance) => <String, dynamic>{
      'pid': instance.pid,
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'sid': instance.sid,
    };
