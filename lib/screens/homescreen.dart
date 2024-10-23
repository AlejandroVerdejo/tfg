import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/management/addbook.dart';
import 'package:tfg_library/management/rentbook.dart';
import 'package:tfg_library/screens/waitlistscreen.dart';
import 'package:tfg_library/widgets/home/popularlist.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/sidemenu/sidemenu.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.onLogOut,
  });

  final Map<String, dynamic> user;
  final VoidCallback onLogOut;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Metodo para obtener la preferencia del tema
  Future<Map<String, dynamic>> _loadData() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme")!; // Valor predeterminado
    List<String> popularBooks = await firestoreManager.getPopularity();
    bool waitListAviability = await firestoreManager
        .checkUserWaitListAviability(widget.user["email"]);
    // Devuelve un mapa con los datos
    return {
      "theme": theme,
      "popularBooks": popularBooks,
      "waitListAviability": waitListAviability,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  void _updateTheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;

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
          final data = snapshot.data!;
          var theme = data["theme"];
          var popularBooks = data["popularBooks"];
          var waitListAviability = data["waitListAviability"];
          var level = user["level"];
          return Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.5),
                  child: Container(
                    color: colors[theme]["headerBorderColor"],
                    height: 1.5,
                  )),
              foregroundColor: colors[theme]["barTextColor"],
              title: const BarText(text: ""),
              backgroundColor: colors[theme]["headerBackgroundColor"],
            ),
            drawer: SideMenu(
              user: user,
              onRefresh: _updateTheme,
              onLogOut: widget.onLogOut,
            ),
            backgroundColor: colors[theme]["mainBackgroundColor"],
            body: Padding(
              padding: bodyPadding,
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  NormalText(
                    text: getLang("popularBooks"),
                    alignment: TextAlign.center,
                  ),
                  PopularList(popularBooks: popularBooks),
                  waitListAviability
                      ? Container(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                                text:
                                    "Hay libros de tus recordatorios disponibles",
                                alignment: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WaitListScreen(
                                        email: widget.user["email"],
                                      ),
                                    ),
                                  );
                                },
                                child: NormalText(
                                  text: "Pulsa aqui para ver tus recordatorios",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RentBook(),
                              ),
                            );
                          },
                          child: NormalText(
                            text: "Nuevo prestamo",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBook(),
                              ),
                            );
                          },
                          child: NormalText(
                            text: "Nuevo libro",
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
          );
        }
      },
    );
  }
}
