import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_review/in_app_review.dart';

class CustomSnackbar {
  final BuildContext? contextSnack;
  final String? message;
  final bool? isError;

  CustomSnackbar({this.contextSnack, this.message, this.isError});

  static dynamic snackBar(
      {required BuildContext contextSnack,
      required String message,
      required bool isError,
      bool? isInteractive,
      int? time}) async {
    return ScaffoldMessenger.of(contextSnack).showSnackBar(SnackBar(
      content: InkWell(
        child: Text(
          message,
          style: (isError) ? SnackBarErrorTextStyle : SnackBarInfoTextStyle,
          textAlign: TextAlign.center,
        ),
        onTap: () {
          // if(isInteractive != null || isInteractive != false){
          //   final InAppReview inAppReview = InAppReview.instance;
          //   if (await inAppReview.isAvailable()) inAppReview.requestReview();
          // }
        },
      ),
      backgroundColor: BackgroundItemColor,
      duration: Duration(milliseconds: (time == null) ? 2000 : time),
    ));
  }
}
