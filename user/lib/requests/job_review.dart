import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/info_state.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/input_field.dart';
import 'package:user/share/job_status.dart';
import 'package:user/share/label_field.dart';
import 'package:provider/provider.dart';
import '../services/models.dart' as model;
import '../services/firestore.dart';
import './job_detail.dart';

final FirestoreService _firestoreService = FirestoreService();

class JobViewScreen extends StatefulWidget {
  JobViewScreen(
      {super.key,
      required this.provider,
      required this.serviceRecord,
      required this.selectedIndex,
      required this.jobIndex});
  model.Provider provider;
  model.ServiceRecord serviceRecord;
  int selectedIndex;
  int jobIndex;

  @override
  State<JobViewScreen> createState() => _JobViewScreenState();
}

class _JobViewScreenState extends State<JobViewScreen> {
  final TextEditingController _desController = TextEditingController();
  double initScore = 3;
  model.Provider? provider;
  model.Service? service;
  String serviceName = "";
  bool isReviewed = true;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    var info = Provider.of<Info>(context, listen: false);
    provider = widget.provider;

    service = await _loadService(provider);
    serviceName = service!.name;

    // Ensure the widget is rebuilt after data is loaded.
    if (mounted) {
      setState(() {});
    }
  }

  Future<model.Service> _loadService(provider) async {
    //Get all services
    List<model.Service> services = await _firestoreService.getService();
    //Get current record's service
    return services.firstWhere((e) => e.sid == provider.sid);
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: "Review now"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50], // Background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: const Center(
                    child: Text(
                  "We hope you had a great service!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ))),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Kindly rate and review your experience with",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue[700],
                    decorationThickness: 3),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.provider.imgPath),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.provider.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(serviceName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            RatingBar.builder(
                initialRating: initScore,
                minRating: 1,
                maxRating: 5,
                allowHalfRating: true,
                itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                onRatingUpdate: (rating) {
                  setState(() {
                    initScore = rating;
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
              child: InputField(
                title: "Let us know your experience",
                hint: "Please input",
                maxLines: 6,
                controller: _desController,
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: isReviewed
                      ? () {
                          //Update service record review status

                          final updatedServiceRecord = model.ServiceRecord(
                            rid: widget.serviceRecord.rid,
                            uid: widget.serviceRecord.uid,
                            pid: widget.serviceRecord.pid,
                            sid: widget.serviceRecord.sid,
                            bookingStartTime:
                                widget.serviceRecord.bookingStartTime,
                            bookingEndTime: widget.serviceRecord.bookingEndTime,
                            createdTime: widget.serviceRecord.createdTime,
                            acceptedTime: widget.serviceRecord.acceptedTime,
                            actualStartTime:
                                widget.serviceRecord.actualStartTime,
                            actualEndTime: widget.serviceRecord.actualEndTime,
                            status: RecordStatus.reviewed,
                            score: initScore,
                            review: _desController.text,
                            price: widget.serviceRecord.price,
                            appointmentNotes:
                                widget.serviceRecord.appointmentNotes,
                          );

                          // Now, update the ServiceRecord
                          try {
                            _firestoreService
                                .updateServiceRecordById(updatedServiceRecord);
                          } catch (e) {
                            debugPrint(e.toString());
                          }

                          //Grey the button
                          setState(() {
                            isReviewed = false;
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => JobDetail(
                          //         selectedIndex: widget.selectedIndex,
                          //         // list: listObj,
                          //         jobIndex: widget.jobIndex)));
                        }
                      : null,
                  child: const Text("Submit Rating"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
