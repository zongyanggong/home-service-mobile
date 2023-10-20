import 'package:flutter/material.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;
import '../services/info_state.dart';
import 'package:provider/provider.dart';
import 'package:user/share/notification_field.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';

final FirestoreService _firestoreService = FirestoreService();

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: true);

    getFormatTime(int time) {
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time).hour, minute: DateTime.fromMillisecondsSinceEpoch(time).minute))}";
    }

    Future<List<model.Notification>>? getNotificationRecords() async {
      //Get current user's notifications
      List<model.Notification>? notifications =
          await _firestoreService.getNotifications();
      notifications =
          notifications.where((e) => e.uid == info.currentUser.uid).toList();
      notifications.sort((a, b) => (a.timeStamp).compareTo(b.timeStamp));

      return notifications;
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
        : FutureBuilder<List<model.Notification>>(
            future: getNotificationRecords(),
            builder: (BuildContext context,
                AsyncSnapshot<List<model.Notification>> snapshot) {
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
                          date: getFormatTime(notifiscationRecords[
                                  notifiscationRecords.length - 1 - index]
                              .timeStamp),
                          message: notifiscationRecords[
                                  notifiscationRecords.length - 1 - index]
                              .message,
                        ),
                      );
                    },
                  ),
                ));
              }
            });
  }
}
