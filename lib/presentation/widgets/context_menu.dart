// presentation/widgets/context_menu.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../utils/fonts.dart';

class ContextMenu extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color kIconColor;
  final TextStyle kPrimaryColor;
  final TextStyle subTitleTextStyle;

  const ContextMenu({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.kIconColor,
    required this.kPrimaryColor,
    required this.subTitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 100,
            color: const Color(0xFF2b2b2b),
          ),
          SizedBox(height: defaultMargin),
          Text(
            title,
            style: kPrimaryColor,
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              message,
              style: subTitleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
