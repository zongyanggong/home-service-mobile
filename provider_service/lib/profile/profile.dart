import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/dropdown_field.dart';
import 'package:user/share/input_field.dart';
import 'package:provider/provider.dart' as provider;
import '../services/firestore.dart';
import '../services/info_state.dart';
import 'package:image_picker/image_picker.dart';

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
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();
  late List<String> categories;
  var info;
  List<String> autoCompleted = [];
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = provider.Provider.of<Info>(context, listen: false);
    categories = info.getService();
    telephoneController.text = info.currentUser.phone!;
    emailController.text = info.currentUser.email!;
    priceController.text = info.currentUser.price.toString();
    descController.text = info.currentUser.description!;
  }

  @override
  Widget build(BuildContext context) {
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
                  imageWidget: _selectedImage == null
                      ? NetworkImage(info.currentUser.imgPath!)
                      : FileImage(_selectedImage!) as ImageProvider,
                  isEdit: true,
                  onTakePicture: () {
                    _pickImageFromCamera();
                  },
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
                                info.currentUser.sid = value.toString();
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
//add upload image
                    if (_selectedImage != null)
                      {
                        //add upload image
                        _selectedImage = null
                      },
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

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
