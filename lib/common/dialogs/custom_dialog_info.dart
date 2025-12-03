import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

enum DialogAction { ok }

class CustomDialogInfo {
  static Future<DialogAction> infoDialog(
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
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: SemiTitleBlueTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        body,
                        style: SemiTitleBlueTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buttonOk(context),
                    SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    return (action != null) ? action : DialogAction.ok;
  }

  static _buttonOk(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
        backgroundColor: PrimaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Cerrar",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center),
    );
  }
}
