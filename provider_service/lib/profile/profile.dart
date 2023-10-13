import 'package:flutter/material.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/user.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/account_input.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/dropdown_field.dart';
import 'package:user/share/input_field.dart';

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
  int _cid = 1;

  @override
  Widget build(BuildContext context) {
    // var currentUser = Provider.of<CurrentUser>(context,listen: false);
    ServiceProvider serviceProvider = ServiceProvider();
    serviceProvider.name = "Mark";
    serviceProvider.imgPath = 'assets/images/face1.jpg';
    serviceProvider.phone = "123456789";
    serviceProvider.email = "test@gmail.com";
    serviceProvider.price = 200;

    TextEditingController _telephoneController = TextEditingController();
    _telephoneController.text = serviceProvider.phone;
    TextEditingController _emailController = TextEditingController();
    _emailController.text = serviceProvider.email;
    TextEditingController _priceController = TextEditingController();
    _priceController.text = serviceProvider.price.toString();

    return ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: AccountCard(
                  name: serviceProvider.name,
                  imgPath: serviceProvider.imgPath,
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
                      controller: _telephoneController,
                    ),
                    InputField(
                      title: "Email",
                      hint: "Please input your email",
                      controller: _emailController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownField(
                            title: "Category",
                            array: categories,
                            index: _cid,
                            onValueChanged: (value) {
                              setState(() {
                                debugPrint("$value");
                                _cid = value;
                                debugPrint("$_cid");
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
                            controller: _priceController,
                          ),
                        ),
                      ],
                    ),
                    const InputField(
                      title: "About",
                      hint: "Experience",
                      maxLines: 5,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {},
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
