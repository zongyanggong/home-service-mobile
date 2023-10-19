import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user/services/getAddress.dart';
import 'package:user/services/http_request.dart';
import 'package:user/services/info_state.dart';
import 'package:user/share/account_card.dart';
import 'package:user/share/account_input.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/input_field.dart';
import 'package:provider/provider.dart';
import '../services/firestore.dart';
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
  final addressController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();
  var info;
  List<String> autoCompleted = [];
  final ImagePicker _picker = ImagePicker();
File? _selectedImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = Provider.of<Info>(context, listen: false);
    addressController.text = info.currentUser.address!;
    telephoneController.text = info.currentUser.phone!;
    emailController.text = info.currentUser.email!;
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
                  imgPath: info.currentUser.imgPath!,
                  imageWidget: _selectedImage == null
                      ? NetworkImage(info.currentUser.imgPath!)
                      : FileImage(_selectedImage!) as ImageProvider,
                  // imageWidget: NetworkImage(info.currentUser.imgPath!),
                  isEdit: true,
                  onTakePicture: () {
                    // takePhoto(ImageSource.camera);
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
                      title: "Address",
                      hint: "Please input your address",
                      controller: addressController,
                      onSubmitted: (value) {
                        setState(() {
                          autoCompleted = [];
                        });
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          getAddressFromCanadapost(value).then((value) {
                            autoCompleted = [];
                            value.forEach((dynamic item) {
                              Map<String, dynamic> mapItem =
                                  item as Map<String, dynamic>;
                              setState(() {
                                autoCompleted.add(
                                    "${mapItem["Text"]},${mapItem["Description"]}");
                              });
                              debugPrint(
                                  "${mapItem["Text"]},${mapItem["Description"]}");
                            });
                          });
                        } else {
                          //clear out the result
                          setState(() {
                            autoCompleted = [];
                          });
                        }
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: autoCompleted.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(autoCompleted[index]),
                          onTap: () {
                            setState(() {
                              addressController.text = autoCompleted[index];
                              autoCompleted = [];
                            });
                          },
                        );
                      },
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
                    info.currentUser.address = addressController.text,
                    info.currentUser.phone = telephoneController.text,
                    info.currentUser.email = emailController.text,
                    //add upload image

                    // Update user in firestore
                    _firestoreService.updateUserById(info.currentUser),
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

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(returnedImage==null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

}
