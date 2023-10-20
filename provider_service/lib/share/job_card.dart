import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

final FirestoreService _firestoreService = FirestoreService();

class JobCard extends StatelessWidget {
  JobCard(
      {super.key,
      required this.selectedIndex,
      required this.list,
      required this.jobIndex,
      this.onTap});
  final int selectedIndex;
  final Map<String, dynamic>? list;
  final int jobIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    model.User user;
    model.Service service;
    model.ServiceRecord serviceRecord;

    getServiceRecord() {
      switch (selectedIndex) {
        case 1:
          return list!['completedRecords'][jobIndex];
        case 2:
          return list!['cancelledRecords'][jobIndex];

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

    getTimePeriod(int flag) {
      if (flag == 0) {
        //0 : return booking time
        return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.bookingEndTime).minute))}";
      } else {
        //1 : return actual time
        return "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(serviceRecord.actualStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.actualStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.actualStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(serviceRecord.actualEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(serviceRecord.actualEndTime).minute))}";
      }
    }

    getTimeByStatus() {
      var statusStr = serviceRecord.status.toString().split('.').last;
      switch (statusStr) {
        case "cancelled":
          return getTimePeriod(0);
        case "rejected":
          return getTimePeriod(0);
        case "confirmed":
          return getTimePeriod(0);
        case "started":
          return getTimePeriod(0);
        case "completed":
          return getTimePeriod(1);
        case "reviewed":
          return getTimePeriod(1);
        default:
          return getTimePeriod(0); //pending
      }
    }

    getStatus(status) {
      return status[0].toUpperCase() + status.substring(1);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(user.imgPath!),
            ),
          ),
        ),
        title: Text(
          user.name!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          service.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              getTimeByStatus(),
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                getStatus(serviceRecord.status.toString().split('.').last),
                style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
