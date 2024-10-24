import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class SelectDialogField extends StatelessWidget {
  const SelectDialogField({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
  });

  final String theme;
  final String item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: isSelected
          ? NormalText(
              theme: theme,
              style: getStyle("selectedTextStyle", theme),
              text: item,
            )
          : NormalText(
              theme: theme,
              text: item,
            ),
    );
  }
}
