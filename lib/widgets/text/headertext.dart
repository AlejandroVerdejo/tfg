import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/styles.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: styles[settings["theme"]]["headerTextStyle"],
    );
  }
}