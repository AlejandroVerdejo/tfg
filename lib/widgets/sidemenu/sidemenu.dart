import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/screens/catalogscreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/screens/profilescreen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors[settings["theme"]]["mainBackgroundColor"],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: colors[settings["theme"]]["headerBackgroundColor"],
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
              color: colors[settings["theme"]]["mainTextColor"],
            ),
            title: Text(
              "Perfil",
              style: styles[settings["theme"]]["sideMenuTextStyle"],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              color: colors[settings["theme"]]["mainTextColor"],
            ),
            title: Text(
              "Catalogo",
              style: styles[settings["theme"]]["sideMenuTextStyle"],
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
              color: colors[settings["theme"]]["mainTextColor"],
            ),
            title: Text(
              "Ajustes",
              style: styles[settings["theme"]]["sideMenuTextStyle"],
            ),
            onTap: () {},
          ),
          // SizedBox(height: double.maxFinite,),
          const Divider(),
          ListTile(
            leading: Icon(
                settings["theme"] == "light" ? Icons.sunny : Icons.nightlight, color: colors[settings["theme"]]["mainTextColor"],),
            title: Text(
              settings["theme"] == "light" ? "Tema: Claro" : "Tema: Oscuro",
              style: styles[settings["theme"]]["sideMenuTextStyle"],
            ),
            onTap: () async {
              settings["theme"] == "light"
                  ? settings["theme"] = "dark"
                  : settings["theme"] = "light";
              log(settings["theme"]);
              // var file = await File("../../conf.dart").writeAsString("");
              setState(() {});
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: colors[settings["theme"]]["mainTextColor"],
            ),
            title: Text(
              "Cerrar sesión",
              style: styles[settings["theme"]]["sideMenuTextStyle"],
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
