import 'package:un/common/inputs/custom_input.dart';
import 'package:un/models/generic.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

class CustomDialogInput {
  String? test;
  static var positionProccs;
  static var proccess;
  static final TextEditingController domainController =
      new TextEditingController();
  static final FocusNode domainNode = FocusNode();

  CustomDialogInput();

  static Future<String> input(BuildContext context, String title, String body,
      List<Generic> listProcces) async {
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
              children: <Widget>[
                Text(title,
                    style: SemiTitleBlueTextStyle, textAlign: TextAlign.start),
                SizedBox(height: 10.0),
                Divider(color: SecondaryThemeColor, thickness: 2),
                CustomInputField(
                  isRequired: true,
                  inputTypeInfo: "email",
                  borderColor: PrimaryThemeColor,
                  width: 200,
                  heightFont: 1.0,
                  inputType: TextInputType.text,
                  errorMsgInputType: "El correo debe incluir el caracter @",
                  controller: domainController,
                  currentNode: domainNode,
                  isLastInput: true,
                  focus: false,
                ),
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
          ),
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
        proccess = domainController.text;
        Navigator.of(context).pop(proccess);
      },
      child: Text("Ok", style: BtnBlueTextStyle, textAlign: TextAlign.center),
    );
  }
}
