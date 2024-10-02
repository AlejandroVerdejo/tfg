import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/screens/catalogscreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/screens/profilescreen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.user,
    required this.onRefresh,
  });

  final Map<String, dynamic> user;
  final VoidCallback onRefresh;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
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
            return Drawer(
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color: colors[data["theme"]]["headerBackgroundColor"],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              child: Text(
                                widget.user["username"][0].toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 40),
                              )),
                          const SizedBox(height: 10),
                          BarText(text: widget.user["username"]),
                        ],
                      )),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: colors[data["theme"]]["mainTextColor"],
                    ),
                    title: Text(
                      "Perfil",
                      style: getStyle("sideMenuTextStyle", data["theme"]!),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(user: widget.user)));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.book,
                      color: colors[data["theme"]]["mainTextColor"],
                    ),
                    title: Text(
                      "Catalogo",
                      style: getStyle("sideMenuTextStyle", data["theme"]!),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CatalogScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: colors[data["theme"]]["mainTextColor"],
                    ),
                    title: Text(
                      "Ajustes",
                      style: getStyle("sideMenuTextStyle", data["theme"]!),
                    ),
                    onTap: () {},
                  ),
                  // SizedBox(height: double.maxFinite,),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      data["theme"] == "light" ? Icons.sunny : Icons.nightlight,
                      color: colors[data["theme"]]["mainTextColor"],
                    ),
                    title: Text(
                      data["theme"] == "light" ? "Tema Claro" : "Tema Oscuro",
                      style: getStyle("sideMenuTextStyle", data["theme"]!),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String theme = prefs.getString("theme") ?? "light";
                      theme == "light"
                          ? await prefs.setString("theme", "dark")
                          : await prefs.setString("theme", "light");
                      setState(() {});
                      widget.onRefresh();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: colors[data["theme"]]["mainTextColor"],
                    ),
                    title: Text(
                      "Cerrar sesión",
                      style: getStyle("sideMenuTextStyle", data["theme"]!),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                  ),
                ],
              ),
            );
          }
        });
  }
}
