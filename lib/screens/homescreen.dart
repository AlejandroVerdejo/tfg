import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/sidemenu/sidemenu.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

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

    return Scaffold(
      appBar: AppBar(
        foregroundColor: colors["barTextColor"],
        title: const BarText(text: ""),
        backgroundColor: colors["headerBackgroundColor"],
      ),
      drawer: SideMenu(user: user),
      backgroundColor: colors["mainBackgroundColor"],
      body: ListView()
    );
  }
}

