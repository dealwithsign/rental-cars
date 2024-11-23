// presentation/widgets/input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rents_cars_app/utils/fonts.dart';

class OutlineBorderTextFormField extends StatefulWidget {
  final FocusNode myFocusNode;
  final TextEditingController tempTextEditingController;
  final String labelText;
  final TextInputType keyboardType;
  final bool autofocus;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final String? Function(String?) validation;
  final bool checkOfErrorOnFocusChange;
  final bool autocorrect;
  final bool obscureText;
  final int? maxLength;

  const OutlineBorderTextFormField({
    super.key,
    required this.labelText,
    required this.autofocus,
    required this.tempTextEditingController,
    required this.myFocusNode,
    required this.inputFormatters,
    required this.keyboardType,
    required this.textInputAction,
    required this.validation,
    required this.checkOfErrorOnFocusChange,
    this.autocorrect = false,
    this.obscureText = false,
    this.maxLength,
    required String? Function(dynamic value) validator,
  });

  @override
  State<OutlineBorderTextFormField> createState() =>
      _OutlineBorderTextFormFieldState();
}

class _OutlineBorderTextFormFieldState
    extends State<OutlineBorderTextFormField> {
  bool isError = false;
  String errorString = "";

  void validateAndUpdateErrorStatus() {
    final validationResult =
        widget.validation(widget.tempTextEditingController.text);
    final newIsError = validationResult != null && validationResult.isNotEmpty;
    if (newIsError != isError || errorString != validationResult) {
      setState(() {
        isError = newIsError;
        errorString = validationResult ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                if (widget.checkOfErrorOnFocusChange) {
                  validateAndUpdateErrorStatus();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultRadius),
                  ),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: kDivider,
                  ),
                ),
                child: TextFormField(
                  cursorColor: kPrimaryColor,
                  focusNode: widget.myFocusNode,
                  controller: widget.tempTextEditingController,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    color: kPrimaryColor,
                    fontWeight: bold,
                  ),
                  autofocus: widget.autofocus,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  autocorrect: widget.autocorrect,
                  obscureText: widget.obscureText,
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: subTitleTextStyle.copyWith(
                      fontSize: 15.0,
                    ),
                    fillColor: kWhiteColor,
                    filled: true,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorStyle: const TextStyle(height: 0),
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isError,
            child: Container(
              padding: const EdgeInsets.only(left: 15.0, top: 2.0),
              child: Text(
                errorString,
                style: const TextStyle(fontSize: 10.0, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
