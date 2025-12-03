import 'package:un/logics/logic_input.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatefulWidget {
  CustomInputField(
      {required this.isRequired,
      this.readOnly,
      required this.inputTypeInfo,
      this.inputTypeFormat,
      this.minLength,
      this.maxLength,
      required this.width,
      this.height,
      this.heightFont,
      this.borderColor,
      this.textColor,
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
      this.focus,
      this.iconSufix});
  final Widget? iconSufix;
  final bool isRequired;
  final bool? readOnly;
  final String inputTypeInfo;
  final String? inputTypeFormat;
  final int? minLength;
  final int? maxLength;
  final double width;
  final double? height;
  final double? heightFont;
  final Color? borderColor;
  final Color? textColor;
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
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> with InputLogic {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        width: widget.width,
        height: (widget.height == null) ? null : widget.height,
        child: TextFormField(
          readOnly: (widget.readOnly == null || widget.readOnly == false)
              ? false
              : true,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          style: TextStyle(
            fontSize: MediumTextSize,
            height: widget.heightFont,
            color: (widget.textColor == null) ? Colors.black : widget.textColor,
          ),
          autofocus: widget.focus ?? false,
          textInputAction: (widget.isLastInput)
              ? TextInputAction.done
              : TextInputAction.next,
          focusNode: widget.currentNode,
          onFieldSubmitted: (term) {
            if (!widget.isLastInput) {
              fieldFocusChange(context, widget.currentNode, widget.nextNode);
            }
          },
          onChanged: (text) {
            if (widget.maxLength != null) {
              fieldFocusChangeML(context, text, widget.currentNode,
                  widget.nextNode, widget.maxLength!);
            }
          },
          keyboardType: widget.inputType,
          textCapitalization: TextCapitalization.sentences,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              alignment: Alignment.centerRight,
              icon: widget.iconSufix ?? Container(),
              onPressed: null,
            ),
            errorStyle: TextStyle(fontSize: 16.0),
            fillColor: (widget.readOnly == null || widget.readOnly == false)
                ? Colors.white
                : Colors.grey[300],
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
                fontSize: 15, color: Color.fromRGBO(189, 189, 189, 1)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
          ),
          validator: (value) {
            if (!widget.isRequired && (value == null || value.isEmpty)) {
              return null;
            }
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return widget.errorMsgRequired;
            }
            if (widget.readOnly != null && widget.readOnly == true) {
              return null;
            }
            // At this point value is guaranteed non-null
            final String nonNullValue = value!;
            if (widget.inputTypeInfo == 'onlyText' ||
                widget.inputTypeInfo == 'onlyNumber' ||
                widget.inputTypeInfo == 'cod') {
              if (validateInputType(
                      nonNullValue, widget.errorMsgInputType, widget.inputTypeInfo) !=
                  null) {
                return validateInputType(
                    nonNullValue, widget.errorMsgInputType, widget.inputTypeInfo);
              }
            }
            if (widget.minLength != null && widget.maxLength != null) {
              if (validateLength(nonNullValue, widget.minLength!, widget.maxLength!,
                      widget.errorMsgMaxLength, widget.errorMsgMinLength) !=
                  null) {
                return validateLength(nonNullValue, widget.minLength!, widget.maxLength!,
                    widget.errorMsgMaxLength, widget.errorMsgMinLength);
              }
            }
            if (widget.inputTypeInfo == 'email') {
              return validateEmail(nonNullValue, widget.errorMsgInputType);
            }
            return null;
          },
          onSaved: (val) {},
        ));
  }
}
