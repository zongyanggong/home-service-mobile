import 'package:flutter/material.dart';
import 'package:user/services/info_state.dart';
import 'package:user/services/user_provider.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/account_input.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/input_field.dart';
import 'package:provider/provider.dart';
import '../services/firestore.dart';

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

class BodyContent extends StatelessWidget {
  const BodyContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    TextEditingController addressController = TextEditingController();
    addressController.text = info.currentUser!.address!;
    TextEditingController telephoneController = TextEditingController();
    telephoneController.text = info.currentUser!.phone!;
    TextEditingController emailController = TextEditingController();
    emailController.text = info.currentUser!.email!;
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
                      title: "Address",
                      hint: "Please input your address",
                      controller: addressController,
                    ),
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
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () => {
                    info.currentUser?.address = addressController.text,
                    info.currentUser?.phone = telephoneController.text,
                    info.currentUser?.email = emailController.text,

                    // Update user in firestore
                    _firestoreService.updateUserById(info.currentUser!),
                    Navigator.pop(context),
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
