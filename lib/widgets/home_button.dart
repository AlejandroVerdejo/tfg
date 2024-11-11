import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.theme,
    required this.text,
    required this.icon,
    required this.onClick,
  });

  final String theme;
  final String text;
  final IconData icon;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: getStyle("homeButtonStyle", theme),
      onPressed: onClick,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  size: 100,
                ),
              ),
            ),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}
