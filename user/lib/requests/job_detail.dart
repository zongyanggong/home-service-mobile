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
import 'job_review.dart';
import '../categories/provider_book.dart';

final FirestoreService _firestoreService = FirestoreService();

class JobDetail extends StatefulWidget {
  JobDetail(
      {super.key,
      required this.selectedIndex,
      // required this.list,
      required this.jobIndex});
  final int selectedIndex;
  // final Map<String, dynamic>? list;
  final int jobIndex;
  @override
  // ignore: library_private_types_in_public_api
  _JobDetail createState() => _JobDetail();
  // _JobDetail(selectedIndex: selectedIndex, list: list, jobIndex: jobIndex);
}

class _JobDetail extends State<JobDetail> {
  _JobDetail();

  late int selectedIndex;
  late int jobIndex;
  model.Provider? provider;
  model.Service? service;
  model.ServiceRecord? serviceRecord;
  late var status;
  int? cancelTime;

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
    provider = await _loadProvider(serviceRecord);
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

  Future<model.Provider> _loadProvider(serviceRecord) async {
    //Get all providers
    List<model.Provider> providers = await _firestoreService.getProvider();
    //Get current record's provider
    return providers.firstWhere((e) => e.pid == serviceRecord.pid);
  }

  Future<model.ServiceRecord> _loadServiceRecord(
      info, selectedIndex, jobIndex) async {
    //Get all service records
    List<model.ServiceRecord> serviceRecords =
        await _firestoreService.getServiceRecord();
    //Get current user's service records
    serviceRecords =
        serviceRecords.where((e) => e.uid == info.currentUser.uid).toList();
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
        provider == null ||
        service == null ||
        status == null) {
      return const CircularProgressIndicator(); // or any other loading indicator
    }

