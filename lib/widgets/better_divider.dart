import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class BetterDivider extends StatelessWidget {
  const BetterDivider({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: colors[theme]["dividerColor"],
    );
  }
}
