import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class UserListHeader extends StatelessWidget {
  const UserListHeader({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: NormalText(
          theme: theme,
          text: getLang("email"),
          alignment: TextAlign.center,
        )),
        Expanded(
            child: NormalText(
          theme: theme,
          text: getLang("user"),
          alignment: TextAlign.center,
        )),
        Expanded(
            child: NormalText(
          theme: theme,
          text: getLang("state"),
          alignment: TextAlign.center,
        )),
        Expanded(
            child: NormalText(
          theme: theme,
          text: getLang("level"),
          alignment: TextAlign.center,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.list_alt,
                  color: colors[theme]["mainBackgroundColor"],
                )),
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.edit,
                  color: colors[theme]["mainBackgroundColor"],
                )),
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete,
                  color: colors[theme]["mainBackgroundColor"],
                )),
          ],
        ),
      ],
    );
  }
}
