import 'package:flutter/material.dart';
import 'package:user/requests/job_detail.dart';
import 'package:user/services/models.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/request_completed_card.dart';
import 'package:user/share/request_upcoming_card.dart';

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
    List<ServiceProvider> serviceProviders = [ServiceProvider()];
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
  final List<TempServiceRecord> tempServiceRecords = [
    TempServiceRecord()
      ..pid = 1
      ..rid = 1
      ..sid = 1
      ..name = "Provider 1"
      ..imgPath = 'assets/images/face1.jpg'
      ..price = 50
      ..status = RecordStatus.pending
      ..expectedDate = DateTime.now()
      ..expectedStartTime = DateTime.now()
      ..expectedEndTime = DateTime.now().add(const Duration(hours: 1)),
    TempServiceRecord()
      ..pid = 2
      ..rid = 2
      ..sid = 3
      ..name = 'Provider 2'
      ..imgPath = 'assets/images/face2.jpg'
      ..price = 60
      ..status = RecordStatus.confirmed
      ..expectedDate = DateTime.now()
      ..expectedStartTime = DateTime.now().add(const Duration(hours: 3))
      ..expectedEndTime = DateTime.now().add(const Duration(hours: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: tempServiceRecords.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            child: RequestUpcomingCard(
              tempServiceRecord: tempServiceRecords[index],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        JobDetail(serviceRecord: tempServiceRecords[index])));
              },
            ),
          );
        },
      ),
    );
  }
}

class CompletedCard extends StatelessWidget {
  CompletedCard({super.key});
  final List<TempServiceRecord> tempServiceRecords = [
    TempServiceRecord()
      ..pid = 1
      ..rid = 1
      ..sid = 1
      ..name = "Provider 1"
      ..imgPath = 'assets/images/face1.jpg'
      ..price = 50
      ..score = 4.6
      ..status = RecordStatus.completed
      ..actualDate = DateTime.now()
      ..actualStartTime = DateTime.now()
      ..actualEndTime = DateTime.now().add(const Duration(hours: 1)),
    TempServiceRecord()
      ..pid = 2
      ..rid = 2
      ..sid = 3
      ..name = 'Provider 2'
      ..imgPath = 'assets/images/face2.jpg'
      ..price = 60
      ..score = 3.5
      ..status = RecordStatus.completed
      ..actualDate = DateTime.now()
      ..actualStartTime = DateTime.now().add(const Duration(hours: 3))
      ..actualEndTime = DateTime.now().add(const Duration(hours: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: tempServiceRecords.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            child: RequestCompletedCard(
              tempServiceRecord: tempServiceRecords[index],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        JobDetail(serviceRecord: tempServiceRecords[index])));
              },
            ),
          );
        },
      ),
    );
  }
}
