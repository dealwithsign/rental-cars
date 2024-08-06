// presentation/widgets/button.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rents_cars_app/utils/fonts.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double width;
  final Function() onPressed;
  final EdgeInsets margin;

  const CustomButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 45,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          defaultRadius,
        ),
        color: kButtonColor,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              defaultRadius,
            ),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(
            fontSize: 14,
            fontWeight: bold,
          ),
        ),
      ),
    );
  }
}