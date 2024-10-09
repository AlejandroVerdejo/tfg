import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<Map<String, dynamic>> _loadPreferences() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme") ?? "light"; // Valor predeterminado
    // Devuelve un mapa con las preferencias
    return {"theme": theme};
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
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
          final data = snapshot.data!;
          List activeRents = [];
          if (user["rents"].length > 0) {
            // var activeRents = user["rents"].where((rent) => rent["active"]).toList();
            activeRents = (user["rents"] as List<Map<String, dynamic>>)
                .where((rent) => rent["active"] == true)
                .toList();
          }
          // var rentsId = user["rents"] as List<String>;
          return Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.5),
                  child: Container(
                    color: colors[data["theme"]]["headerBorderColor"],
                    height: 1.5,
                  )),
              foregroundColor: colors[data["theme"]]["barTextColor"],
              title: BarText(text: getLang("profile")),
              backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
            ),
            backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
            body: ListView(
              shrinkWrap: true,
              children: [
                ProfileHeader(user: user),
                ProfileRentsList(activeRents: activeRents, data: data)
              ],
            ),
          );
        }
      },
    );
  }
}
