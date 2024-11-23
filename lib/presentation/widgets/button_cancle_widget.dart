// presentation/widgets/button_cancle.dart
import 'package:flutter/material.dart';
import 'package:rents_cars_app/utils/fonts.dart';

class CustomButtonCancel extends StatelessWidget {
  final String title;
  final double width;
  final Function() onPressed;
  final EdgeInsets margin;

  const CustomButtonCancel({
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
        color: emptyColor,
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(color: kTransparentColor),
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
