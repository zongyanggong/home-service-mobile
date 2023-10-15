import 'package:flutter/material.dart';

class ReviewField extends StatelessWidget {
  final int title;
  final String subTitle;
  final IconData iconData;

  const ReviewField(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Row(
        children: [
          Icon(iconData,color: Colors.green,size: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    subTitle,
                    style:  TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
