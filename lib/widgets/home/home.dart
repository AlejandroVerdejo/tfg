import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/home/popular_list.dart';
import 'package:tfg_library/widgets/home/wait_list_reminder.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.theme,
    required this.user,
    required this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> user;
  final Function(String) onScreenChange;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<Map<String, dynamic>> _loadData() async {
    List<String> popularBooks = await firestoreManager.getPopularity();
    bool waitListAviability = await firestoreManager
        .checkUserWaitListAviability(widget.user["email"]);
    return {
      "popularBooks": popularBooks,
      "waitListAviability": waitListAviability,
    };
  }

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
    _futureData = _loadData();
  }

  FirestoreManager firestoreManager = FirestoreManager();
  String theme = "";
  Future<Map>? _futureData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Carga
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          // Error
          return const LoadingErrorWidget();
        } else {
          // Ejecucion
          var level = widget.user["level"];
          final data = snapshot.data!;
          var popularBooks = data["popularBooks"];
          var waitListAviability = data["waitListAviability"];
          return ListView(
            children: [
              Container(
                padding: bodyPadding,
                child: Column(
                  children: [
                    waitListAviability && level == 2
                        ? WaitListReminder(theme: theme, widget: widget)
                        : const SizedBox.shrink(),
                    level == 2
                        ? PopularList(theme: theme, popularBooks: popularBooks)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 30),
                    // Crear nuevo prestamo
                    level <= 1
                        ? OutlinedButton(
                            style: getStyle("loginButtonStyle", theme),
                            onPressed: () {
                              widget.onScreenChange("rentBook");
                            },
                            child: NormalText(
                              theme: theme,
                              text: getLang("rentBook"),
                              alignment: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink(),
                    level <= 1
                        ? const SizedBox(height: 30)
                        : const SizedBox.shrink(),

                    // Devolucion
                    level <= 1
                        ? OutlinedButton(
                            style: getStyle("loginButtonStyle", theme),
                            onPressed: () {
                              widget.onScreenChange("returnBook");
                            },
                            child: NormalText(
                              theme: theme,
                              text: getLang("returnBook"),
                              alignment: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink(),
                    level <= 1
                        ? const SizedBox(height: 30)
                        : const SizedBox.shrink(),

                    // Añadir nuevo libro
                    level <= 1
                        ? OutlinedButton(
                            style: getStyle("loginButtonStyle", theme),
                            onPressed: () {
                              widget.onScreenChange("addBook");
                            },
                            child: NormalText(
                              theme: theme,
                              text: getLang("addBook"),
                              alignment: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink(),
                    level <= 1
                        ? const SizedBox(height: 30)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
