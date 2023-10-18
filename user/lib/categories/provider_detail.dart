import 'package:flutter/material.dart';
import 'package:user/categories/provider_book.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/category_card.dart';
import 'package:user/share/user_card.dart';
import '../services/models.dart' as model;
import '../services/info_state.dart';
import 'package:provider/provider.dart';

class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({super.key, required this.serviceProvider});
  final model.Provider serviceProvider;

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: "Profile",
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
                  height: 350,
                  width: MediaQuery.of(context).size.width,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
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
                  onPressed: info.currentUser.uid == ""
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProviderBookScreen(
                                  serviceProvider: serviceProvider)));
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        // Button is disabled, so return the grey color
                        return Colors.grey; // You can adjust this color
                      }
                      return Colors
                          .blue; // Default color when the button is active
                    }),
                  ),
                  child: const Text("Book Now",
                      style: TextStyle(fontSize: 16, color: Colors.white))),
            ),
          ],
        ),
      ]),
    );
  }
}
