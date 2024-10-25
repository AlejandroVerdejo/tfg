import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class NormalRichText extends StatelessWidget {
  const NormalRichText({
    super.key,
    required this.theme,
    required this.text,
  });

  final String theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(text: text, style: getStyle("normalTextStyle", theme)));
  }
}
