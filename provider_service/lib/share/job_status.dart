import 'package:flutter/material.dart';

class JobStatus extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool active;

  const JobStatus(
      {super.key,
      required this.title,
      required this.subTitle,
      this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 9,left: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(Icons.label_important,color: active?Colors.green:Colors.grey,),
              ),
              Container(
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              height: 60,
              decoration: active? BoxDecoration(
                color: Colors.blueGrey[50], // Background color
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ):null,
              padding: const EdgeInsets.only(left: 12,top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      subTitle,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
