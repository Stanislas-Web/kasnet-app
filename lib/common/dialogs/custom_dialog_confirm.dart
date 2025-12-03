import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class CustomDialogConfirm {
  static Future<DialogAction> yesAbortDialog(
      BuildContext context, String title, String body) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            width: 250.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                /* Text(title, style: TextStyle(), textAlign: TextAlign.center),
                 SizedBox(height: 30.0),*/
                Text(body, style: TextStyle(), textAlign: TextAlign.center),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buttonYes(context),
                    SizedBox(width: 10),
                    _buttonAbort(context),
                    SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }

  static _buttonAbort(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
        backgroundColor: PrimaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(DialogAction.abort);
      },
      child: Text("No",
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
    );
  }

  static _buttonYes(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
        backgroundColor: SecondaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(DialogAction.yes);
      },
      child: Text("Sí", style: TextStyle(), textAlign: TextAlign.center),
    );
  }
}
