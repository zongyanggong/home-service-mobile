import 'package:flutter/material.dart';
import 'package:user/home/home.dart';

void main() {
  runApp(const HomeServiceApp());
}

class HomeServiceApp extends StatelessWidget {
  const HomeServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Home service",
      home: HomeScreen(),
    );
  }
}


