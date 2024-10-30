import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class UserListElement extends StatelessWidget {
  const UserListElement({
    super.key,
    required this.theme,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("taptap");
      },
      child: Row(
        children: [
          Expanded(
              child: NormalText(
            theme: theme,
            text: user["email"],
            alignment: TextAlign.center,
          )),
          Expanded(
              child: NormalText(
            theme: theme,
            text: user["username"],
            alignment: TextAlign.center,
          )),
          Expanded(
              child: NormalText(
            theme: theme,
            text: user["active"] ? getLang("active") : getLang("notActive"),
            alignment: TextAlign.center,
          )),
          Expanded(
              child: NormalText(
            theme: theme,
            text: user["level"] == 1 ? getLang("worker") : getLang("admin"),
            alignment: TextAlign.center,
          )),
          Expanded(
            child: IconButton(
                onPressed: () {
                  log("del - ${user["email"]}");
                },
                icon: Icon(
                  Icons.delete,
                  color: colors[theme]["mainTextColor"],
                )),
          )
        ],
      ),
    );
  }
}
