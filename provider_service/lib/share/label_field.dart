import 'package:flutter/material.dart';

class LabelField extends StatelessWidget {
  final String title;
  final String hint;

  const LabelField(
      {super.key,
      required this.title,
      required this.hint,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              hint,
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
