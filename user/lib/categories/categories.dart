// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:user/categories/provider_list.dart';
import 'package:user/service/appbar_titles.dart';
import 'dart:math';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Which service do you need?",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            height: 600,
            margin: const EdgeInsets.only(left: 6,right: 5),
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                children: List.generate(
                    6,
                    (index) => Container(
                      margin: const EdgeInsets.all(10),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 350), () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProviderList(
                                      cid: index,)));
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                   "./assets/images/${categories[index]}.png",height: 80,width: 80,),

                              Text(categories[index])
                            ],
                          ),
                        ),
                      ),
                    ))))
      ],
    );
  }
}
