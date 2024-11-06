import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/home/popular_list.dart';
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
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map<String, dynamic>> _loadData() async {
    List<String> popularBooks = await firestoreManager.getPopularity();
    bool waitListAviability = await firestoreManager
        .checkUserWaitListAviability(widget.user["email"]);
    return {
      "popularBooks": popularBooks,
      "waitListAviability": waitListAviability,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

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
          return Center(
            child: Text(getLang("error")),
          );
        } else {
          // Ejecucion
          var theme = widget.theme;
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
                    const SizedBox(height: 30),
                    NormalText(
                      theme: theme,
                      text: getLang("popularBooks"),
                      alignment: TextAlign.center,
                    ),
                    PopularList(theme: theme, popularBooks: popularBooks),
                    waitListAviability && level == 2
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 80, top: 30, right: 80, bottom: 30),
                            decoration: BoxDecoration(
                              color: colors[theme]
                                  ["mainBackgroundColorTransparent"],
                              border: Border.all(
                                  color: colors[theme]["mainTextColor"],
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                NormalText(
                                  theme: theme,
                                  text: getLang("waitlistReminder"),
                                  alignment: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    widget.onScreenChange("waitlist");
                                  },
                                  child: NormalText(
                                    theme: theme,
                                    text: getLang("waitlistShortcut"),
                                    alignment: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
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
