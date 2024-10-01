import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class DescriptionRichText extends StatelessWidget {
  const DescriptionRichText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.fade,
        text: TextSpan(text: text, style: styles["descriptionRichTextStyle"]));
  }
}
