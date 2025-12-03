import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const CustomLoading({Key? key, required this.screenWidth, required this.screenHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: Color.fromRGBO(0, 0, 0, 0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: SecondaryThemeColor,
            strokeWidth: 5.0,
          ),
        ],
      ),
    );
  }
}
