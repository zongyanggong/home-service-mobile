import 'package:flutter/material.dart';
import 'package:user/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './services/service.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
                // return isUserSignedIn ? HomeScreen() : LoginPage();
                return LoginPage();
              }
              return const CircularProgressIndicator();
            },
          ),
          routes: {
            '/login': (context) => LoginPage(),
            '/home': (context) => HomeScreen(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ));
  }
}