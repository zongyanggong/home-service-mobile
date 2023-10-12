import 'package:flutter/material.dart';
import 'package:user/services/user.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/account_input.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/input_field.dart';

class ProfileSceen extends StatelessWidget {
  const ProfileSceen({super.key});

  @override
  Widget build(BuildContext context) {
    // var currentUser = Provider.of<CurrentUser>(context,listen: false);
    CurrentUser currentUser = CurrentUser();
    currentUser.name = "Mark";
    currentUser.imgPath = 'assets/images/face1.jpg';
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
    // var currentUser = Provider.of<CurrentUser>(context,listen: false);

    CurrentUser currentUser = CurrentUser();
    currentUser.name = "Mark";
    currentUser.imgPath = 'assets/images/face1.jpg';
    currentUser.address = "vanier";
    currentUser.phone="123456789";
    currentUser.email="test@gmail.com";
    TextEditingController _addressController = TextEditingController();
    _addressController.text = currentUser.address;
    TextEditingController _telephoneController = TextEditingController();
    _telephoneController.text = currentUser.phone;
    TextEditingController _emailController = TextEditingController();
    _emailController.text = currentUser.email;
    return ListView(
      children: [Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: AccountCard(
                  name: currentUser.name,
                  imgPath: currentUser.imgPath,
                  isEdit: true,
                  onTakePicture: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18,right: 18,bottom: 18),
                padding: const EdgeInsets.only(left: 12,right: 12,bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50], // Background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Column(
                  children: [
                    InputField(
                      title: "Address",
                      hint: "Please input your address",
                      controller: _addressController,
                    ),
                    InputField(
                      title: "Telephone",
                      hint: "Please input your telephone",
                      controller: _telephoneController,
                    ),
                    InputField(
                      title: "Email",
                      hint: "Please input your email",
                      controller: _emailController,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ],
      ),]
    );
  }
}
