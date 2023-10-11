import 'package:flutter/material.dart';
import 'package:user/services/service_provider.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key,required this.serviceProvider});
  ServiceProvider serviceProvider;

  @override
  Widget build(BuildContext context) {
    int starCount = serviceProvider.score.floor();
    return ListTile(
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
      title: Text(serviceProvider.name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
      subtitle: Text("CAD ${serviceProvider.price}/Hour",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            serviceProvider.score.toStringAsFixed(2),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [for (int i = 0; i < starCount; i++)
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
                ),],
          )
        ],
      ),
    );
  }
}






