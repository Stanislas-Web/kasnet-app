import 'package:flutter/material.dart';

mixin InputLogic {
  String? validateHardcorePassword(value, errorMsgHardcorePwd) {
    String pattern =
        r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@!#$%^&+=])(?=\S+$).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return errorMsgHardcorePwd ?? '';
    }
  }

  String? validateEmail(value, errorMsgEmail) {
    String pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return errorMsgEmail ?? '';
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode? currentNode, FocusNode? nextNode) {
    currentNode?.unfocus();
    if (nextNode != null) FocusScope.of(context).requestFocus(nextNode);
  }

  void fieldFocusChangeOD(BuildContext context, String text,
      FocusNode? currentNode, FocusNode? nextNode) {
    if (text.length >= 1) {
      currentNode?.unfocus();
      if (nextNode != null) FocusScope.of(context).requestFocus(nextNode);
    }
  }

  void fieldFocusChangeML(BuildContext context, String text,
      FocusNode? currentNode, FocusNode? nextNode, int maxLength) {
    if (text.length >= maxLength) {
      currentNode?.unfocus();
      if (nextNode != null) FocusScope.of(context).requestFocus(nextNode);
    }
  }

  String? validateInputType(
      String value, String? errorMsgInputType, String inputTypeInfo) {
    String pattern = r'^[0-9]*$';
    RegExp regExp = RegExp(pattern);
    if (inputTypeInfo == 'onlyNumber' && !regExp.hasMatch(value)) {
      return errorMsgInputType ?? '';
    } else if (inputTypeInfo == 'onlyNumber' &&
        (value.contains("*") ||
            value.contains("-") ||
            value.contains(",") ||
            value.contains("."))) {
      return errorMsgInputType ?? '';
    } else if (inputTypeInfo == 'onlyText' && regExp.hasMatch(value)) {
      return errorMsgInputType ?? '';
    } else if (inputTypeInfo == 'cod' &&
        (!value.startsWith("0", 0) ||
            value.endsWith("0") ||
            !regExp.hasMatch(value))) {
      return errorMsgInputType ?? '';
    } else {
      return null;
    }
  }

  String? validateLength(String value, int minLength, int maxLength,
      String? errorMsgMaxLength, String? errorMsgMinLength) {
    if (value.length > maxLength) {
      return errorMsgMaxLength ?? '';
    } else if (value.length < minLength) {
      return errorMsgMinLength ?? '';
    } else {
      return null;
    }
  }
}
