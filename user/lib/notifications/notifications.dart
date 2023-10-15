import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;
import '../services/info_state.dart';
import 'package:provider/provider.dart';
import '../share/notification_card.dart';
import 'package:user/share/notification_field.dart';

final FirestoreService _firestoreService = FirestoreService();

final List<Notifiscation> notifcations = [
  Notifiscation()
    ..title = "New Appointment"
    ..date = "20 Dec 2023"
    ..message = "You have received new appointment for service",
  Notifiscation()
    ..title = "Service started"
    ..date = "22 Dec 2023"
    ..message = "The service is started",
];

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: notifcations.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: NotificationField(
                title: notifcations[index].title,
                date: notifcations[index].date,
                message: notifcations[index].message,
              ),
            );
          },
        ),
      ),
    );
    ;
  }
}

class Notifiscation {
  late String title;
  late String date;
  late String message;
}
