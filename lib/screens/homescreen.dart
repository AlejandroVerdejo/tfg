import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/home/popularlist.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/sidemenu/sidemenu.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final Map<String, dynamic> user;
  // final String? theme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Metodo para obtener la preferencia del tema
  Future<Map<String, dynamic>> _loadData() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme") ?? "light"; // Valor predeterminado
    List<String> popularBooks = await firestoreManager.getPopularity();
    // Devuelve un mapa con los datos
    return {
      "theme": theme,
      // "popularBooks": popularBooks,
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
            // _getBooks();
            // Future<Map<String, dynamic>> map = firestoreManager.getBooks();
            return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.5),
                    child: Container(
                      color: colors[data["theme"]]["headerBorderColor"],
                      height: 1.5,
                    )),
                foregroundColor: colors[data["theme"]]["barTextColor"],
                title: const BarText(text: ""),
                backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
              ),
              drawer: SideMenu(
                user: user,
                onRefresh: _updateTheme,
              ),
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              body: Padding(
                padding: bodyPadding,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    NormalText(text: getLang("popularBooks")),
                    // PopularList(popularBooks: data["popularBooks"]),
                    // NormalText(text: data["books"].toString())
                  ],
                ),
              ),
            );
          }
        });
  }
}
