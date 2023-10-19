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
    model.Provider provider;
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

        case "cancelled":
          return getFormatTime(serviceRecord.actualEndTime);
        case "rejected":
          return getFormatTime(serviceRecord.actualEndTime);
        default:
          return "";
      }
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
              image: NetworkImage(provider.imgPath),
            ),
          ),
        ),
        title: Text(
          provider.name,
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
                serviceRecord.status.toString().split('.').last,
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
