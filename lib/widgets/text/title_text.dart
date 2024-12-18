import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.theme,
    required this.text,
    this.alignment,
    this.style,
  });

  final String theme;
  final String text;
  final TextAlign? alignment;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.5, bottom: 1.5),
      child: Text(
        text,
        style: style ?? getStyle("titleTextStyle", theme),
        softWrap: true,
        maxLines: null,
        textAlign: alignment ?? TextAlign.start,
      ),
    );
  }
}
