import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ScoreWithStars extends StatelessWidget {
  const ScoreWithStars({
    super.key,
    required this.score,
  });
  final double score;
  @override
  Widget build(BuildContext context) {
    int starCount = score.floor();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          score.toStringAsFixed(2),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        RatingBar.builder(
            ignoreGestures: true,
            initialRating: score,
            maxRating: 5,
            allowHalfRating: true,
            itemSize: 16,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.green,
            ),
            onRatingUpdate: (rating) {}),
      ],
    );
  }
}