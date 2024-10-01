import 'package:flutter/material.dart';
import 'package:tfg_library/screens/catalogscreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/screens/profilescreen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors["mainBackgroundColor"],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: colors["headerBackgroundColor"],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 40,
                      child: Text(
                        user["username"][0].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 40),
                      )),
                  const SizedBox(height: 10),
                  BarText(text: user["username"]),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              "Perfil",
              style: styles["sideMenuTextStyle"],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(
              "Catalogo",
              style: styles["sideMenuTextStyle"],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CatalogScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              "Ajustes",
              style: styles["sideMenuTextStyle"],
            ),
            onTap: () {},
          ),
          // SizedBox(height: double.maxFinite,),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sunny),
            title: Text(
              "Tema: Claro",
              style: styles["sideMenuTextStyle"],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              "Cerrar sesión",
              style: styles["sideMenuTextStyle"],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
