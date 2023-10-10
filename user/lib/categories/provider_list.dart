import 'package:flutter/material.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/user_card.dart';

class ProviderList extends StatelessWidget {
  ProviderList({super.key, required this.cid});
  int cid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: AppBarTitle(title: categories[cid],),
      ) ,
      body: ListView(
          children: [const UserCard(),const UserCard()]),
    );
  }
}
