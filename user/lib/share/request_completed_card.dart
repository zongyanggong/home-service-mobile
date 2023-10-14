import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';

class RequestCompletedCard extends StatelessWidget {
  RequestCompletedCard({super.key, required this.tempServiceRecord, this.onTap});
  TempServiceRecord tempServiceRecord;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    int starCount = tempServiceRecord.score.floor();
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
              "${DateFormat.yMd().format(tempServiceRecord.actualDate)} ${format24HourTime(TimeOfDay(hour: tempServiceRecord.actualStartTime.hour, minute: tempServiceRecord.actualStartTime.minute))}-${format24HourTime(TimeOfDay(hour: tempServiceRecord.actualEndTime.hour, minute: tempServiceRecord.actualEndTime.minute))}",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      tempServiceRecord.score.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < starCount; i++)
                        const Icon(
                          Icons.star,
                          color: Colors.green,
                          size: 15,
                        ),
                      for (int i = starCount; i < 5; i++)
                        const Icon(
                          Icons.star_border,
                          color: Colors.green,
                          size: 15,
                        ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
