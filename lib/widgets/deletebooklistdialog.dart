import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class DeleteBookListDialog extends StatefulWidget {
  const DeleteBookListDialog({
    super.key,
    required this.onAccept,
  });

  final VoidCallback onAccept;

  @override
  State<DeleteBookListDialog> createState() => _DeleteBookListDialogState();
}

class _DeleteBookListDialogState extends State<DeleteBookListDialog> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    return {"theme": theme};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Carga
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Error
            return const Center(
              child: Text("Error"),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var theme = data["theme"];
            return AlertDialog(
              backgroundColor: colors[theme]["mainBackgroundColor"],
              title: NormalText(text: getLang("deleteBookListDialog-title")),
              content:
                  NormalText(text: getLang("deleteBookListDialog-content")),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: NormalText(
                        text: getLang("deleteBookListDialog-false"))),
                TextButton(
                    onPressed: () {
                      log("Eliminar");
                      widget.onAccept();
                      Navigator.of(context).pop();
                    },
                    child:
                        NormalText(text: getLang("deleteBookListDialog-true"))),
              ],
            );
          }
        });
  }
}
