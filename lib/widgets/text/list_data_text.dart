import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class ListDataText extends StatelessWidget {
  const ListDataText({
    super.key,
    required this.theme,
    required this.title,
    required this.text,
  });

  final String theme;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: RichText(
        text: TextSpan(
          text: "$title: ",
          style: getStyle("normalTitleTextStyle", theme),
          children: [
            TextSpan(
              text: text,
              style: getStyle("normalTextStyle", theme),
            )
          ],
        ),
      ),
    );
  }
}
