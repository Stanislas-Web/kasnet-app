import 'package:un/models/answer.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

class CustomDialogListCheckboxAnswer {
  final List<Answer>? listItems;
  String? test;
  static var positionItem;
  static var itemSelected;
  static List<Answer>? listItemsSelected;

  CustomDialogListCheckboxAnswer({required this.listItems});

  static Future<List<Answer>> listSelect(BuildContext context, String title,
      String body, List<Answer> listQuestionReceived) async {
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
            return Container(
              height: 425,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(title,
                      style: SemiTitleBlueTextStyle,
                      textAlign: TextAlign.start),
                  SizedBox(height: 10.0),
                  Divider(color: SecondaryThemeColor, thickness: 2),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    width: 250.0,
                    height: 300.0,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Transform.scale(
                            scale: 1.05,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listQuestionReceived.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Theme(
                                          data: ThemeData(
                                              unselectedWidgetColor:
                                                  PrimaryThemeColor),
                                          child: Checkbox(
                                            value: listQuestionReceived[index]
                                                .valor ?? false,
                                            checkColor: SecondaryThemeColor,
                                            activeColor: PrimaryThemeColor,
                                            onChanged: (val) {
                                              setState(() {
                                                listQuestionReceived[index]
                                                        .valor =
                                                    !(listQuestionReceived[index]
                                                        .valor ?? false);
                                                listItemsSelected =
                                                    listQuestionReceived;
                                              });
                                            },
                                          )),
                                      Flexible(
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  listQuestionReceived[index]
                                                          .valor =
                                                      !(listQuestionReceived[
                                                              index]
                                                          .valor ?? false);
                                                  listItemsSelected =
                                                      listQuestionReceived;
                                                });
                                              },
                                              child: Text(
                                                  listQuestionReceived[index]
                                                      .descripcion ?? '')))
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: SecondaryThemeColor, thickness: 2),
                  // SizedBox(height: 10.0),
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
    List<Answer> emptyDays = [];
    return (action != null) ? action : emptyDays;
  }

  static _buttonAbort(context) {
    List<Answer> emptyDays = [];
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
        backgroundColor: PrimaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(emptyDays);
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
        Navigator.of(context).pop(listItemsSelected);
      },
      child: Text("Ok", style: BtnBlueTextStyle, textAlign: TextAlign.center),
    );
  }
}
