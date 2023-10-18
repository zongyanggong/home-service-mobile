// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      address: json['address'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      imgPath: json['imgPath'] as String? ?? "",
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'imgPath': instance.imgPath,
    };

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      sid: json['sid'] as String? ?? "",
      name: json['name'] as String? ?? "",
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'sid': instance.sid,
      'name': instance.name,
    };

ServiceRecord _$ServiceRecordFromJson(Map<String, dynamic> json) =>
    ServiceRecord(
      rid: json['rid'] as String? ?? "",
      uid: json['uid'] as String? ?? "",
      sid: json['sid'] as String? ?? "",
      pid: json['pid'] as String? ?? "",
      status: $enumDecodeNullable(_$RecordStatusEnumMap, json['status']) ??
          RecordStatus.pending,
      createdTime: json['createdTime'] as int? ?? 0,
      acceptedTime: json['acceptedTime'] as int? ?? 0,
      actualStartTime: json['actualStartTime'] as int? ?? 0,
      actualEndTime: json['actualEndTime'] as int? ?? 0,
      bookingStartTime: json['bookingStartTime'] as int? ?? 0,
      bookingEndTime: json['bookingEndTime'] as int? ?? 0,
      appointmentNotes: json['appointmentNotes'] as String? ?? "",
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      review: json['review'] as String? ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0.00,
    );

Map<String, dynamic> _$ServiceRecordToJson(ServiceRecord instance) =>
    <String, dynamic>{
      'rid': instance.rid,
      'uid': instance.uid,
      'sid': instance.sid,
      'pid': instance.pid,
      'status': _$RecordStatusEnumMap[instance.status]!,
      'createdTime': instance.createdTime,
      'acceptedTime': instance.acceptedTime,
      'actualStartTime': instance.actualStartTime,
      'actualEndTime': instance.actualEndTime,
      'bookingStartTime': instance.bookingStartTime,
      'bookingEndTime': instance.bookingEndTime,
      'appointmentNotes': instance.appointmentNotes,
      'score': instance.score,
      'review': instance.review,
      'price': instance.price,
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
      pid: json['pid'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      sid: json['sid'] as String? ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? "",
      imgPath: json['imgPath'] as String? ?? "",
    );

Map<String, dynamic> _$ProviderToJson(Provider instance) => <String, dynamic>{
      'pid': instance.pid,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'sid': instance.sid,
      'price': instance.price,
      'description': instance.description,
      'imgPath': instance.imgPath,
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      uid: json['uid'] as String? ?? "",
      rid: json['rid'] as String? ?? "",
      timeStamp: json['timeStamp'] as int? ?? 0,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'rid': instance.rid,
      'timeStamp': instance.timeStamp,
    };
