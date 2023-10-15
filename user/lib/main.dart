import 'package:flutter/material.dart';
import 'package:user/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:user/services/firebase_api.dart';
import './services/service.dart';
import 'firebase_options.dart';
import 'services/firebase_api.dart';
import 'notifications/notifications.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(HomeServiceApp());
}

class HomeServiceApp extends StatelessWidget {
  HomeServiceApp({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => Info(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Home service",
          home: FutureBuilder(
            future: _auth.isUserSignedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                bool isUserSignedIn = snapshot.data as bool;
                return isUserSignedIn ? HomeScreen() : LoginPage();
              }
              return const CircularProgressIndicator();
            },
          ),
          navigatorKey: navigatorKey,
          routes: {
            '/login': (context) => LoginPage(),
            '/home': (context) => HomeScreen(),
            '/notifications': (context) => NotificationsPage(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ));
  }
}
