import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: const Center(
        child: Text("Home1"),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _googleSignIn.signOut();
      // You can navigate to the login screen or any other screen after logout.
      // Example:
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Unable to logout: $e';
    }
  }
}
