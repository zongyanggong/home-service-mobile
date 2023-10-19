import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/info_state.dart';
import 'package:user/services/record_status.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/job_status.dart';
import 'package:user/share/label_field.dart';
import 'package:provider/provider.dart';
import '../services/models.dart' as model;
import '../services/firestore.dart';

final FirestoreService _firestoreService = FirestoreService();

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
  // ignore: library_private_types_in_public_api
  _JobDetail createState() =>
      _JobDetail(selectedIndex: selectedIndex, list: list, jobIndex: jobIndex);
}

class _JobDetail extends State<JobDetail> {
  _JobDetail(
      {required this.selectedIndex, required this.list, required this.jobIndex})
      : provider = model.Provider(),
        service = model.Service(), // Initialize service
        serviceRecord = model.ServiceRecord();

  final int selectedIndex;
  final Map<String, dynamic>? list;
  final int jobIndex;

  model.Provider provider;
  model.Service service;
  model.ServiceRecord serviceRecord;
  var status;

  @override
  void initState() {
    super.initState();
    //get info for rendering
    if (list == null) {
      // return const Text("No requests");
    } else {
      serviceRecord = getServiceRecord();

      provider = list!['serviceProviders']
          .firstWhere((e) => e.pid == serviceRecord.pid);

      service = list!['services'].firstWhere((e) => e.sid == serviceRecord.sid);
      status = serviceRecord.status.toString().split('.').last;
    }
  }

  bool isCanceled = false;

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

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    getFormatTime(int time1) {
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time1))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time1).hour, minute: DateTime.fromMillisecondsSinceEpoch(time1).minute))}";
    }

    getTimeByStatus() {
      var statusStr = serviceRecord.status.toString().split('.').last;
      switch (statusStr) {
        case "pending":
          return getFormatTime(serviceRecord.createdTime);
        case "confirmed":
          return getFormatTime(serviceRecord.acceptedTime);
          ;
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
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).minute))}";
    }

    TextEditingController jobCreatedSubTitle = TextEditingController();
    jobCreatedSubTitle.text = serviceRecord.createdTime != 0
        ? getFormatTime(serviceRecord.createdTime)
        : "";

    cancelServiceRecord() {
      setState(() {
        isCanceled = true;
        status = "canceled";
      });
      print(status);

      // if (serviceRecord.status.toString().split('.').last == "pending") {
      //   // serviceRecord.status = RecordStatus.canceled;
      //   return () {
      //   //   _firestoreService.updateServiceRecordById(
      //   //       serviceRecord.sid,
      //   //       serviceRecord.pid,
      //   //       serviceRecord.uid,
      //   //       serviceRecord.bookingStartTime,
      //   //       serviceRecord.bookingEndTime,
      //   //       serviceRecord.createdTime,
      //   //       serviceRecord.acceptedTime,
      //   //       serviceRecord.actualStartTime,
      //   //       serviceRecord.actualEndTime,
      //   //       serviceRecord.status,
      //   //       serviceRecord.score,
      //   //       serviceRecord.review,
      //   //       RecordStatus.canceled);
      //   // };
      // } else {
      //   return null;
      // }
      // setState(() {});
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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
                          image: NetworkImage(provider.imgPath),
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
                              provider.name,
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
                                            "CAD \$ ${provider.price} /hour")),
                              ],
                            ),
                            LabelField(
                              title: "Booking for",
                              hint: getTimePeriod(),
                            ),
                            LabelField(
                                title: "Address",
                                hint: info.currentUser.address!),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (serviceRecord.status == RecordStatus.pending)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  status = "canceled";
                                });
                                print("canceld button pressed ${status}");
                              }, //cancelServiceRecord,
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              onPressed: () {}, //cancelServiceRecord(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Job Status",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                    JobStatus(
                      title: "Job Created ${status}",
                      subTitle:
                          "Job created on ${getFormatTime(serviceRecord.createdTime)}",
                      active: !isCanceled,
                    ),
                    if (serviceRecord.status ==
                        RecordStatus.rejected) //job rejected by provider
                      JobStatus(
                        title: "Job Rejected",
                        subTitle: serviceRecord.actualEndTime != 0
                            ? "Job rejected on ${getFormatTime(serviceRecord.actualEndTime)}"
                            : "",
                        active:
                            serviceRecord.status.toString().split('.').last ==
                                "rejected",
                      ),
                    //job canceled by user
                    Visibility(
                        visible: isCanceled,
                        child: JobStatus(
                          title: "Job Canceled",
                          subTitle: serviceRecord.actualEndTime != 0
                              ? "Job canceled on ${getFormatTime(serviceRecord.actualEndTime)}"
                              : "",
                          active: true,
                        )),
                    if (serviceRecord.status != RecordStatus.canceled &&
                        serviceRecord.status != RecordStatus.rejected)
                      JobStatus(
                        title: "Job Accepted",
                        subTitle: serviceRecord.acceptedTime != 0
                            ? "Job accepted on ${getFormatTime(serviceRecord.acceptedTime)}"
                            : "",
                        active:
                            serviceRecord.status.toString().split('.').last ==
                                "confirmed",
                      ),
                    if (serviceRecord.status != RecordStatus.canceled &&
                        serviceRecord.status != RecordStatus.rejected)
                      JobStatus(
                        title: "Job In Process",
                        subTitle: serviceRecord.actualStartTime != 0
                            ? "Job started on ${getFormatTime(serviceRecord.actualStartTime)}"
                            : "",
                        active:
                            serviceRecord.status.toString().split('.').last ==
                                "started",
                      ),
                    if (serviceRecord.status != RecordStatus.canceled &&
                        serviceRecord.status != RecordStatus.rejected)
                      JobStatus(
                        title: "Job Completed",
                        subTitle: serviceRecord.actualEndTime != 0
                            ? "Job completed on ${getFormatTime(serviceRecord.actualEndTime)}"
                            : "",
                        active:
                            serviceRecord.status.toString().split('.').last ==
                                "completed",
                      ),
                  ],
                ),
              ),
              if (serviceRecord.score != null &&
                  serviceRecord.status == RecordStatus.completed)
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            RatingBar.builder(
                                ignoreGestures: true,
                                initialRating: serviceRecord.score!,
                                maxRating: 5,
                                allowHalfRating: true,
                                itemSize: 16,
                                itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    ),
                                onRatingUpdate: (rating) {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (serviceRecord.review != null &&
                  serviceRecord.status == RecordStatus.completed)
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
              // if (serviceRecord.status == RecordStatus.completed &&
              //     serviceRecord.score == null)
              //   Center(
              //     child: SizedBox(
              //       width: MediaQuery.of(context).size.width / 2,
              //       child: ElevatedButton(
              //         onPressed: () => {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) =>
              //                   JobViewScreen(serviceRecord: serviceRecord)))
              //         },
              //         child: const Text("Review now"),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ));
  }
}
