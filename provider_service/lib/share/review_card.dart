import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard({super.key, required this.tempServiceRecord});
  TempServiceRecord tempServiceRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${DateFormat.yMd().format(tempServiceRecord.actualDate)} ${format24HourTime(TimeOfDay(hour: tempServiceRecord.actualStartTime!.hour, minute: tempServiceRecord.actualStartTime!.minute))}-${format24HourTime(TimeOfDay(hour: tempServiceRecord.actualEndTime!.hour, minute: tempServiceRecord.actualEndTime!.minute))}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                if (tempServiceRecord.score != null &&
                    tempServiceRecord.status == RecordStatus.completed)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            tempServiceRecord.score!.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ),
                        RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: tempServiceRecord.score!,
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
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 12),
            child: Text(tempServiceRecord.review!,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }
}
