// ignore_for_file: unused_import, must_be_immutable, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user/categories/provider_detail.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/user_provider.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/input_field.dart';
import 'package:user/share/user_card.dart';

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
    //var user = Provider.of<CurrentUser>(context);
    // _addressController.text = user.address;

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
                    const InputField(
                      title: "Full Address",
                      hint: "Please input address",
                    ),
                    const InputField(
                      title: "Appointment notes",
                      hint: "Please input notes",
                      maxLines: 8,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
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
