import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:user/review/review_list.dart';
import 'package:user/share/review_field.dart';
import 'package:user/share/score_with_stars.dart';
import '../services/info_state.dart';
import '../services/models.dart' as model;
import '../services/firestore.dart';
import 'package:provider/provider.dart';

final FirestoreService _firestoreService = FirestoreService();

class ReviewsPage extends StatefulWidget {
  ReviewsPage({super.key});
  @override
  _ReviewsPage createState() => _ReviewsPage();
}

class _ReviewsPage extends State<ReviewsPage> {
  _ReviewsPage();

  List<model.ServiceRecord>? serviceRecord;
  int taskCompletedCount = 0;
  int taskReviewedCount = 0;
  double averageScore = 0.0;
  List<int> scoreCounts = [0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    var info = Provider.of<Info>(context, listen: false);

    //Get current user related service records
    serviceRecord = await _loadServiceRecords(info);

    //Count all completed, reviewed tasks number
    taskCompletedCount = serviceRecord!
        .where((e) =>
            e.status.toString().split('.').last == "completed" ||
            "reviewed" == e.status.toString().split('.').last)
        .toList()
        .length;

    //Get all reviewed tasks number
    taskReviewedCount = serviceRecord!
        .where((e) => e.status.toString().split('.').last == "reviewed")
        .toList()
        .length;

    //Calculate average score
    averageScore = serviceRecord!
            .where((e) => e.status.toString().split('.').last == "reviewed")
            .toList()
            .fold(0.0, (sum, e) => sum + e.score) /
        taskReviewedCount;
    print("averageScore: $averageScore");

    //Count all scores below 2
    scoreCounts[0] = _getScoreBetween(0, 2);

    //Count all scores between 2 and 3
    scoreCounts[1] = _getScoreBetween(2, 3);

    //Count all scores between 3 and 4
    scoreCounts[2] = _getScoreBetween(3, 4);

    //Count all scores between 4 and 5
    scoreCounts[3] = _getScoreBetween(4, 5);

    //Count all scores between 5 and 6
    scoreCounts[4] = _getScoreBetween(5, 6);

    // Ensure the widget is rebuilt after data is loaded.
    if (mounted) {
      setState(() {});
    }
  }

  //Get score between a and b
  int _getScoreBetween(int a, int b) {
    return serviceRecord!
        .where((e) =>
            e.status.toString().split('.').last == "reviewed" &&
            e.score >= a &&
            e.score < b)
        .toList()
        .length;
  }

  Future<List<model.ServiceRecord>> _loadServiceRecords(info) async {
    //Get all services
    List<model.ServiceRecord> serviceRecords =
        await _firestoreService.getServiceRecord();

    //Get current user's service records
    return serviceRecords.where((e) => e.pid == info.currentUser.pid).toList();
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<Info>(context, listen: true);

    return info.currentUser.pid == ""
        ? const Padding(
            padding: EdgeInsets.all(16.0), // Adjust the value as needed
            child: Center(
              child: Text(
                "Please login to see your reviews",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ))
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 40,
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50], // Background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: const Center(
                        child: Text(
                      "Your Current rating",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))),
                Column(
                  children: [
                    Text(
                      averageScore.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: averageScore,
                        minRating: 1,
                        maxRating: 5,
                        allowHalfRating: true,
                        itemSize: 20,
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.green,
                            ),
                        onRatingUpdate: (rating) {}),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: scoreCounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 9),
                      child: ScoreItem(
                        score: scoreCounts.length - index,
                        count: scoreCounts[scoreCounts.length - index - 1],
                        value: scoreCounts[scoreCounts.length - index - 1] /
                            taskReviewedCount,
                      ),
                    );
                  },
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => (ReviewListScreen())));
                      },
                      child: const Text("Read all reviews"),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  child: Row(
                    children: [
                      Expanded(
                          child: ReviewField(
                              title: taskReviewedCount,
                              subTitle: "People Reviewed",
                              iconData: Icons.stars)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ReviewField(
                              title: taskCompletedCount,
                              subTitle: "Tasks completed",
                              iconData: Icons.check_circle)),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class ScoreItem extends StatelessWidget {
  const ScoreItem(
      {super.key,
      required this.score,
      required this.value,
      required this.count});
  final int score;
  final int count;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        LinearPercentIndicator(
          width: 250.0,
          animation: true,
          animationDuration: 1000,
          lineHeight: 20.0,
          leading: Row(
            children: [
              Text(
                score.toString(),
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const Icon(
                Icons.star,
                color: Colors.green,
                size: 18,
              )
            ],
          ),
          trailing: Text(count.toString(),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          percent: value,
          center: Text("${(value * 100).toStringAsFixed(2)}%"),
          linearStrokeCap: LinearStrokeCap.butt,
          progressColor: Colors.green,
        ),
        const Spacer(),
      ],
    );
  }
}

class Scores {
  late List<int> scores;
  double get aveScore {
    int total = scores
        .asMap()
        .entries
        .fold(0, (sum, entry) => sum + ((entry.key + 1) * entry.value));
    return scores.isNotEmpty ? total / countReview : 0.0;
  }

  int get countReview => scores.fold(0, (sum, score) => sum + score);
  late int countCompleted;
}
