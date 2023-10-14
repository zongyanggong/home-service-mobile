import 'package:flutter/material.dart';
import 'package:user/requests/job_detail.dart';
import 'package:user/services/service.dart';
import 'package:provider/provider.dart';
import 'package:user/share/request_completed_card.dart';
import 'package:user/share/request_upcoming_card.dart';
import '../services/firestore.dart';
import '../services/models.dart' as model;

final FirestoreService _firestoreService = FirestoreService();

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final List<Widget> _tabPages = [UpcomingCard(), CompletedCard()];

  @override
  Widget build(BuildContext context) {
    // List<ServiceProvider> serviceProviders = [ServiceProvider()];
    return SingleChildScrollView(
      child: Column(
        children: [
          DefaultTabController(
            length: 2,
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
                )
              ],
            ),
          ),
          _tabPages[_selectedIndex]
        ],
      ),
    );
  }
}

class UpcomingCard extends StatelessWidget {
  UpcomingCard({super.key});

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    getServiceRecords() async {
      List<model.ServiceRecord> list =
          await _firestoreService.getServiceRecord();
      return list
          .where((element) => ((element.uid == info.currentUser.uid) &&
              (element.status == model.RecordStatus.pending ||
                  element.status == model.RecordStatus.confirmed ||
                  element.status == model.RecordStatus.started)))
          .toList();
    }

    return FutureBuilder<List<model.ServiceRecord>>(
        future: getServiceRecords(),
        builder: (BuildContext context,
            AsyncSnapshot<List<model.ServiceRecord>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Data loading has encountered an error
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been loaded successfully
            final serviceRecords = snapshot.data;
            var length = 0;
            if (serviceRecords != null) {
              length = serviceRecords.length;
            }

            return Padding(
                padding: const EdgeInsets.only(top: 9),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        child: RequestUpcomingCard(
                          tempServiceRecord: serviceRecords![index],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => JobDetail(
                                    serviceRecord: serviceRecords[index])));
                          },
                        ),
                      );
                    }));
          }
        });
  }
}

class CompletedCard extends StatelessWidget {
  CompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: false);

    getServiceRecords() async {
      List<model.ServiceRecord> list =
          await _firestoreService.getServiceRecord();
      return list
          .where((element) => ((element.uid == info.currentUser.uid) &&
              (element.status == model.RecordStatus.completed ||
                  element.status == model.RecordStatus.rejected ||
                  element.status == model.RecordStatus.reviewed)))
          .toList();
    }

    return FutureBuilder<List<model.ServiceRecord>>(
      future: getServiceRecords(),
      builder: (BuildContext context,
          AsyncSnapshot<List<model.ServiceRecord>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Data loading has encountered an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been loaded successfully
          final serviceRecords = snapshot.data;

          return Padding(
            padding: const EdgeInsets.only(top: 9),
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: serviceRecords!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    child: RequestCompletedCard(
                      tempServiceRecord: serviceRecords[index],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => JobDetail(
                                serviceRecord: serviceRecords[index])));
                      },
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
