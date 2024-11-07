import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';

class RentDateText extends StatelessWidget {
  const RentDateText({
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
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // String formattedTime = DateFormat('HH:mm').format(now);
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime actualDate = format.parse(formattedDate);
    DateTime rentDate = format.parse(text);
    bool passed = rentDate.isBefore(actualDate) ? true : false;
    return Padding(
      padding: const EdgeInsets.only(top: 1.5, bottom: 1.5),
      child: Text(
        "$text\n(${rentDate.difference(actualDate).inDays} ${getLang("rentDifDays")})",
        style: passed
            ? getStyle("passedRentTextStyle", theme)
            : getStyle("rentTextStyle", theme),
        softWrap: true,
        maxLines: null,
        textAlign: alignment ?? TextAlign.start,
      ),
    );
  }
}
