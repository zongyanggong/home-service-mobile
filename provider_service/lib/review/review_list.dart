import 'package:flutter/material.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/review_card.dart';
import '../services/info_state.dart';
import '../services/models.dart' as model;
import '../services/firestore.dart';
import 'package:provider/provider.dart';

final FirestoreService _firestoreService = FirestoreService();

class ReviewListScreen extends StatefulWidget {
  ReviewListScreen({super.key});
  @override
  _ReviewListScreen createState() => _ReviewListScreen();
}

class _ReviewListScreen extends State<ReviewListScreen> {
  _ReviewListScreen();

  List<model.ServiceRecord>? serviceRecords;
  List<model.User>? users;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    var info = Provider.of<Info>(context, listen: false);

    //Get current user related service records
    serviceRecords = await _loadServiceRecords(info);

    users = await _firestoreService.getUser();

    // Ensure the widget is rebuilt after data is loaded.
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<model.ServiceRecord>> _loadServiceRecords(info) async {
    //Get all services
    List<model.ServiceRecord> serviceRecords =
        await _firestoreService.getServiceRecord();

    //Get current user's service records
    return serviceRecords.where((e) => e.pid == info.currentUser.pid).toList();
  }

  isNull() {
    if ((serviceRecords != null && serviceRecords!.isNotEmpty) &&
        (users != null && users!.isNotEmpty)) {
      return false;
    } else {
      return true;
    }
  }

  isReviewed(serviceRecord) {
    if (serviceRecord.status.toString().split('.').last == "reviewed" ||
        serviceRecord.status.toString().split('.').last == "completed") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: "Reviews",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 9),
          child: isNull()
              ? const Text("Loading...")
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: serviceRecords?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return isReviewed(serviceRecords![index])
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            child: ReviewCard(
                                tempServiceRecord: serviceRecords![index],
                                user: users!.firstWhere((u) =>
                                    u.uid == serviceRecords![index].uid)),
                          )
                        : null;
                  },
                ),
        ),
      ),
    );
  }
}
