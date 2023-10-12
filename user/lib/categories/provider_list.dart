import 'package:flutter/material.dart';
import 'package:user/categories/provider_detail.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/category_card.dart';
import 'package:user/share/user_card.dart';

class ProviderList extends StatelessWidget {
  ProviderList({super.key, required this.cid});
  int cid;

  final List<ServiceProvider> serviceProviders = [
    ServiceProvider()
      ..pid = 1
      ..name = "Provider 1"
      ..imgPath = 'assets/images/face1.jpg'
      ..price = 50
      ..score = 4.5
    ..description="experienc1abcdefghhhjhkdfefsfeefefefefefesfefefefefewfefefsdfefefefe",
    ServiceProvider()
      ..pid = 2
      ..name = 'Provider 2'
      ..imgPath = 'assets/images/face2.jpg'
      ..price = 60
      ..score = 3.8
      ..description="experienc2perienc1abcdefghhhjhkdfefsfeefefefefefesfefefeefefefesfefefefefewfefefsdfef",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: categories[cid],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: ListView.builder(
          itemCount: serviceProviders.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 9),
              child: UserCard(serviceProvider: serviceProviders[index],onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProviderDetailScreen(serviceProvider: serviceProviders[index])));
              },),
            );
          },
        ),
      ),
    );
  }
}
