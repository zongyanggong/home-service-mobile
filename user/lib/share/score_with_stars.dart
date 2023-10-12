import 'package:flutter/material.dart';

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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < starCount; i++)
              const Icon(
                Icons.star,
                color: Colors.green,
                size: 15,
              ),
            for (int i = starCount; i < 5; i++)
              const Icon(
                Icons.star_border,
                color: Colors.green,
                size: 15,
              ),
          ],
        )
      ],
    );
  }
}