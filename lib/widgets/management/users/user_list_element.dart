import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/management/users/user_view_dialog.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

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
    return GestureDetector(
      child: Card(
        color: colors[theme]["secondaryBackgroundColor"],
        elevation: 2,
        child: Padding(
          padding: cardPadding,
          child: isAndroid
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NormalText(
                      theme: theme,
                      text: user["email"],
                      alignment: TextAlign.center,
                    ),
                    NormalText(
                      theme: theme,
                      text: user["username"],
                      alignment: TextAlign.center,
                    ),
                    NormalText(
                      theme: theme,
                      text: user["level"] == 1
                          ? getLang("worker")
                          : getLang("admin"),
                      alignment: TextAlign.center,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: NormalText(
                        theme: theme,
                        text: user["email"],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: NormalText(
                        theme: theme,
                        text: user["username"],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: NormalText(
                        theme: theme,
                        text: user["level"] == 1
                            ? getLang("worker")
                            : getLang("admin"),
                        alignment: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return UserViewDialog(
                theme: theme,
                user: user,
                edit: false,
                onEdit: widget.onDelete,
              );
            });
      },
    );
  }
}
