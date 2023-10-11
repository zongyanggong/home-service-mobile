import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:user/services/user.dart';
import '../services/service.dart';
import 'package:user/account/account.dart';
import 'package:user/categories/categories.dart';
import 'package:user/notifications/notifications.dart';
import 'package:user/requests/requests.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/share/appBarTitle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final List<Widget> _tabPages =[
    const RequestsPage(),
    const NotificationsPage(),
    const CategoriesPage(),
    const AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentUser>(
      create: (BuildContext context) => CurrentUser(),
      child: Scaffold(
        appBar: AppBar(
          // title: Text(appBarTitles[_selectedIndex]),
          title: AppBarTitle(title: appBarTitles[_selectedIndex],),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _signOut(context),
            ),
          ],
        ),
        body: ListView(children: [_tabPages[_selectedIndex]],),
          bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(
            Icons.free_cancellation,
          ),label: "Requests"),
          BottomNavigationBarItem(icon: Icon(
            Icons.notifications,
          ),label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(
            Icons.more_horiz,
          ),label: "Categories"),
          BottomNavigationBarItem(icon: Icon(
            Icons.account_box,
          ),label: "Account"),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
            setState(() {
              _selectedIndex=index;
            });
        },
      ),
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

