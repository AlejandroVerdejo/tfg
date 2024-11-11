import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class HelpTooltip extends StatelessWidget {
  const HelpTooltip({
    super.key,
    required this.theme,
    required this.message,
  });

  final String theme;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: colors[theme]["mainTextColor"], width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.question_mark,
          color: colors[theme]["mainTextColor"],
          size: 16,
        ),
      ),
    );
  }
}
