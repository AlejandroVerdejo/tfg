import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';

class SinopsisBookText extends StatelessWidget {
  const SinopsisBookText({
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
    var formatText = text.replaceAll("<n>", "\n");
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getStyle("normalTitleTextStyle", theme),
          ),
          Opacity(
            opacity: 0.5,
            child: BetterDivider(
              theme: theme,
            ),
          ),
          RichText(
            text: TextSpan(
              text: formatText,
              style: getStyle("normalTextStyle", theme),
            ),
          ),
        ],
      ),
    );
  }
}
