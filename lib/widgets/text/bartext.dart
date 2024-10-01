import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/styles.dart';

class BarText extends StatelessWidget {
  const BarText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: styles[settings["theme"]]["barTextStyle"],
    );
  }
}
