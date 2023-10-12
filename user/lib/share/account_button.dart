import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final IconData iconData;
  final String title;

  const AccountButton({super.key, required this.iconData, required this.title});

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
        title: Text(title),
      ),
    );
  }
}
