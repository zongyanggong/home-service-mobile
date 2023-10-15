import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;
import '../services/info_state.dart';
import 'package:provider/provider.dart';
import '../share/notification_card.dart';

final FirestoreService _firestoreService = FirestoreService();

class NotificationsPage extends StatefulWidget {
  NotificationsPage({super.key});
  @override
  State<StatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: true);
    //get notificaiton data from firebase
    getNotifications() async {
      List<model.Notification> list =
          await _firestoreService.getNotifications();
      return list
          .where((element) => element.uid == info.currentUser.uid)
          .toList();
    }

    return Container(
        // height: 300, // Set a specific height
        child: FutureBuilder<List<model.Notification>>(
            future: getNotifications(),
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
                final notifications = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: ListView.builder(
                    itemCount: notifications!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        child: NotificationCard(
                          notification: notifications[index],
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ProviderDetailScreen(
                            //         serviceProvider: serviceProviders[index])));
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }));
  }
}
