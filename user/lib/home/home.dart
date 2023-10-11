import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/services/user.dart';
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
  late final List<Widget> _tabPages =[
    const RequestsPage(),
    const NotificationsPage(),
    const CategoriesPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentUser>(
      create: (BuildContext context) => CurrentUser(),
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(title: appBarTitles[_selectedIndex],),
          automaticallyImplyLeading: false,
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


}

