import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/requests/job_review.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/info_state.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/job_status.dart';
import 'package:user/share/label_field.dart';
import 'package:provider/provider.dart';

class JobDetail extends StatefulWidget {
  JobDetail({super.key, required this.serviceRecord});
  TempServiceRecord serviceRecord;

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: "Job Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(widget.serviceRecord.imgPath),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceRecord.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: LabelField(
                                    title: "Job",
                                    hint:
                                        categories[widget.serviceRecord.sid])),
                            Expanded(
                                child: LabelField(
                                    title: "Job fees",
                                    hint:
                                        "CAD \$ ${widget.serviceRecord.price} /hour")),
                          ],
                        ),
                        LabelField(
                          title: "Booking for",
                          hint:
                              "${DateFormat.yMd().format(widget.serviceRecord.expectedDate)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.expectedStartTime.hour, minute: widget.serviceRecord.expectedStartTime.minute))}-${format24HourTime(TimeOfDay(hour: widget.serviceRecord.expectedEndTime.hour, minute: widget.serviceRecord.expectedEndTime.minute))}",
                        ),
                        LabelField(
                            title: "Address", hint: info.currentUser.address!),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (widget.serviceRecord.status != RecordStatus.completed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                widget.serviceRecord.status ==
                                        RecordStatus.pending
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                          onPressed: widget.serviceRecord.status ==
                                  RecordStatus.pending
                              ? () {}
                              : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Cancel"),
                            ],
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                widget.serviceRecord.status ==
                                        RecordStatus.pending
                                    ? Colors.green
                                    : Colors.grey),
                          ),
                          onPressed: widget.serviceRecord.status ==
                                  RecordStatus.pending
                              ? () {}
                              : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Reschedule"),
                            ],
                          ))),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Job Status",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600])),
                JobStatus(
                  title: "Job Pending",
                  subTitle: widget.serviceRecord.createTime != null
                      ? "Job created on ${DateFormat.yMd().format(widget.serviceRecord.createTime)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.createTime.hour, minute: widget.serviceRecord.createTime.minute))}"
                      : "",
                  active: widget.serviceRecord.status == RecordStatus.pending,
                ),
                JobStatus(
                  title: "Job Accepted",
                  subTitle: widget.serviceRecord.acceptedTime != null
                      ? "Job accepted on ${DateFormat.yMd().format(widget.serviceRecord.acceptedTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.acceptedTime!.hour, minute: widget.serviceRecord.acceptedTime!.minute))}"
                      : "",
                  active: widget.serviceRecord.status == RecordStatus.confirmed,
                ),
                JobStatus(
                  title: "Job In Process",
                  subTitle: widget.serviceRecord.actualStartTime != null
                      ? "Job started on ${DateFormat.yMd().format(widget.serviceRecord.actualStartTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.actualStartTime!.hour, minute: widget.serviceRecord.actualStartTime!.minute))}"
                      : "",
                  active: widget.serviceRecord.status == RecordStatus.started,
                ),
                JobStatus(
                  title: "Job Completed",
                  subTitle: widget.serviceRecord.actualEndTime != null
                      ? "Job started on ${DateFormat.yMd().format(widget.serviceRecord.actualEndTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.actualEndTime!.hour, minute: widget.serviceRecord.actualEndTime!.minute))}"
                      : "",
                  active: widget.serviceRecord.status == RecordStatus.completed,
                ),
              ],
            ),
          ),
          if (widget.serviceRecord.score != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rating",style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600])),
                  Padding(
                    padding: const EdgeInsets.only(left: 18,top: 9),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            widget.serviceRecord.score!.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0;
                                i < widget.serviceRecord.score!.floor();
                                i++)
                              const Icon(
                                Icons.star,
                                color: Colors.green,
                                size: 15,
                              ),
                            for (int i = widget.serviceRecord.score!.floor();
                                i < 5;
                                i++)
                              const Icon(
                                Icons.star_border,
                                color: Colors.green,
                                size: 15,
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.serviceRecord.review != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Review",style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600])),
                  Padding(
                    padding: const EdgeInsets.only(left: 18,top: 9),
                    child: Text(widget.serviceRecord.review!),
                  ),
                ],
              ),
            ),
          if (widget.serviceRecord.status == RecordStatus.completed &&
              widget.serviceRecord.score == null)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () => {Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => JobViewScreen(serviceRecord: widget.serviceRecord)))},
                  child: const Text("Review now"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
