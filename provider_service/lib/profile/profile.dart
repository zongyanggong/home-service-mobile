import 'package:flutter/material.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/models.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/account_input.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/dropdown_field.dart';
import 'package:user/share/input_field.dart';
import 'package:provider/provider.dart' as provider;
import '../services/firestore.dart';
import '../services/info_state.dart';

final FirestoreService _firestoreService = FirestoreService();

class ProfileSceen extends StatelessWidget {
  const ProfileSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: "My Profile",
        ),
      ),
      body: const BodyContent(),
    );
  }
}

class BodyContent extends StatefulWidget {
  const BodyContent({
    super.key,
  });

  @override
  State<BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  @override
  Widget build(BuildContext context) {
    var info = provider.Provider.of<Info>(context, listen: false);

    List<String> categories = info.getService();

    TextEditingController telephoneController = TextEditingController();
    telephoneController.text = info.currentUser.phone!;
    TextEditingController emailController = TextEditingController();
    emailController.text = info.currentUser.email!;
    TextEditingController priceController = TextEditingController();
    priceController.text = info.currentUser.price.toString();
    TextEditingController descController = TextEditingController();
    descController.text = info.currentUser.description!;

    return ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: AccountCard(
                  name: info.currentUser.name!,
                  imgPath: info.currentUser.imgPath!,
                  isEdit: true,
                  onTakePicture: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50], // Background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Column(
                  children: [
                    InputField(
                      title: "Telephone",
                      hint: "Please input your telephone",
                      controller: telephoneController,
                    ),
                    InputField(
                      title: "Email",
                      hint: "Please input your email",
                      controller: emailController,
                    ),
                    Row(
                      children: [
                        //1. Fixed array from file
                        Expanded(
                          child: DropdownField(
                            title: "Category",
                            array: categories,
                            index: info.currentUser.sid!,
                            onValueChanged: (value) {
                              setState(() {
                                info.currentUser.sid = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: InputField(
                            title: "Charge /hour",
                            hint: "/hour",
                            controller: priceController,
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      title: "About",
                      hint: "Experience",
                      maxLines: 5,
                      controller: descController,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () => {
                    info.currentUser.price = double.parse(priceController.text),
                    info.currentUser.phone = telephoneController.text,
                    info.currentUser.email = emailController.text,
                    info.currentUser.description = descController.text,

                    // Update user in firestore
                    _firestoreService.updateProviderById(info.currentUser),
                  },
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}
