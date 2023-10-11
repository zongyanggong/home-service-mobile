import 'package:flutter/material.dart';
import 'package:user/services/user.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/account_input.dart';
import 'package:user/share/appBarTitle.dart';

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
                  onViewProfile: () {},
                  onTakePicture: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 9),
                child: AccountInput(
                    iconData: Icons.location_on,
                    hintText: "Address",
                    controller: _addressController,
                    onChange: (value) {
                      currentUser.address=value;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 9),
                child: AccountInput(
                    iconData: Icons.phone,
                    hintText: "Telephone",
                    controller: _telephoneController,
                    onChange: (value) {
                      currentUser.phone=value;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 9),
                child: AccountInput(
                    iconData: Icons.email,
                    hintText: "Email",
                    controller: _emailController,
                    onChange: (value) {
                      currentUser.email=value;
                    }),
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