    getFormatTime(int time1) {
      if (time1 == 0) {
        return "";
      } else {
        return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(time1))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(time1).hour, minute: DateTime.fromMillisecondsSinceEpoch(time1).minute))}";
      }
    }

    getTimeByStatus(status) {
      //var statusStr = serviceRecord?.status.toString().split('.').last;
      switch (status) {
        case "pending":
          return "Job created at ${getFormatTime(serviceRecord?.createdTime ?? 0)}";
        case "confirmed":
          return "Job confirmed at ${getFormatTime(serviceRecord?.acceptedTime ?? 0)}";
        case "started":
          return "Job started at ${getFormatTime(serviceRecord?.actualStartTime ?? 0)}";
        case "completed":
          return "Job completed at ${getFormatTime(serviceRecord?.actualEndTime ?? 0)}";
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
                          image: NetworkImage(provider?.imgPath ?? ""),
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
                              provider?.name ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: LabelField(
                                        title: "Job",
                                        hint: service?.name ?? "")),
                                Expanded(
                                    child: LabelField(
                                        title: "Job fees",
                                        hint:
                                            "CAD \$ ${provider?.price} /hour")),
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
              // if (serviceRecord?.status == RecordStatus.pending)
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
                            onPressed: status == "pending"
                                ? () {
                                    setState(() {
                                      //to do: update status
                                      status = "cancelled";
                                      cancelTime =
                                          DateTime.now().millisecondsSinceEpoch;
                                    });

                                    //Save to firestore
                                    final updatedServiceRecord =
                                        model.ServiceRecord(
                                      rid: serviceRecord!.rid,
                                      uid: serviceRecord!.uid,
                                      pid: serviceRecord!.pid,
                                      sid: serviceRecord!.sid,
                                      bookingStartTime:
                                          serviceRecord!.bookingStartTime,
                                      bookingEndTime:
                                          serviceRecord!.bookingEndTime,
                                      createdTime: serviceRecord!.createdTime,
                                      acceptedTime: serviceRecord!.acceptedTime,
                                      actualStartTime:
                                          serviceRecord!.actualStartTime,
                                      actualEndTime: cancelTime!,
                                      status: RecordStatus.cancelled,
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
                                  }
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
                                  Colors.green),
                            ),
                            onPressed: status == "pending"
                                ? () {
                                    //Cancel original job
                                    setState(() {
                                      //to do: update status
                                      status = "cancelled";
                                      cancelTime =
                                          DateTime.now().millisecondsSinceEpoch;
                                    });

                                    //Save to firestore
                                    final updatedServiceRecord =
                                        model.ServiceRecord(
                                      rid: serviceRecord!.rid,
                                      uid: serviceRecord!.uid,
                                      pid: serviceRecord!.pid,
                                      sid: serviceRecord!.sid,
                                      bookingStartTime:
                                          serviceRecord!.bookingStartTime,
                                      bookingEndTime:
                                          serviceRecord!.bookingEndTime,
                                      createdTime: serviceRecord!.createdTime,
                                      acceptedTime: serviceRecord!.acceptedTime,
                                      actualStartTime:
                                          serviceRecord!.actualStartTime,
                                      actualEndTime: cancelTime!,
                                      status: RecordStatus.cancelled,
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

                                    //To Book page to book new job
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProviderBookScreen(
                                                  serviceProvider: provider!,
                                                )));
                                  }
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
                      title: "Job Created",
                      subTitle: getTimeByStatus("pending"),
                      active: status == "pending",
                    ),
                    // if (serviceRecord?.status ==RecordStatus.rejected) //job rejected by provider
                    Visibility(
                      visible: status == "rejected",
                      child: JobStatus(
                        title: "Job Rejected",
                        subTitle: getTimeByStatus("rejected"),
                        active: true,
                      ),
                    ),
                    // if (serviceRecord?.status ==RecordStatus.cancelled) //job cancelled by user
                    Visibility(
                      visible: status == "cancelled",
                      child: JobStatus(
                        title: "Job cancelled",
                        subTitle: getTimeByStatus("cancelled"),
                        active: true,
                      ),
                    ),
                    // if (serviceRecord?.status != RecordStatus.cancelled &&serviceRecord?.status != RecordStatus.rejected)
                    Visibility(
                      visible: status != "cancelled" && status != "rejected",
                      child: JobStatus(
                        title: "Job Accepted",
                        subTitle: getTimeByStatus("accepted"),
                        active: status == "confirmed",
                      ),
                    ),
                    // if (serviceRecord?.status != RecordStatus.cancelled &&
                    //     serviceRecord?.status != RecordStatus.rejected)
                    Visibility(
                      visible: status != "cancelled" && status != "rejected",
                      child: JobStatus(
                        title: "Job In Process",
                        subTitle: status == "started"
                            ? getTimeByStatus("started")
                            : "",
                        active: status == "started",
                      ),
                    ),
                    // if (serviceRecord?.status != RecordStatus.cancelled &&
                    //     serviceRecord?.status != RecordStatus.rejected)
                    Visibility(
                      visible: status != "cancelled" && status != "rejected",
                      child: JobStatus(
                        title: "Job Completed",
                        subTitle: status == "completed"
                            ? getTimeByStatus("completed")
                            : "",
                        active: status == "completed",
                      ),
                    ),
                  ],
                ),
              ),
              if (serviceRecord?.score != null &&
                  serviceRecord?.status == RecordStatus.completed)
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
                                serviceRecord?.score.toStringAsFixed(2) ?? "",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            RatingBar.builder(
                                ignoreGestures: true,
                                initialRating: serviceRecord?.score ?? 0,
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
              if (serviceRecord?.review != null &&
                  serviceRecord?.status == RecordStatus.completed)
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
                        child: Text(serviceRecord?.review ?? ""),
                      ),
                    ],
                  ),
                ),
              // if (status == completed &&
              //     serviceRecord.score == null)
              Visibility(
                visible: status == "completed" && serviceRecord?.score == null,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              JobViewScreen(provider: provider!)))
                    },
                    child: const Text("Review now"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
