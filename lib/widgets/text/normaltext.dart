import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class NormalText extends StatelessWidget {
  const NormalText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: styles["normalTextStyle"],
    );
  }
}
