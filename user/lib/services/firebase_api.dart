import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user/main.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print('Handling a background message ${message.notification?.title}');
  print('Handling a background message ${message.notification?.body}');
  print('Handling a background message ${message.data}');
}

class FirebaseApi {
  //Create an instance of FirebaseMessaging
  final _fcm = FirebaseMessaging.instance;
  final FirestoreService _firestoreService = FirestoreService();

  //Function to initialize notifications
  Future initNotifications() async {
    //Request permission from user(will prompt user for permission if not already granted)
    await _fcm.requestPermission();

    //fetch the FCM token for this device
    String? token = await _fcm.getToken();
    print('Token: $token'); //normally you would save this token to your server

    //initialize further settings for pushing notifications
    initPushNotifications();
  }

//Function to handle received messages
  void handleMessage(RemoteMessage message) {
    if (message.notification == null) return;

    //navigate to new screen when message is recevied and user taps on notification
    navigatorKey.currentState?.pushNamed(
      '/notifications',
      arguments: message,
    );
  }

  void saveMessageToDatabase(RemoteMessage message) {
    if (message.notification == null) return;

    _firestoreService.createNotification(model.Notification(
      uid: message.data["uid"],
      rid: message.data["rid"],
      timeStamp: int.parse(message.data["timeStamp"]),
    ));
    //navigate to new screen when message is recevied and user taps on notification
  }

  //Function to initialize background settings
  Future initPushNotifications() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
      }
    });

    //attach event listener for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    //attach event listener for when a notification is received while the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      saveMessageToDatabase(message);
      //handleMessage(message);
    });

    //attach event listener for when a notification is received while the app is in the background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}