import 'package:flutter/material.dart';
import 'package:user/requests/job_detail.dart';
import 'package:user/services/record_status.dart';
import 'package:user/share/job_card.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;
import '../services/info_state.dart';
import 'package:provider/provider.dart';

final FirestoreService _firestoreService = FirestoreService();

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List<ServiceProvider> serviceProviders = [ServiceProvider()];
    return SingleChildScrollView(
      child: Column(
        children: [
          DefaultTabController(
            length: 3,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.blueAccent[700],
              unselectedLabelColor: Colors.blueAccent[200],
              labelColor: Colors.blueAccent[700],
              onTap: (int selectIndex) {
                setState(() {
                  _selectedIndex = selectIndex;
                });
              },
              tabs: const [
                Tab(
                  child: Text("Upcoming"),
                ),
                Tab(
                  child: Text("Completed"),
                ),
                Tab(
                  child: Text("Canceled"),
                )
              ],
            ),
          ),
          JobCardList(selectedIndex: _selectedIndex),
        ],
      ),
    );
  }
}

class JobCardList extends StatelessWidget {
  final int selectedIndex;
  JobCardList({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: true);

    getServiceRecordsInfo() async {
      //Get all providers
      List<model.Provider> serviceProviders =
          await _firestoreService.getProvider();

      //Get all services
      List<model.Service> services = await _firestoreService.getService();

      // //Get all service records
      List<model.ServiceRecord> serviceRecords =
          await _firestoreService.getServiceRecord();
      // //Get current user's service records
      serviceRecords =
          serviceRecords.where((e) => e.uid == info.currentUser.uid).toList();

      // //Get uncoming service
      List<model.ServiceRecord> upcomingRecords = serviceRecords
          .where((e) =>
              e.status.toString().split('.').last == "pending" ||
              e.status.toString().split('.').last == "confirmed" ||
              e.status.toString().split('.').last == "started")
          .toList();

      //Get completed service
      List<model.ServiceRecord> completedRecords = serviceRecords
          .where((e) =>
              e.status.toString().split('.').last == "completed" ||
              e.status.toString().split('.').last == "reviewed")
          .toList();

      //Get canceled service
      List<model.ServiceRecord> canceledRecords = serviceRecords
          .where((e) =>
              e.status.toString().split('.').last == "rejected" ||
              e.status.toString().split('.').last == "canceled")
          .toList();

      //Get length
      var length = 0;
      switch (selectedIndex) {
        case 1:
          length = completedRecords.length;
        case 2:
          length = canceledRecords.length;
        default:
          length = upcomingRecords.length;
      }

      //Return object include all info
      return {
        'serviceProviders': serviceProviders,
        'services': services,
        'upcomingRecords': upcomingRecords,
        'completedRecords': completedRecords,
        'canceledRecords': canceledRecords,
        'length': length,
      };
    }

    return info.currentUser.uid == ""
        ? const Padding(
            padding: EdgeInsets.all(16.0), // Adjust the value as needed
            child: Center(
              child: Text(
                "Please login to see your requests",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ))
        : FutureBuilder<Map<String, dynamic>>(
            future: getServiceRecordsInfo(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Data is still loading
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Data loading has encountered an error
                return Text('Error1: ${snapshot.error}');
              } else {
                // Data has been loaded successfully
                final listObj = snapshot.data;
                if (listObj == null) {
                  return const Center(
                    child: Text("No Request"),
                  );
                } else {
                  if (listObj['serviceProviders'] == null ||
                      (listObj['upcomingRecords'] == null &&
                          listObj['completedRecords'] == null &&
                          listObj['canceledRecords'] == null)) {
                    return const Center(
                      child: Text("No Request"),
                    );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: listObj['length'],
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        child: JobCard(
                          selectedIndex: selectedIndex,
                          list: listObj,
                          jobIndex: index,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => JobDetail(
                                    selectedIndex: selectedIndex,
                                    // list: listObj,
                                    jobIndex: index)));
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            });
  }
}
