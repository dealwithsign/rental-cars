// presentation/widgets/context_menu.dart
import 'package:flutter/material.dart';

import '../../utils/fonts.dart';

class ContextMenu extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final TextStyle kPrimaryColor;
  final TextStyle subTitleTextStyle;

  const ContextMenu({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
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
            size: MediaQuery.of(context).size.width * 0.1,
          ),
          SizedBox(height: defaultMargin * 2),
          Text(
            title,
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: defaultMargin / 2),
          Center(
            child: Text(
              message,
              style: subTitleTextStyle.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
