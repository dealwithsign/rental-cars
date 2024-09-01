// presentation/widgets/flushbar_widget.dart
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../utils/fonts.dart';

class CustomFlushbar {
  final BuildContext context;
  final String title;
  final String message;

  const CustomFlushbar({
    required this.context,
    required this.title,
    required this.message,
  });

  void show() {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(seconds: 5),
      backgroundColor: kPrimaryColor,
      titleText: Text(
        title,
        style: buttonColor.copyWith(
          fontSize: 14, // Body Medium
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: buttonColor.copyWith(
          fontSize: 13, // Body Medium
        ),
      ),
      margin: EdgeInsets.only(
        left: defaultMargin,
        right: defaultMargin,
        bottom: defaultMargin,
      ),
      borderRadius: BorderRadius.circular(defaultRadius),
    ).show(context);
  }
}

void showErrorFlushbar(BuildContext context, String title, String message) {
  final flushbar = CustomFlushbar(
    context: context,
    title: title,
    message: message,
  );

  flushbar.show();
}
