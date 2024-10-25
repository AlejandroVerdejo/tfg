import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class DescriptionRichText extends StatelessWidget {
  const DescriptionRichText({
    super.key,
    required this.theme,
    required this.text,
  });

  final String theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    var formatText = text.replaceAll("<n>", "\n");
    return RichText(
      textAlign: TextAlign.left,
      maxLines: 3,
      overflow: TextOverflow.fade,
      text: TextSpan(
        text: formatText,
        style: getStyle("descriptionRichTextStyle", theme),
      ),
    );
  }
}
