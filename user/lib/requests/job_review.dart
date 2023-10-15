import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/info_state.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/job_status.dart';
import 'package:user/share/label_field.dart';
import 'package:provider/provider.dart';

class JobViewScreen extends StatefulWidget {
  JobViewScreen({super.key, required this.serviceRecord});
  TempServiceRecord serviceRecord;

  @override
  State<JobViewScreen> createState() => _JobViewScreenState();
}

class _JobViewScreenState extends State<JobViewScreen> {
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: "Review now"),
      ),
      body: Text("Job review"),
    );
  }
}
