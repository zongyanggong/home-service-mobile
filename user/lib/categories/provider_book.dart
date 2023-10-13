import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user/categories/provider_detail.dart';
import 'package:user/services/service_provider.dart';

import 'package:user/share/appBarTitle.dart';
import 'package:user/share/input_field.dart';
import 'package:user/share/user_card.dart';
import '../services/firestore.dart';
import '../services/models.dart';
import 'package:uuid/uuid.dart';
import '../services/info_state.dart';
import 'package:provider/provider.dart' as provider;

final FirestoreService _firestoreService = FirestoreService();

class ProviderBookScreen extends StatefulWidget {
  ProviderBookScreen({super.key, required this.serviceProvider});
  ServiceProvider serviceProvider;

  @override
  State<ProviderBookScreen> createState() => _ProviderBookScreenState();
}

class _ProviderBookScreenState extends State<ProviderBookScreen> {
  late DateTime _selectedDate = DateTime.now();
  final DateTime _startDateTime = DateTime.now();
  late final DateTime _endDateTime =
      _startDateTime.add(const Duration(hours: 1));
  late String _startTime;
  late String _endTime;
  late TextEditingController _addressController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _startTime =
        TimeOfDay(hour: _startDateTime.hour, minute: _startDateTime.minute)
            .format(context);
    _endTime = TimeOfDay(hour: _endDateTime.hour, minute: _endDateTime.minute)
        .format(context);
  }

  @override
  Widget build(BuildContext context) {
    var info = provider.Provider.of<Info>(context,
        listen: false); // _addressController.text = user.address;

    var hint = info.currentUser.address != ""
        ? info.currentUser.address!
        : "Please update your address in Account page";

    TextEditingController notesController = TextEditingController();
    notesController.text = "";
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: "Book Now",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserCard(
                serviceProvider: widget.serviceProvider,
              ),
              Container(
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50], // Background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Column(
                  children: [
                    InputField(
                      title: "Date",
                      hint: DateFormat.yMd().format(_selectedDate),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateFromUser();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InputField(
                          title: "Start Time",
                          hint: _startTime,
                          widget: IconButton(
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getTimeFromUser(isStartTime: true);
                            },
                          ),
                        )),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: InputField(
                          title: "End Time",
                          hint: _endTime,
                          widget: IconButton(
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getTimeFromUser(isStartTime: false);
                            },
                          ),
                        )),
                      ],
                    ),
                    InputField(
                      title: "Full Address",
                      hint: hint,
                    ),
                    InputField(
                      title: "Appointment notes",
                      hint: "Please input notes",
                      maxLines: 8,
                      controller: notesController,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: add service record

                    try {
                      //
                      const uuid = Uuid();

                      //New user
                      _firestoreService.createServiceRecord(
                        ServiceRecord(
                          rid: uuid.v1(),
                          uid: info.currentUser!.uid!,
                          sid: "1",
                          pid: '1',
                          status: RecordStatus.pending,
                          createdTime:
                              DateTime.now().toUtc().millisecondsSinceEpoch,
                          acceptedTime: 0,
                          actualStartTime: 0,
                          actualEndTime: 0,
                          bookingStartTime:
                              _convertTimeTomillisecondsSinceEpoch(
                                  _selectedDate, _startTime),
                          bookingEndTime: _convertTimeTomillisecondsSinceEpoch(
                              _selectedDate, _endTime),
                          appointmentNotes: notesController.text,
                        ),
                      );

                      // User creation was successful, you can add your logic here
                    } catch (e) {
                      // Handle any errors that occurred during user creation
                      print('Error creating service record: $e');
                    }

                    Navigator.pushNamed(context, "/");
                  },
                  child: const Text("Confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _convertTimeTomillisecondsSinceEpoch(selectedDate, startTime) {
    int hour = int.parse(startTime.split(":")[0]);
    int minute = int.parse(startTime.split(":")[1].split(" ")[0]);
    bool isPM = startTime.split(":")[1].split(" ")[1] == "PM";

    if (isPM && hour < 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    String time24Hour =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

    DateTime fullStartTime =
        DateTime.parse("${_selectedDate.toString().split(" ")[0]} $time24Hour");

    return fullStartTime.millisecondsSinceEpoch;
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2123));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      debugPrint("It's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      debugPrint("Time canceled");
    } else if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }
}
