import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:user/review/review_list.dart';
import 'package:user/share/review_field.dart';
import 'package:user/share/score_with_stars.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //total=70
    //avescore=70/20=3.5
    Scores scores = Scores()
      ..scores = [2, 3, 4, 5, 6]
      ..countCompleted = 50;

    return SingleChildScrollView(
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
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: const Center(
                  child: Text(
                "Your Current rating",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))),
          Column(
            children: [
              Text(
                scores.aveScore.toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: scores.aveScore,
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
            itemCount: scores.scores.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: ScoreItem(
                  score: scores.scores.length-index,
                  count: scores.scores[scores.scores.length-index-1],
                  value: scores.scores[scores.scores.length-index-1]/scores.countReview,
                ),
              );
            },
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                    (ReviewListScreen())));
                },
                child: const Text("Read all reviews"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 18),
            child: Row(
              children: [
                Expanded(child: ReviewField(title: scores.countReview, subTitle: "People Reviewed", iconData: Icons.stars)),
                const SizedBox(width: 10,),
                Expanded(child: ReviewField(title: scores.countCompleted, subTitle: "Tasks completed", iconData: Icons.check_circle)),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const Icon(
                Icons.star,
                color: Colors.green,
                size: 18,
              )
            ],
          ),
          trailing: Text(count.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          percent: value,
          center: Text("${value * 100}%"),
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
