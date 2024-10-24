import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class RentText extends StatelessWidget {
  const RentText({
    super.key,
    required this.theme,
    required this.text,
    this.alignment,
  });

  final String theme;
  final String text;
  final TextAlign? alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.5, bottom: 1.5),
      child: Text(
        text,
        style: getStyle("rentTextStyle", theme),
        softWrap: true,
        maxLines: null,
        textAlign: alignment ?? TextAlign.start,
      ),
    );
  }
}
