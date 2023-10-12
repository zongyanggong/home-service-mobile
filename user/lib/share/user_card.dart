import 'package:flutter/material.dart';
import 'package:user/services/service_provider.dart';
import 'package:user/share/score_with_stars.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key, required this.serviceProvider,this.onTap});
  ServiceProvider serviceProvider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(serviceProvider.imgPath),
            ),
          ),
        ),
        title: Text(
          serviceProvider.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          "CAD \$${serviceProvider.price}/Hour",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        trailing: ScoreWithStars(score: serviceProvider.score,),
      ),
    );
  }
}


