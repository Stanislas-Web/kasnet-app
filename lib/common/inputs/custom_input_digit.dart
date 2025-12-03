import 'package:un/logics/logic_input.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputFieldOneDigit extends StatelessWidget with InputLogic {
  CustomInputFieldOneDigit({
    this.inputType,
    required this.width,
    this.height,
    this.borderColor,
    this.hintText,
    this.errorMsg,
    this.controller,
    this.currentNode,
    this.nextNode,
    required this.isLastInput,
    this.focus,
  });

  final TextInputType? inputType;
  final double? width;
  final double? height;
  final String? hintText;
  final String? errorMsg;
  final Color? borderColor;
  final TextEditingController? controller;
  final FocusNode? currentNode;
  final FocusNode? nextNode;
  final bool? isLastInput;
  final bool? focus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: width,
      child: TextFormField(
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          style: TextStyle(
              fontSize: MediumTextSize, height: 1.5, color: Colors.black),
          autofocus: focus ?? false,
          textInputAction:
              (isLastInput ?? false) ? TextInputAction.done : TextInputAction.next,
          keyboardType: inputType,
          controller: controller,
          focusNode: currentNode,
          onFieldSubmitted: (term) {
            fieldFocusChange(context, currentNode, nextNode);
          },
          onChanged: (text) {
            fieldFocusChangeOD(context, text, currentNode, nextNode);
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: MediumTextSize,
                color: Color.fromRGBO(189, 189, 189, 1)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: PrimaryThemeColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: PrimaryThemeColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: PrimaryThemeColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
          ),
          validator: (value) {
            String pattern = r'[0-9]+';
            RegExp regExp = RegExp(pattern);
            if (value != null && regExp.hasMatch(value)) {
              return null;
            } else {
              return '';
            }
          }),
    );
  }
}
