import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';
import 'package:tfg_library/widgets/userlists/userbooklistelement.dart';

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
  Future<Map<String, dynamic>> _loadPreferences() async {
    Map<String, dynamic> workers = await firestoreManager.getWorkers();
    return {
      "workers": workers,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadPreferences(),
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
            var theme = widget.theme;
            var workers = data["workers"];
            return Scaffold(
              body: ListView(
                children: [
                  Container(
                    padding: bodyPadding,
                    child: Column(
                      children: [
                        NormalText(theme: theme, text: "Lista de usuarios"),
                        Wrap(
                            spacing: 8.0, // Espacio horizontal entre los chips
                            runSpacing:
                                8.0, // Espacio vertical entre las filas de chips
                            children: workers.map((entry) {
                              log("1");
                              return NormalText(
                                  theme: theme, text: entry.value["email"]);
                            }).toList())
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
