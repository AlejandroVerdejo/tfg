import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/home/home.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class WaitListReminder extends StatelessWidget {
  const WaitListReminder({
    super.key,
    required this.theme,
    required this.widget,
  });

  final String theme;
  final Home widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: waitlistReminderPadding,
      decoration: BoxDecoration(
        color: colors[theme]["mainBackgroundColorTransparent"],
        border: Border.all(color: colors[theme]["mainTextColor"], width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NormalText(
            theme: theme,
            text: getLang("waitlistReminder"),
            alignment: TextAlign.center,
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              widget.onScreenChange("waitlist");
            },
            child: NormalText(
              theme: theme,
              text: getLang("waitlistShortcut"),
              alignment: TextAlign.center,
              style: getStyle("selectedTextStyle", theme),
            ),
          ),
        ],
      ),
    );
  }
}
