import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class DeleteBookListDialog extends StatefulWidget {
  const DeleteBookListDialog({
    super.key,
    required this.theme,
    required this.title,
    required this.message,
    required this.onAccept,
  });

  final String theme;
  final String title;
  final String message;
  final VoidCallback onAccept;

  @override
  State<DeleteBookListDialog> createState() => _DeleteBookListDialogState();
}

class _DeleteBookListDialogState extends State<DeleteBookListDialog> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return AlertDialog(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      title: NormalText(theme: theme, text: widget.title),
      content: NormalText(theme: theme, text: widget.message),
      actions: [
        TextButton(
          onPressed: () {
            // Navigator.of(context).pop();
            Navigator.pop(context, false);
          },
          child: NormalText(
            theme: theme,
            text: getLang("deleteBookListDialog-false"),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onAccept();
            // Navigator.of(context).pop();
            Navigator.pop(context, true);
          },
          child: NormalText(
            theme: theme,
            text: getLang("deleteBookListDialog-true"),
          ),
        ),
      ],
    );
  }
}
