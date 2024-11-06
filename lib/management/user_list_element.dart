import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/user_view_dialog.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';

class UserListElement extends StatefulWidget {
  const UserListElement({
    super.key,
    required this.theme,
    required this.user,
    required this.onDelete,
  });

  final String theme;
  final Map<String, dynamic> user;
  final VoidCallback onDelete;

  @override
  State<UserListElement> createState() => _UserListElementState();
}

class _UserListElementState extends State<UserListElement> {
  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var user = widget.user;
    return Row(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ? Ver
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserViewDialog(
                          theme: theme,
                          user: user,
                          edit: false,
                        );
                      });
                },
                icon: Icon(
                  Icons.list_alt,
                  color: colors[theme]["mainTextColor"],
                )),
            // ? Editar
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserViewDialog(
                          theme: theme,
                          user: user,
                          edit: true,
                          onEdit: widget.onDelete,
                        );
                      });
                },
                icon: Icon(
                  Icons.edit,
                  color: colors[theme]["mainTextColor"],
                )),
            // ? Eliminar
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteDialog(
                          theme: theme,
                          title: getLang("deleteUser"),
                          message: getLang("confirmation"),
                          onAccept: () async {
                            await firestoreManager.deleteUser(user["email"]);
                            widget.onDelete();
                          },
                        );
                      });
                },
                icon: Icon(
                  Icons.delete,
                  color: colors[theme]["mainTextColor"],
                )),
          ],
        )
      ],
    );
  }
}
