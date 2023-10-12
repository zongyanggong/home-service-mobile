import 'package:flutter/material.dart';
import 'package:user/categories/provider_book.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/category_card.dart';
import 'package:user/share/user_card.dart';

class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({super.key, required this.serviceProvider});
  final ServiceProvider serviceProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: "",
        ),
      ),
      body: ListView(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ProviderDetail(
                serviceProvider: serviceProvider,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
              child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50], // Background color
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "About",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(serviceProvider.description,
                            style: const TextStyle(
                              fontSize: 16,
                            )),
                      )
                    ],
                  )),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () {Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProviderBookScreen(serviceProvider: serviceProvider)));},
                child: const Text("Book Now"),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
