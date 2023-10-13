import 'package:flutter/material.dart';

class AccountInput extends StatelessWidget {
  final IconData iconData;
  final TextEditingController controller;
  final ValueChanged<String> onChange;
  final String hintText;

  const AccountInput({super.key, required this.iconData, required this.hintText,required this.controller,required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.blue, // Blue color for the icon
        ),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText:hintText),
          onChanged: (value) => onChange(value),
        ),
      ),
    );
  }
}
