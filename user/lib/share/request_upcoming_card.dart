import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

final FirestoreService _firestoreService = FirestoreService();

class RequestUpcomingCard extends StatelessWidget {
  RequestUpcomingCard({super.key, required this.tempServiceRecord, this.onTap});
  TempServiceRecord tempServiceRecord;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    getProvider() async {
      List<model.Provider> list = await _firestoreService.getProvider();
      return list
          .where((element) => element.pid == tempServiceRecord.pid)
          .toList();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: FutureBuilder<List<model.Provider>>(
          future: getProvider(),
          builder: (BuildContext context,
              AsyncSnapshot<List<model.Provider>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Data is still loading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Data loading has encountered an error
              return Text('Error: ${snapshot.error}');
            } else {
              // Data has been loaded successfully
              final providerList = snapshot.data;
              return ListTile(
                onTap: onTap,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(providerList![0].imgPath),
                    ),
                  ),
                ),
                title: Text(
                  providerList[0].name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  categories[providerList[0].sid],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingEndTime).minute))}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        tempServiceRecord.status.toString().split('.').last,
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
