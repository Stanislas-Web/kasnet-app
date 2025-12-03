import 'package:flutter/material.dart';
import 'package:un/styles/style.dart';

class UndefinedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundScreenColor,
      body: Container(
          padding: EdgeInsets.all(40),
          color: Colors.white,
          child: Center(
            child: Text(
              'Pantalla no definida.',
              style: BodyTextStyle,
            ),
          )),
    );
  }
}
