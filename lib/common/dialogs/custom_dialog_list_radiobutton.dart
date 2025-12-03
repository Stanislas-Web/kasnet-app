import 'package:un/models/generic.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class CustomDialogListRadiobutton {
  final List<String>? listProcces;
  String? test;
  static var positionProccs;
  static var proccess;
  static var isProccess;
  static List<Generic>? listItemsSelected;
  static int group = 1;
  static int value = 0;

  CustomDialogListRadiobutton({required this.listProcces});

  static Future<String> listSelect(BuildContext context, String title,
      String body, List<Generic> listProcces) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            value = 0;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              width: 250.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title,
                      style: SemiTitleBlueTextStyle,
                      textAlign: TextAlign.start),
                  SizedBox(height: 10.0),
                  Divider(color: SecondaryThemeColor, thickness: 2),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listProcces.length,
                      itemBuilder: (BuildContext context, int index) {
                        value++;
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Radio(
                                groupValue: group,
                                value: value,
                                onChanged: (val) {
                                  setState(() {
                                    proccess = listProcces[index].description;
                                    if (val == 1) {
                                      listProcces[index].value = true;
                                    } else if (val == 2) {
                                      listProcces[index].value = false;
                                    }
                                    group = val ?? 1;
                                    isProccess = val;
                                  });
                                },
                              ),
                            ),
                            InkWell(
                              child: Text(listProcces[index].description ?? ''),
                              onTap: () {
                                setState(() {
                                  listProcces[index].value = true;
                                  proccess = listProcces[index].description;
                                  group = index + 1;
                                  isProccess = index + 1;
                                });
                              },
                            ),
                          ],
                        );
                      }),
                  Divider(color: SecondaryThemeColor, thickness: 2),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buttonAbort(context),
                      SizedBox(width: 10),
                      _buttonYes(context),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      },
    );
    return (action != null) ? action : "";
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
        Navigator.of(context).pop("");
      },
      child: Text("Cancelar",
          style: BtnLightTextStyle, textAlign: TextAlign.center),
    );
  }

  static _buttonYes(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
        backgroundColor: SecondaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(proccess);
      },
      child: Text("Ok", style: BtnBlueTextStyle, textAlign: TextAlign.center),
    );
  }
}
