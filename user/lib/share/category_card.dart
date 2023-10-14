import 'package:flutter/material.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/share/score_with_stars.dart';
import '../services/models.dart' as model;

class ProviderDetail extends StatelessWidget {
  const ProviderDetail({
    super.key,
    required this.serviceProvider,
  });

  final model.Provider serviceProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centers vertically within the Row
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(serviceProvider.imgPath),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20), // spacing between image and text
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns text to the start (left)
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centers vertically within the Column
                children: [
                  Text(
                    serviceProvider.name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CAD \$${serviceProvider.price}/Hour",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      ScoreWithStars(
                        score: 3.8,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
