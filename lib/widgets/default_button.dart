import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {super.key,
      required this.theme,
      required this.text,
      required this.onClick,
      this.style});

  final String theme;
  final String text;
  final void Function() onClick;
  final String? style;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: getStyle(style != null ? style! : "defaultButtonStyle", theme),
      onPressed: onClick,
      child: Text(
        text,
      ),
    );
  }
}
