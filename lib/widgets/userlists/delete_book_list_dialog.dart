
import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class DeleteBookListDialog extends StatefulWidget {
  const DeleteBookListDialog({
    super.key,
    required this.theme,
    required this.onAccept,
  });

  final String theme;
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
      title:
          NormalText(theme: theme, text: getLang("deleteBookListDialog-title")),
      content: NormalText(
          theme: theme, text: getLang("deleteBookListDialog-content")),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: NormalText(
            theme: theme,
            text: getLang("deleteBookListDialog-false"),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onAccept();
            Navigator.of(context).pop();
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
