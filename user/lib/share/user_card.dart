import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    double rating = 3.45;
    int starCount = rating.floor();
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        child: ClipOval(
          child: Image.asset(  
            'assets/images/face1.jpg', // 你需要指定正确的图像路径
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text("Dev, stack",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
      subtitle: Text("CAD 20/Hour",style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            rating.toStringAsFixed(2),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [for (int i = 0; i < starCount; i++)
              Icon(
                Icons.star,
                color: Colors.green,
                size: 15,
              ),
              for (int i = starCount; i < 5; i++)
                Icon(
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






