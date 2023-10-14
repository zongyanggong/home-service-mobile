import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/score_with_stars.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

final FirestoreService _firestoreService = FirestoreService();

class RequestCompletedCard extends StatelessWidget {
  RequestCompletedCard(
      {super.key, required this.tempServiceRecord, this.onTap});
  model.ServiceRecord tempServiceRecord;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    getProvider() async {
      List<model.Provider> list = await _firestoreService.getProvider();
      return list
          .where((element) => element.pid == tempServiceRecord.pid)
          .toList();
    }

    int starCount = 1; //tempServiceRecord.score.floor();
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
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.actualStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.actualStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.actualStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.actualEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(tempServiceRecord.actualEndTime).minute))}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                "4.55",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
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
                );
              }
            }));
  }
}
