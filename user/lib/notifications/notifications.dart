import 'package:flutter/material.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;
import '../services/info_state.dart';
import 'package:provider/provider.dart';
import 'package:user/share/notification_field.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';

final FirestoreService _firestoreService = FirestoreService();

Map<String, dynamic> statusMap = {
  'pending': 'New Appointment',
  'confirmed': 'Service confirmed',
  'started': 'Service started',
  'completed': 'Service completed',
  'rejected': 'Service rejected',
  'reviewed': 'Service reviewed',
  'canceled': 'Service canceled',
};

class NotificationRecord {
  late String title;
  late String date;
  late String message;
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: true);

    getMessage(sr, services) {
      String statusStr = sr.status.toString().split('.').last;

      //Get service string name
      String serviceName = "";
      services.forEach((element) {
        if (sr.sid == element.sid) {
          serviceName = element.name;
        }
      });

      switch (statusStr) {
        case 'pending':
          return "You have received new appointment with the ${serviceName}";
        case 'confirmed':
          return "Your appointment with the ${serviceName} has been confirmed";
        case 'started':
          return "Your appointment with the ${serviceName} has been started";

        case 'completed':
          return "Your appointment with the ${serviceName} has been completed";

        case 'rejected':
          return "Your appointment with the ${serviceName} has been rejected";
        case 'reviewed':
          return "Your appointment with the ${serviceName} has been reviewed";

        default: // 'canceled'
          return "Your appointment with the ${serviceName} has been canceled";
      }
    }

    getFormatTime(int time) {
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time).hour, minute: DateTime.fromMillisecondsSinceEpoch(time).minute))}";
    }

    getTime(model.ServiceRecord sr) {
      String statusStr = sr.status.toString().split('.').last;
      switch (statusStr) {
        case 'pending':
          return getFormatTime(sr.createdTime);
        case 'confirmed':
          return getFormatTime(sr.acceptedTime);
        case 'started':
          return getFormatTime(sr.actualStartTime);
        case 'completed':
          return getFormatTime(sr.actualEndTime);
        case 'rejected':
          return getFormatTime(sr.acceptedTime);
        case 'reviewed':
          return getFormatTime(sr.bookingEndTime);
        default: // 'canceled'
          return getFormatTime(sr.acceptedTime);
      }
    }

    getNotificationRecords() async {
      //Get current user's notifications
      List<model.Notification> notifications =
          await _firestoreService.getNotifications();
      notifications =
          notifications.where((e) => e.uid == info.currentUser.uid).toList();

      //Get current user's service records
      List<model.ServiceRecord> serviceRecords =
          await _firestoreService.getServiceRecord();
      serviceRecords =
          serviceRecords.where((e) => e.uid == info.currentUser.uid).toList();

      //Get service names
      List<model.Service> services = await _firestoreService.getService();

      //Create notification records for display
      List<NotificationRecord> notifiscationRecordList =
          notifications.map((notification) {
        model.ServiceRecord sr =
            serviceRecords.firstWhere((e) => e.rid == notification.rid);
        String statusStr = sr.status.toString().split('.').last;
        return NotificationRecord()
          ..title = statusMap[statusStr] ??
              "Default Title" // Use a default title if the status is null
          ..date = getTime(sr)
          ..message = getMessage(sr, services);
      }).toList();

      return notifiscationRecordList;
    }

    return info.currentUser.uid == ""
        ? const Padding(
            padding: EdgeInsets.all(16.0), // Adjust the value as needed
            child: Center(
              child: Text(
                "Please login to see your notifications",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ))
        : FutureBuilder<List<NotificationRecord>>(
            future: getNotificationRecords(),
            builder: (BuildContext context,
                AsyncSnapshot<List<NotificationRecord>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Data is still loading
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Data loading has encountered an error
                return Text('Error: ${snapshot.error}');
              } else {
                // Data has been loaded successfully
                final notifiscationRecords = snapshot.data;
                if (notifiscationRecords == null) {
                  return const Center(
                    child: Text("No notification"),
                  );
                }

                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: notifiscationRecords.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        child: NotificationField(
                          title: notifiscationRecords[
                                  notifiscationRecords.length - 1 - index]
                              .title,
                          date: notifiscationRecords[
                                  notifiscationRecords.length - 1 - index]
                              .date,
                          message: notifiscationRecords[
                                  notifiscationRecords.length - 1 - index]
                              .message,
                          // date: notifiscationRecords[index].date,
                          // message: notifiscationRecords[index].message,
                        ),
                      );
                    },
                  ),
                ));
              }
            });
  }
}
