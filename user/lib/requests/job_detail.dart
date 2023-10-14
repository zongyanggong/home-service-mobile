import 'package:flutter/material.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';

class JobDetail extends StatefulWidget {
  JobDetail({super.key,required this.serviceRecord});
  TempServiceRecord serviceRecord;

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: "Job Detail"),
      ),
      body: Text(widget.serviceRecord.name),
    );
  }
}
