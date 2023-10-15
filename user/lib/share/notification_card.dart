import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

final FirestoreService _firestoreService = FirestoreService();

class NotificationInfo {
  final String providerImgPath;
  final String providerName;
  final String serviceName;
  final model.ServiceRecord servicerecord;

  NotificationInfo(this.providerImgPath, this.providerName, this.serviceName,
      this.servicerecord);
}

class NotificationCard extends StatelessWidget {
  NotificationCard({super.key, required this.notification, this.onTap});
  model.Notification notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    getNotificationInfo() async {
      model.ServiceRecord serviceRecord =
          await _firestoreService.getServiceRecordByRid(notification.rid);
      model.Provider provider =
          await _firestoreService.getProviderByPid(serviceRecord.pid);
      String serviceName =
          await _firestoreService.getServiceNameBySid(serviceRecord.sid);

      return NotificationInfo(
          provider.imgPath, provider.name, serviceName, serviceRecord);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: FutureBuilder<NotificationInfo>(
          future: getNotificationInfo(),
          builder:
              (BuildContext context, AsyncSnapshot<NotificationInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Data is still loading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Data loading has encountered an error
              return Text('Error: ${snapshot.error}');
            } else {
              // Data has been loaded successfully
              final notificationInfo = snapshot.data;

              return ListTile(
                onTap: onTap,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(notificationInfo!.providerImgPath),
                    ),
                  ),
                ),
                title: Text(
                  notificationInfo.providerName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  notificationInfo.serviceName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                // trailing: Text(notificationInfo.providerName +
                //     "'s " +
                //     notificationInfo.serviceName),
                // trailing: Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: <Widget>[
                //     // Text(
                //     //   // getNotificationTimeInfo(notificationInfo.servicerecord),
                //     //   "crated",
                //     //   style: const TextStyle(
                //     //       fontSize: 14, fontWeight: FontWeight.normal),
                //     // ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: Text(
                //         notificationInfo.servicerecord.status.toString(),
                //         style: const TextStyle(
                //             color: Colors.blueAccent,
                //             fontSize: 14,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     )
                //   ],
                // ),
              );
            }
          }),
    );
  }

  getTime(int time) {
    return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time).hour, minute: DateTime.fromMillisecondsSinceEpoch(time).minute))}";
  }

  getNotificationTimeInfo(model.ServiceRecord serviceRecord) {
    if (serviceRecord.status == model.RecordStatus.pending) {
      return "Created at ${getTime(serviceRecord.createdTime)}";
    } else if (serviceRecord.status == model.RecordStatus.confirmed) {
      return "Confirmed at ${getTime(serviceRecord.acceptedTime)}, Service booking time is ${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).minute))}";
    } else if (serviceRecord.status == model.RecordStatus.started) {
      return "Started at ${getTime(serviceRecord.actualStartTime)}";
    } else if (serviceRecord.status == model.RecordStatus.completed) {
      return "Completed at ${getTime(serviceRecord.actualEndTime)}";
    } else if (serviceRecord.status == model.RecordStatus.rejected) {
      return "Completed at ${getTime(serviceRecord.actualEndTime)}";
    } else {
      return "Unknown";
    }
  }
}
