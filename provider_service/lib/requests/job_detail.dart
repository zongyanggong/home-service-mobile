import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/info_state.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/job_status.dart';
import 'package:user/share/label_field.dart';
import 'package:provider/provider.dart';
import '../services/models.dart' as model;
import '../services/firestore.dart';
import 'package:user/services/record_status.dart';

final FirestoreService _firestoreService = FirestoreService();

class JobDetail extends StatefulWidget {
  JobDetail({super.key, required this.selectedIndex, required this.jobIndex});
  final int selectedIndex;
  final int jobIndex;

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  _JobDetailState();
  late int selectedIndex;
  late int jobIndex;
  model.User? user;
  model.Service? service;
  model.ServiceRecord? serviceRecord;
  late var status;
  int? cancelTime;
  int? acceptedTime;
  int? startedTime;
  int? completedTime;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    var info = Provider.of<Info>(context, listen: false);
    selectedIndex = widget.selectedIndex;
    jobIndex = widget.jobIndex;

    serviceRecord = await _loadServiceRecord(info, selectedIndex, jobIndex);
    user = await _loadUser(serviceRecord);
    service = await _loadService(serviceRecord);
    status = serviceRecord?.status.toString().split('.').last;

    // Ensure the widget is rebuilt after data is loaded.
    if (mounted) {
      setState(() {});
    }
  }

  Future<model.Service> _loadService(serviceRecord) async {
    //Get all services
    List<model.Service> services = await _firestoreService.getService();
    //Get current record's service
    return services.firstWhere((e) => e.sid == serviceRecord.sid);
  }

  Future<model.User> _loadUser(serviceRecord) async {
    //Get all providers
    List<model.User> users = await _firestoreService.getUser();
    //Get current record's provider
    return users.firstWhere((e) => e.uid == serviceRecord.uid);
  }

  Future<model.ServiceRecord> _loadServiceRecord(
      info, selectedIndex, jobIndex) async {
    //Get all service records
    List<model.ServiceRecord> serviceRecords =
        await _firestoreService.getServiceRecord();
    //Get current user's service records
    serviceRecords =
        serviceRecords.where((e) => e.pid == info.currentUser.pid).toList();
    //Get service based on selectedIndex, which belongs to each tabs' records
    switch (selectedIndex) {
      case 1:
        serviceRecords = serviceRecords
            .where((e) =>
                e.status.toString().split('.').last == "completed" ||
                e.status.toString().split('.').last == "reviewed")
            .toList();
      case 2:
        serviceRecords = serviceRecords
            .where((e) =>
                e.status.toString().split('.').last == "rejected" ||
                e.status.toString().split('.').last == "cancelled")
            .toList();
      default:
        serviceRecords = serviceRecords
            .where((e) =>
                e.status.toString().split('.').last == "pending" ||
                e.status.toString().split('.').last == "confirmed" ||
                e.status.toString().split('.').last == "started")
            .toList();
    }
    return serviceRecords[jobIndex];
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    //Wait for data to be loaded
    if (serviceRecord == null ||
        user == null ||
        service == null ||
        status == null) {
      return const CircularProgressIndicator(); // or any other loading indicator
    }

    getFormatTime(int time1) {
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time1))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time1).hour, minute: DateTime.fromMillisecondsSinceEpoch(time1).minute))}";
    }

    getTimeByStatus(item) {
      switch (item) {
        case "pending":
          return "Job created at ${getFormatTime(serviceRecord?.createdTime ?? 0)}";
        case "confirmed":
          if (status == "completed" ||
              status == "confirmed" ||
              status == "started" ||
              status == "reviewed") {
            return "Job accepted at ${acceptedTime == null ? getFormatTime(serviceRecord?.acceptedTime ?? 0) : getFormatTime(acceptedTime!)}";
          } else {
            return "";
          }
        case "started":
          if (status == "completed" ||
              status == "started" ||
              status == "reviewed") {
            return "Job started at ${startedTime == null ? getFormatTime(serviceRecord?.actualStartTime ?? 0) : getFormatTime(startedTime!)}";
          } else {
            return "";
          }
        case "completed":
          if (status == "completed" || status == "reviewed") {
            return "Job completed at ${completedTime == null ? getFormatTime(serviceRecord?.actualEndTime ?? 0) : getFormatTime(completedTime!)}}";
          } else {
            return "";
          }
        case "cancelled":
          return "Job cancelled at ${getFormatTime(cancelTime ?? serviceRecord?.actualEndTime ?? 0)}";
        case "rejected":
          return "Job rejected at ${getFormatTime(serviceRecord?.actualEndTime ?? 0)}";
        default:
          return "";
      }
    }

    getTimePeriod() {
      return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord?.bookingStartTime ?? 0))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord?.bookingStartTime ?? 0).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord?.bookingStartTime ?? 0).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord?.bookingEndTime ?? 0).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord?.bookingEndTime ?? 0).minute))}";
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
                        image: NetworkImage(user?.imgPath ?? ""),
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
                            user?.name ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: LabelField(
                                      title: "Job", hint: service?.name ?? "")),
                              Expanded(
                                  child: LabelField(
                                      title: "Job fees",
                                      hint:
                                          "CAD \$ ${serviceRecord?.price} /hour")),
                            ],
                          ),
                          LabelField(
                            title: "Booking for",
                            hint: getTimePeriod(),
                          ),
                          LabelField(
                              title: "Address",
                              hint: user?.address?.toString() ?? ""),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: status == "pending"
                  ? PendingButton(
                      serviceRecord: serviceRecord!,
                      onCancelJob: () {
                        setState(() {
                          //to do: update status
                          status = "cancelled";
                          cancelTime = DateTime.now().millisecondsSinceEpoch;
                        });

                        //Save to firestore
                        final updatedServiceRecord = model.ServiceRecord(
                          rid: serviceRecord!.rid,
                          uid: serviceRecord!.uid,
                          pid: serviceRecord!.pid,
                          sid: serviceRecord!.sid,
                          bookingStartTime: serviceRecord!.bookingStartTime,
                          bookingEndTime: serviceRecord!.bookingEndTime,
                          createdTime: serviceRecord!.createdTime,
                          acceptedTime: serviceRecord!.acceptedTime,
                          actualStartTime: serviceRecord!.actualStartTime,
                          actualEndTime: cancelTime!,
                          status: RecordStatus.cancelled,
                          score: serviceRecord!.score,
                          review: serviceRecord!.review,
                          price: serviceRecord!.price,
                          appointmentNotes: serviceRecord!.appointmentNotes,
                        );

                        // Now, update the ServiceRecord
                        try {
                          _firestoreService
                              .updateServiceRecordById(updatedServiceRecord);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      onAcceptJob: () {
                        setState(() {
                          //to do: update status
                          status = "confirmed";
                          acceptedTime = DateTime.now().millisecondsSinceEpoch;
                        });

                        //Save to firestore
                        final updatedServiceRecord = model.ServiceRecord(
                          rid: serviceRecord!.rid,
                          uid: serviceRecord!.uid,
                          pid: serviceRecord!.pid,
                          sid: serviceRecord!.sid,
                          bookingStartTime: serviceRecord!.bookingStartTime,
                          bookingEndTime: serviceRecord!.bookingEndTime,
                          createdTime: serviceRecord!.createdTime,
                          acceptedTime: acceptedTime!,
                          actualStartTime: serviceRecord!.actualStartTime,
                          actualEndTime: serviceRecord!.actualEndTime,
                          status: RecordStatus.confirmed,
                          score: serviceRecord!.score,
                          review: serviceRecord!.review,
                          price: serviceRecord!.price,
                          appointmentNotes: serviceRecord!.appointmentNotes,
                        );

                        // Now, update the ServiceRecord
                        try {
                          _firestoreService
                              .updateServiceRecordById(updatedServiceRecord);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    )
                  : status == "confirmed" || status == "started"
                      ? JobDetailButton(
                          serviceRecord: serviceRecord!,
                          status: status,
                          onButtonClick: () {
                            if (status == "confirmed") {
                              setState(() {
                                status = "started";
                                startedTime =
                                    DateTime.now().millisecondsSinceEpoch;
                              });

                              //Save to firestore
                              final updatedServiceRecord = model.ServiceRecord(
                                rid: serviceRecord!.rid,
                                uid: serviceRecord!.uid,
                                pid: serviceRecord!.pid,
                                sid: serviceRecord!.sid,
                                bookingStartTime:
                                    serviceRecord!.bookingStartTime,
                                bookingEndTime: serviceRecord!.bookingEndTime,
                                createdTime: serviceRecord!.createdTime,
                                acceptedTime: acceptedTime!,
                                actualStartTime: startedTime!,
                                actualEndTime: serviceRecord!.actualEndTime,
                                status: RecordStatus.started,
                                score: serviceRecord!.score,
                                review: serviceRecord!.review,
                                price: serviceRecord!.price,
                                appointmentNotes:
                                    serviceRecord!.appointmentNotes,
                              );

                              // Now, update the ServiceRecord
                              try {
                                _firestoreService.updateServiceRecordById(
                                    updatedServiceRecord);
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            } else if (status == "started") {
                              setState(() {
                                status = "completed";
                                completedTime =
                                    DateTime.now().millisecondsSinceEpoch;
                              });

                              //Save to firestore
                              final updatedServiceRecord = model.ServiceRecord(
                                rid: serviceRecord!.rid,
                                uid: serviceRecord!.uid,
                                pid: serviceRecord!.pid,
                                sid: serviceRecord!.sid,
                                bookingStartTime:
                                    serviceRecord!.bookingStartTime,
                                bookingEndTime: serviceRecord!.bookingEndTime,
                                createdTime: serviceRecord!.createdTime,
                                acceptedTime: acceptedTime!,
                                actualStartTime: startedTime!,
                                actualEndTime: completedTime!,
                                status: RecordStatus.completed,
                                score: serviceRecord!.score,
                                review: serviceRecord!.review,
                                price: serviceRecord!.price,
                                appointmentNotes:
                                    serviceRecord!.appointmentNotes,
                              );

                              // Now, update the ServiceRecord
                              try {
                                _firestoreService.updateServiceRecordById(
                                    updatedServiceRecord);
                              } catch (e) {
                                debugPrint(e.toString());
                              }
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
                    subTitle: getTimeByStatus("pending"),
                    active: status == "pending",
                  ),
                  // if (serviceRecord.status.toString().split('.').last ==
                  //     "rejected") //job rejected by provider
                  Visibility(
                    visible: status == "rejected",
                    child: JobStatus(
                      title: "Job Rejected",
                      subTitle: getTimeByStatus("rejected"),
                      active: true,
                    ),
                  ),
                  // if (serviceRecord.status.toString().split('.').last ==
                  //     "cancelled") //job cancelled by user
                  Visibility(
                    visible: status == "cancelled",
                    child: JobStatus(
                      title: "Job cancelled",
                      subTitle: getTimeByStatus("cancelled"),
                      active: true,
                    ),
                  ),
                  // if (serviceRecord.status.toString().split('.').last !=
                  //         "cancelled" &&
                  //     serviceRecord.status.toString().split('.').last !=
                  //         "rejected")
                  Visibility(
                    visible: status != "cancelled" && status != "rejected",
                    child: JobStatus(
                      title: "Job Accepted",
                      subTitle: getTimeByStatus("confirmed"),
                      active: status == "confirmed",
                    ),
                  ),
                  // if (serviceRecord.status.toString().split('.').last !=
                  //         "cancelled" &&
                  //     serviceRecord.status.toString().split('.').last !=
                  //         "rejected")
                  Visibility(
                    visible: status != "cancelled" && status != "rejected",
                    child: JobStatus(
                      title: "Job In Process",
                      subTitle: getTimeByStatus("started"),
                      active: status == "started",
                    ),
                  ),
                  // if (serviceRecord.status.toString().split('.').last !=
                  //         "cancelled" &&
                  //     serviceRecord.status.toString().split('.').last !=
                  //         "rejected")
                  Visibility(
                    visible: status != "cancelled" && status != "rejected",
                    child: JobStatus(
                      title: "Job Completed",
                      subTitle: getTimeByStatus("completed"),
                      active: status == "completed",
                    ),
                  ),
                ],
              ),
            ),
            // if (serviceRecord?.score != null &&
            //     serviceRecord?.status.toString().split('.').last == "completed")
            Visibility(
              visible: serviceRecord?.status.toString().split('.').last ==
                  "reviewed",
              child: Padding(
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
                              serviceRecord?.score.toStringAsFixed(2) ?? "",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0;
                                  i < (serviceRecord?.score.floor() ?? 0);
                                  i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.green,
                                  size: 15,
                                ),
                              for (int i = (serviceRecord?.score.floor() ?? 0);
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
            ),
            // if (serviceRecord?.review != "" &&
            //     serviceRecord?.status.toString().split('.').last == "completed")
            Visibility(
              visible: serviceRecord?.status.toString().split('.').last ==
                  "reviewed",
              child: Padding(
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
                      child: Text(serviceRecord?.review ?? ""),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JobDetailButton extends StatelessWidget {
  JobDetailButton(
      {super.key,
      required this.serviceRecord,
      this.status,
      this.onButtonClick});

  model.ServiceRecord serviceRecord;
  final VoidCallback? onButtonClick;
  final String? status;

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
            Icon(status == "confirmed"
                ? Icons.build
                : status == "started"
                    ? Icons.thumb_up
                    : null),
            const SizedBox(
              width: 10,
            ),
            Text(
                status == "confirmed"
                    ? "Start Job"
                    : status == "started"
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
