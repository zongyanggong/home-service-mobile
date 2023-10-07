import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  AppBarTitle({
    super.key,
    required this.title
  });

  String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          alignment: Alignment.center,  // 使图片在整个AppBar中居中
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title),
            ),
             Image.asset("./assets/images/logo.jpg", height: 120, width: 120),
          ],
        );
      },
    );
  }
}
