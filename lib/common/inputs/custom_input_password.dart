import 'package:un/logics/logic_input.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputFielPassword extends StatefulWidget {
  CustomInputFielPassword(
      {required this.isConfirmPassword,
      this.minLength,
      this.maxLength,
      required this.isHardcorePassword,
      required this.width,
      this.heightFont,
      this.borderColor,
      this.hintText,
      this.inputType,
      this.errorMsgRequired,
      this.errorMsgMaxLength,
      this.errorMsgMinLength,
      this.errorMsgHardcorePwd,
      this.controller,
      this.passwordControllerForMatch,
      this.focus,
      this.currentNode,
      this.nextNode,
      required this.isLastInput});

  final int? minLength;
  final int? maxLength;
  final bool isConfirmPassword;
  final bool isHardcorePassword;
  final double width;
  final double? heightFont;
  final Color? borderColor;

  final String? hintText;
  final TextInputType? inputType;
  final String? errorMsgRequired;
  final String? errorMsgMaxLength;
  final String? errorMsgMinLength;
  final String? errorMsgHardcorePwd;
  final TextEditingController? controller;
  final TextEditingController? passwordControllerForMatch;
  final FocusNode? currentNode;
  final FocusNode? nextNode;
  final bool isLastInput;
  final bool? focus;
  @override
  _CustomInputFielPasswordState createState() =>
      _CustomInputFielPasswordState();
}

class _CustomInputFielPasswordState extends State<CustomInputFielPassword>
    with InputLogic {
  bool isObscurePassword = true;
  bool isPasswordRequired = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: widget.width,
      child: Column(
        children: <Widget>[
          TextFormField(
              style: TextStyle(
                  fontSize: MediumTextSize,
                  height: widget.heightFont,
                  color: Colors.black),
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              obscureText: isObscurePassword,
              autofocus: widget.focus ?? false,
              textInputAction: (widget.isLastInput)
                  ? TextInputAction.done
                  : TextInputAction.next,
              focusNode: widget.currentNode,
              onFieldSubmitted: (term) {
                if (!widget.isLastInput) {
                  fieldFocusChange(
                      context, widget.currentNode, widget.nextNode);
                }
              },
              keyboardType: widget.inputType,
              controller: widget.controller,
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    fontSize: (widget.controller?.text == "") ? 0 : 16.0),
                suffixIcon: IconButton(
                  alignment: Alignment.centerRight,
                  icon: (isObscurePassword)
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isObscurePassword = (isObscurePassword) ? false : true;
                    });
                  },
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    fontSize: 18.0, color: Color.fromRGBO(189, 189, 189, 1)),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.errorMsgRequired;
                }
                if (widget.minLength != null && widget.maxLength != null) {
                  if (validateLength(value, widget.minLength!, widget.maxLength!,
                          widget.errorMsgMaxLength ?? '', widget.errorMsgMinLength ?? '') !=
                      null) {
                    return validateLength(
                        value,
                        widget.minLength!,
                        widget.maxLength!,
                        widget.errorMsgMaxLength ?? '',
                        widget.errorMsgMinLength ?? '');
                  }
                }
                if (widget.isConfirmPassword) {
                  if (value == widget.passwordControllerForMatch?.text) {
                    return null;
                  } else {
                    return "";
                  }
                }
                if (widget.isHardcorePassword) {
                  return validateHardcorePassword(
                      value, widget.errorMsgHardcorePwd ?? '');
                }
                return null;
              },
              onSaved: (val) {}),
        ],
      ),
    );
  }
}
