import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  // ignore: library_private_types_in_public_api
  _JobDetail createState() =>
      _JobDetail(selectedIndex: selectedIndex, list: list, jobIndex: jobIndex);
}

class _JobDetail extends State<JobDetail> {
  _JobDetail(
      {required this.selectedIndex,
      required this.list,
      required this.jobIndex});
  final int selectedIndex;
  final Map<String, dynamic>? list;
  final int jobIndex;

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);
    model.Provider provider;
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

      provider = list!['serviceProviders']
          .firstWhere((e) => e.pid == serviceRecord.pid);

      service = list!['services'].firstWhere((e) => e.sid == serviceRecord.sid);
    }

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
      // "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).minute))}";
      return "";
    }

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
                                    hint: "CAD \$ ${provider.price} /hour")),
                          ],
                        ),
                        LabelField(
                          title: "Booking for",
                          hint: getTimePeriod(),
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
          if (serviceRecord.status == RecordStatus.pending)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            setState(() {
                              //to do: update status
                              var status = RecordStatus.canceled;
                              var actualEndTime = DateTime.now();
                            });
                          },
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
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () {},
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
                  title: "Job Created",
                  subTitle: serviceRecord.createdTime != 0
                      ? getFormatTime(serviceRecord.createdTime)
                      : "",
                  active: serviceRecord.status == RecordStatus.pending,
                ),
                if (serviceRecord.status ==
                    RecordStatus.rejected) //job rejected by provider
                  JobStatus(
                    title: "Job Rejected",
                    subTitle: serviceRecord.actualEndTime != 0
                        ? getFormatTime(serviceRecord.actualEndTime)
                        : "",
                    active: serviceRecord.status == RecordStatus.rejected,
                  ),
                if (serviceRecord.status ==
                    RecordStatus.canceled) //job canceled by user
                  JobStatus(
                    title: "Job Canceled",
                    subTitle: serviceRecord.actualEndTime != 0
                        ? getFormatTime(serviceRecord.actualEndTime)
                        : "",
                    active: serviceRecord.status == RecordStatus.canceled,
                  ),
                if (serviceRecord.status != RecordStatus.canceled &&
                    serviceRecord.status != RecordStatus.rejected)
                  JobStatus(
                    title: "Job Accepted",
                    subTitle: serviceRecord.acceptedTime != 0
                        ? getFormatTime(serviceRecord.acceptedTime)
                        : "",
                    active: serviceRecord.status == RecordStatus.confirmed,
                  ),
                if (serviceRecord.status != RecordStatus.canceled &&
                    serviceRecord.status != RecordStatus.rejected)
                  JobStatus(
                    title: "Job In Process",
                    subTitle: serviceRecord.actualStartTime != 0
                        ? getFormatTime(serviceRecord.actualStartTime)
                        : "",
                    active: serviceRecord.status == RecordStatus.started,
                  ),
                if (serviceRecord.status != RecordStatus.canceled &&
                    serviceRecord.status != RecordStatus.rejected)
                  JobStatus(
                    title: "Job Completed",
                    subTitle: serviceRecord.actualEndTime != 0
                        ? getFormatTime(serviceRecord.actualEndTime)
                        : "",
                    active: serviceRecord.status == RecordStatus.completed,
                  ),
              ],
            ),
          ),
          if (serviceRecord.score != null &&
              serviceRecord.status == RecordStatus.completed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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
    );
  }
}
