import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/profile/profileheader.dart';
import 'package:tfg_library/widgets/profile/profilerentslist.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Metodo para obtener la preferencia del tema
  Future<Map<String, dynamic>> _loadData() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme") ?? "dark"; // Valor predeterminado
    Map<String, dynamic> books = await firestoreManager.getMergedBooks();
    List<dynamic> rents =
        await firestoreManager.getUserRents(widget.user["email"]);
    // Devuelve un mapa con los datos
    return {
      "theme": theme,
      "books": books,
      "rents": rents,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

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
            // child: Text(getLang("error")),
            child: Text(snapshot.error.toString()),
          );
        } else {
          final data = snapshot.data!;
          var theme = data["theme"];
          var rents = data["rents"];
          List activeRents = [];
          if (rents.length > 0) {
            activeRents = (rents as List<dynamic>)
                .where((rent) => rent["active"] == true)
                .toList();
          }
          return Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.5),
                  child: Container(
                    color: colors[theme]["headerBorderColor"],
                    height: 1.5,
                  )),
              foregroundColor: colors[theme]["barTextColor"],
              title: BarText(text: getLang("profile")),
              backgroundColor: colors[theme]["headerBackgroundColor"],
            ),
            backgroundColor: colors[theme]["mainBackgroundColor"],
            body: ListView(
              shrinkWrap: true,
              children: [
                ProfileHeader(user: user),
                ProfileRentsList(
                  activeRents: activeRents,
                  data: data,
                )
              ],
            ),
          );
        }
      },
    );
  }
}
