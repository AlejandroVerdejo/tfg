import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class BetterVerticalDivider extends StatelessWidget {
  const BetterVerticalDivider({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: 2,
        height: verticalDividerHeight,
        color: colors[theme]["dividerColor"],
      ),
    );
  }
}
