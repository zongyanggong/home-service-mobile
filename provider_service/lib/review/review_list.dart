import 'package:flutter/material.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/request_completed_card.dart';
import 'package:user/share/review_card.dart';

class ReviewListScreen extends StatelessWidget {
  ReviewListScreen({super.key});

  final List<TempServiceRecord> tempServiceRecords = [
    TempServiceRecord()
      ..pid = 1
      ..rid = 1
      ..sid = 1
      ..name = "User 1"
      ..imgPath = 'assets/images/face1.jpg'
       ..score = 4.6
      ..review="very nice"
      ..status = RecordStatus.completed
      ..actualDate = DateTime.now()
      ..actualStartTime = DateTime.now()
      ..actualEndTime = DateTime.now().add(const Duration(hours: 1)),
    TempServiceRecord()
      ..pid = 2
      ..rid = 2
      ..sid = 3
      ..name = 'User 2'
      ..imgPath = 'assets/images/face2.jpg'
      ..price = 60
      ..score = 3.5
      ..review="Good service"
      ..status = RecordStatus.completed
      ..actualDate = DateTime.now()
      ..actualStartTime = DateTime.now().add(const Duration(hours: 3))
      ..actualEndTime = DateTime.now().add(const Duration(hours: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title: "Reviews",),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 9),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: tempServiceRecords.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: ReviewCard(
                  tempServiceRecord: tempServiceRecords[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
