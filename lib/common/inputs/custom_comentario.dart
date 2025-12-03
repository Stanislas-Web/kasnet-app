import 'package:un/logics/logic_input.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CustomInputComentario extends StatefulWidget {
  CustomInputComentario(
      {required this.isRequired,
      this.readOnly,
      required this.inputTypeInfo,
      this.inputTypeFormat,
      this.minLength,
      this.maxLength,
      required this.height,
      required this.width,
      this.heightFont,
      this.borderColor,
      this.hintText,
      this.inputType,
      this.errorMsgRequired,
      this.errorMsgMinLength,
      this.errorMsgMaxLength,
      this.errorMsgInputType,
      this.currentNode,
      this.nextNode,
      this.controller,
      required this.isLastInput,
      this.focus});

  final bool isRequired;
  final bool? readOnly;
  final String inputTypeInfo;
  final String? inputTypeFormat;
  final int? minLength;
  final int? maxLength;
  final double width;
  final double height;
  final double? heightFont;
  final Color? borderColor;
  final String? hintText;
  final TextInputType? inputType;
  final String? errorMsgRequired;
  final String? errorMsgMinLength;
  final String? errorMsgMaxLength;
  final String? errorMsgInputType;
  final TextEditingController? controller;
  final FocusNode? currentNode;
  final FocusNode? nextNode;
  final bool isLastInput;
  final bool? focus;

  @override
  _CustomInputComentarioState createState() => _CustomInputComentarioState();
}

double thRightCustomText = 0;

class _CustomInputComentarioState extends State<CustomInputComentario>
    with InputLogic {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    thRightCustomText =
        (screenHeight <= 600) ? screenHeight * 0.15 : screenHeight * 0.30;
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: screenWidth * 0.8,
      height: screenHeight * 0.35,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: PrimaryThemeColor),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, right: 20.0, left: 20.0, bottom: 10.0),
        child: TextFormField(
          controller: widget.controller,
          maxLines: 8,

          // decoration: InputDecoration.collapsed(
          //   hintText: widget.hintText ,hintStyle: TextStyle(fontSize: widget.heightFont)

          // ),
          decoration: InputDecoration(
              // contentPadding: EdgeInsets.zero,
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: widget.heightFont),
              counterText: "",
              contentPadding:
                  EdgeInsets.fromLTRB(0, screenHeight * 0.125, 0, 0),
              border: InputBorder.none
              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
