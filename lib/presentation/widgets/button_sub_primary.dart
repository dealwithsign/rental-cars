// presentation/widgets/button_sub_primary.dart
import 'package:flutter/material.dart';
import 'package:rents_cars_app/utils/fonts.dart';

class SubPrimaryButton extends StatelessWidget {
  final String title;
  final double width;
  final Function() onPressed;
  final EdgeInsets margin;
  final IconData? icon;

  const SubPrimaryButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.icon,
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
        border: Border.all(
          color: descGrey,
          width: 0.5,
        ),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
                icon,
                color: kPrimaryColor,
                size: 20,
              )
            : Container(),
        label: Text(
          title,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: bold,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              defaultRadius,
            ),
          ),
        ),
      ),
    );
  }
}
