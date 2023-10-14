import 'package:flutter/material.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';
import '../services/models.dart';

class JobDetail extends StatefulWidget {
  JobDetail({super.key, required this.serviceRecord});
  ServiceRecord serviceRecord;

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
      body: Text("Record name"),
      //Text(widget.serviceRecord.name),
    );
  }
}
