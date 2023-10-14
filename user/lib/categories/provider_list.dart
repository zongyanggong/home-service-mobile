// ignore_for_file: unused_import, must_be_immutable

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
    ..description="experienc1 I have three years of experience working for a professional plumbing company called Publer. During my time there, I gained extensive knowledge and skills in various plumbing tasks, including pipe repairs, installations, and maintenance. I have successfully resolved numerous plumbing issues for residential and commercial clients, ensuring their satisfaction and building a reputation for reliability and quality service. My experience at Publer has equipped me with the expertise to tackle diverse plumbing challenges efficiently and effectively.",
    ServiceProvider()
      ..pid = 2
      ..name = 'Provider 2'
      ..imgPath = 'assets/images/face2.jpg'
      ..price = 60
      ..score = 3.8
      ..description="experienc2 I have three years of experience in the plumbing industry, having worked for a reputable company known for its expertise in residential and commercial plumbing solutions. During my tenure, I honed my skills in diagnosing complex plumbing issues, conducting repairs, and installing new systems. My responsibilities included collaborating with clients to understand their specific needs, providing cost estimates, and ensuring timely completion of projects. This hands-on experience has equipped me with a deep understanding of plumbing systems and a knack for finding innovative solutions to various challenges.",
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
