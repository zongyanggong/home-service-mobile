import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';

class RequestCancelCard extends StatelessWidget {
  RequestCancelCard(
      {super.key, required this.tempServiceRecord, this.onTap});
  TempServiceRecord tempServiceRecord;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
              image: AssetImage(tempServiceRecord.imgPath),
            ),
          ),
        ),
        title: Text(
          tempServiceRecord.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          categories[tempServiceRecord.sid],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.bookingEndTime).minute))}",
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            if (tempServiceRecord.status == RecordStatus.canceled ||
                tempServiceRecord.status == RecordStatus.rejected)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        tempServiceRecord.status.toString().split('.').last,
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
