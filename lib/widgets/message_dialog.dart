import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class MessageDialog extends StatefulWidget {
  const MessageDialog({
    super.key,
    required this.theme,
    required this.message,
  });

  final String theme;
  final String message;

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return AlertDialog(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      content: NormalText(theme: theme, text: widget.message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: NormalText(
            theme: theme,
            text: getLang("accept"),
          ),
        ),
      ],
    );
  }
}
