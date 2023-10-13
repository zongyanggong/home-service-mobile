import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/profile/profile.dart';
import 'package:user/services/service.dart';
import 'package:user/services/user.dart';
import 'package:user/share/account_button.dart';
import 'package:user/share/account_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    // var currentUser = Provider.of<CurrentUser>(context,listen: false);

    CurrentUser currentUser = CurrentUser();
    currentUser.name = "Mark";
    currentUser.imgPath = 'assets/images/face1.jpg';
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: AccountCard(
                name: currentUser.name,
                imgPath: currentUser.imgPath,
                onViewProfile: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileSceen()));
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child:
                  AccountButton(iconData: Icons.event_note, title: "Feedback"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: AccountButton(
                  iconData: Icons.account_circle, title: "About Us"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: AccountButton(
                  iconData: Icons.language, title: "Change language"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child:
                  AccountButton(iconData: Icons.lock, title: "Privacy Policy"),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            onPressed: () {
              _signOut(context);
            },
            child: const Text("Logout"),
          ),
        ),
      ],
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