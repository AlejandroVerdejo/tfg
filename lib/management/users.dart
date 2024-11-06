import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/add_user_dialog.dart';
import 'package:tfg_library/management/user_list.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class Users extends StatefulWidget {
  const Users({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  void _onUserAdded(Map user) async {
    setState(() {});
  }

  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return ListView(
      children: [
        Container(
          padding: bodyPadding,
          child: Column(
            children: [
              NormalText(theme: theme, text: getLang("users")),
              const SizedBox(height: 20),
              UserList(theme: theme),
              const SizedBox(height: 20),
              OutlinedButton(
                style: getStyle("loginButtonStyle", theme),
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddUserDialog(
                          theme: theme,
                          onUserAdded: _onUserAdded,
                        );
                      });
                },
                child: NormalText(
                  theme: theme,
                  text: getLang("addUser"),
                  alignment: TextAlign.center,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
