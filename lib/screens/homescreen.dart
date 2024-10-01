import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/sidemenu/sidemenu.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user;

    String platform = "";

    if (kIsWeb) {
      platform = "Browser";
    } else {
      if (Platform.isAndroid) {
        platform = "Android";
      }
      if (Platform.isWindows) {
        platform = "Windows";
      }
      if (Platform.isFuchsia) {
        platform = "Fuchsia";
      }
    }

    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.5),
              child: Container(
                color: colors[settings["theme"]]["headerBorderColor"],
                height: 1.5,
              )),
          foregroundColor: colors[settings["theme"]]["barTextColor"],
          title: const BarText(text: ""),
          backgroundColor: colors[settings["theme"]]["headerBackgroundColor"],
        ),
        drawer: SideMenu(user: user),
        backgroundColor: colors[settings["theme"]]["mainBackgroundColor"],
        body: NormalText(text: platform));
  }
}
