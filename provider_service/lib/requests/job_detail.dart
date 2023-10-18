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
import '../services/models.dart' as model;

class JobDetail extends StatefulWidget {
  JobDetail(
      {super.key,
      required this.selectedIndex,
      required this.list,
      required this.jobIndex});
  final int selectedIndex;
  final Map<String, dynamic>? list;
  final int jobIndex;

  @override
  State<JobDetail> createState() => _JobDetailState(
      selectedIndex: selectedIndex, list: list, jobIndex: jobIndex);
}

class _JobDetailState extends State<JobDetail> {
  _JobDetailState(
      {required this.selectedIndex,
      required this.list,
      required this.jobIndex});
  final int selectedIndex;
  final Map<String, dynamic>? list;
  final int jobIndex;

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);
    model.User user;
    model.Service service;
    model.ServiceRecord serviceRecord;

    getServiceRecord() {
      switch (selectedIndex) {
        case 1:
          return list!['completedRecords'][jobIndex];
        case 2:
          return list!['canceledRecords'][jobIndex];

        default:
          return list!['upcomingRecords'][jobIndex];
      }
    }

    //get info for rendering
    if (list == null) {
      return const Text("No requests");
    } else {
      serviceRecord = getServiceRecord();

      user =
          list!['serviceUsers'].firstWhere((e) => e.uid == serviceRecord.uid);

      service = list!['services'].firstWhere((e) => e.sid == serviceRecord.sid);
    }

    getFormatTime(int time1) {
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time1))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time1).hour, minute: DateTime.fromMillisecondsSinceEpoch(time1).minute))}";
    }

    getTimeByStatus() {
      var statusStr = serviceRecord.status
          .toString()
          .split('.')
          .last
          .toString()
          .split('.')
          .last;
      switch (statusStr) {
        case "pending":
          return getFormatTime(serviceRecord.createdTime);
        case "confirmed":
          return getFormatTime(serviceRecord.acceptedTime);
        case "started":
          return getFormatTime(serviceRecord.actualStartTime);
        case "completed":
          return getFormatTime(serviceRecord.actualEndTime);

        case "canceled":
          return getFormatTime(serviceRecord.actualEndTime);
        case "rejected":
          return getFormatTime(serviceRecord.actualEndTime);
        default:
          return "";
      }
    }

    getTimePeriod() {
      // "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).minute))}";
      return "";
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: "Job Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        image: NetworkImage(user.imgPath!),
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
                            user.name!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: LabelField(
                                      title: "Job", hint: service.name)),
                              Expanded(
                                  child: LabelField(
                                      title: "Job fees",
                                      hint:
                                          "CAD \$ ${serviceRecord.price} /hour")),
                            ],
                          ),
                          LabelField(
                            title: "Booking for",
                            hint:
                                "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).minute))}",
                          ),
                          LabelField(title: "Address", hint: user.address!),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: serviceRecord.status
                          .toString()
                          .split('.')
                          .last
                          .toString()
                          .split('.')
                          .last ==
                      "pending"
                  ? PendingButton(
                      serviceRecord: serviceRecord,
                      onCancelJob: () {
                        // setState(() {
                        //   serviceRecord.status.toString().split('.').last.toString().split('.').last = "rejected";
                        //   serviceRecord.actualEndTime = DateTime.now();
                        // });
                      },
                      onAcceptJob: () {
                        // setState(() {
                        //   serviceRecord.status.toString().split('.').last.toString().split('.').last = "confirmed";
                        //   serviceRecord.acceptedTime = DateTime.now();
                        // });
                      },
                    )
                  : serviceRecord.status
                                  .toString()
                                  .split('.')
                                  .last
                                  .toString()
                                  .split('.')
                                  .last ==
                              "confirmed" ||
                          serviceRecord.status
                                  .toString()
                                  .split('.')
                                  .last
                                  .toString()
                                  .split('.')
                                  .last ==
                              "started"
                      ? JobDetailButton(
                          serviceRecord: serviceRecord,
                          onButtonClick: () {
                            if (serviceRecord.status
                                    .toString()
                                    .split('.')
                                    .last
                                    .toString()
                                    .split('.')
                                    .last ==
                                "confirmed") {
                              // setState(() {
                              //   serviceRecord.status.toString().split('.').last
                              //       .toString()
                              //       .split('.')
                              //       .last = "started";
                              //   serviceRecord.actualStartTime = DateTime.now();
                              // });
                            } else if (serviceRecord.status
                                    .toString()
                                    .split('.')
                                    .last
                                    .toString()
                                    .split('.')
                                    .last ==
                                "started") {
                              // setState(() {
                              //   serviceRecord.status.toString().split('.').last
                              //       .toString()
                              //       .split('.')
                              //       .last = "completed";
                              //   serviceRecord.actualEndTime = DateTime.now();
                              // });
                            } else {}
                          },
                        )
                      : null,
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
                    subTitle: serviceRecord.createdTime != 0
                        ? "Job created on ${getFormatTime(serviceRecord.createdTime)} "
                        : "",
                    active: serviceRecord.status.toString().split('.').last ==
                        "pending",
                  ),
                  if (serviceRecord.status
                          .toString()
                          .split('.')
                          .last
                          .toString()
                          .split('.')
                          .last ==
                      "rejected") //job rejected by provider
                    JobStatus(
                      title: "Job Rejected",
                      subTitle: serviceRecord.actualEndTime != 0
                          ? "Job rejected on ${getFormatTime(serviceRecord.actualEndTime)}"
                          : "",
                      active: serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last ==
                          "rejected",
                    ),
                  if (serviceRecord.status
                          .toString()
                          .split('.')
                          .last
                          .toString()
                          .split('.')
                          .last ==
                      "canceled") //job canceled by user
                    JobStatus(
                      title: "Job Canceled",
                      subTitle: serviceRecord.actualEndTime != 0
                          ? "Job canceled on ${getFormatTime(serviceRecord.actualEndTime)} }"
                          : "",
                      active: serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last ==
                          "canceled",
                    ),
                  if (serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last !=
                          "canceled" &&
                      serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last !=
                          "rejected")
                    JobStatus(
                      title: "Job Accepted",
                      subTitle: serviceRecord.acceptedTime != 0
                          ? "Job accepted on ${getFormatTime(serviceRecord.acceptedTime)}"
                          : "",
                      active: serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last !=
                          "confirmed",
                    ),
                  if (serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last !=
                          "canceled" &&
                      serviceRecord.status
                              .toString()
                              .split('.')
                              .last
                              .toString()
                              .split('.')
                              .last !=
                          "rejected")
                    JobStatus(
                      title: "Job In Process",
                      subTitle: serviceRecord.actualStartTime != 0
                          ? "Job started on ${getFormatTime(serviceRecord.actualStartTime)}"
                          : "",
                      active: serviceRecord.status.toString().split('.').last ==
                          "started",
                    ),
                  if (serviceRecord.status.toString().split('.').last !=
                          "canceled" &&
                      serviceRecord.status.toString().split('.').last !=
                          "rejected")
                    JobStatus(
                      title: "Job Completed",
                      subTitle: serviceRecord.actualEndTime != 0
                          ? "Job started on ${getFormatTime(serviceRecord.actualEndTime)}"
                          : "",
                      active: serviceRecord.status.toString().split('.').last ==
                          "completed",
                    ),
                ],
              ),
            ),
            if (serviceRecord.score > 0 &&
                serviceRecord.status.toString().split('.').last == "completed")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rating",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 9),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              serviceRecord.score!.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0;
                                  i < serviceRecord.score!.floor();
                                  i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.green,
                                  size: 15,
                                ),
                              for (int i = serviceRecord.score!.floor();
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
            if (serviceRecord.review != "" &&
                serviceRecord.status.toString().split('.').last == "completed")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Review",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 9),
                      child: Text(serviceRecord.review!),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class JobDetailButton extends StatelessWidget {
  JobDetailButton({super.key, required this.serviceRecord, this.onButtonClick});

  model.ServiceRecord serviceRecord;
  final VoidCallback? onButtonClick;

  @override
  Widget build(BuildContext context) {
    debugPrint(serviceRecord.status.toString().split('.').last.toString());
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        onPressed: onButtonClick ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(serviceRecord.status.toString().split('.').last == "confirmed"
                ? Icons.build
                : serviceRecord.status.toString().split('.').last == "started"
                    ? Icons.thumb_up
                    : null),
            const SizedBox(
              width: 10,
            ),
            Text(
                serviceRecord.status.toString().split('.').last == "confirmed"
                    ? "Start Job"
                    : serviceRecord.status.toString().split('.').last ==
                            "started"
                        ? "Mark Job Complete"
                        : "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ));
  }
}

class PendingButton extends StatelessWidget {
  PendingButton(
      {super.key,
      required this.serviceRecord,
      this.onCancelJob,
      this.onAcceptJob});
  model.ServiceRecord serviceRecord;
  final VoidCallback? onCancelJob;
  final VoidCallback? onAcceptJob;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: onCancelJob ?? () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Cancel Job"),
                  ],
                ))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: onAcceptJob ?? () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Accept Job"),
                  ],
                ))),
      ],
    );
  }
}
