import 'package:flutter/material.dart';
import 'package:user/categories/provider_detail.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/category_card.dart';
import 'package:user/share/user_card.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

final FirestoreService _firestoreService = FirestoreService();

class ProviderList extends StatelessWidget {
  ProviderList({super.key, required this.sid, required this.title});

  String sid;
  String title;
  @override
  Widget build(BuildContext context) {
    getServiceProviders() async {
      List<model.Provider> list = await _firestoreService.getProvider();
      return list.where((element) => element.sid == sid).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: title //categories[sid],
            ),
      ),
      body: FutureBuilder<List<model.Provider>>(
          future: getServiceProviders(),
          builder: (BuildContext context,
              AsyncSnapshot<List<model.Provider>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Data is still loading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Data loading has encountered an error
              return Text('Error: ${snapshot.error}');
            } else {
              // Data has been loaded successfully
              final serviceProviders = snapshot.data;

              return serviceProviders!.isEmpty
                  ? const Text("No Provider")
                  : Padding(
                      padding: const EdgeInsets.only(top: 9),
                      child: ListView.builder(
                        itemCount: serviceProviders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            child: UserCard(
                              serviceProvider: serviceProviders[index],
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProviderDetailScreen(
                                        serviceProvider:
                                            serviceProviders[index])));
                              },
                            ),
                          );
                        },
                      ),
                    );
            }
          }),
    );
  }
}
