import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/management/addbook.dart';
import 'package:tfg_library/management/rentbook.dart';
import 'package:tfg_library/management/users.dart';
import 'package:tfg_library/widgets/catalog/catalog.dart';
import 'package:tfg_library/widgets/profile/profile.dart';
import 'package:tfg_library/widgets/userlists/waitlist.dart';
import 'package:tfg_library/widgets/userlists/wishlist.dart';
import 'package:tfg_library/widgets/home/home.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/sidemenu/sidemenu.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.theme,
    required this.onLogOut,
    required this.onThemeUpdate,
  });

  final Map<String, dynamic> user;
  final String theme;
  final VoidCallback onLogOut;
  final VoidCallback onThemeUpdate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirestoreManager firestoreManager = FirestoreManager();
  Widget? activeWigdet;
  String appBarText = "";
  bool home = true;

  void updateScreen(String screen) {
    var theme = widget.theme;
    switch (screen) {
      case "home":
        activeWigdet = Home(
          theme: theme,
          user: widget.user,
          onScreenChange: updateScreen,
        );
        appBarText = "";
        home = true;
        break;
      case "profile":
        activeWigdet = Profile(
          theme: theme,
          user: widget.user,
        );
        appBarText = getLang("profile");
        home = false;
        break;
      case "users":
        activeWigdet = Users(theme: theme);
        appBarText = getLang("users");
        break;
      case "catalog":
        activeWigdet = Catalog(theme: theme);
        appBarText = getLang("catalog");
        home = false;
        break;
      case "wishlist":
        activeWigdet = WishList(
          theme: theme,
          email: widget.user["email"],
        );
        appBarText = getLang("wishlist");
        home = false;
        break;
      case "waitlist":
        activeWigdet = WaitList(
          theme: theme,
          email: widget.user["email"],
        );
        appBarText = getLang("waitlist");
        home = false;
        break;
      case "addBook":
        activeWigdet = AddBook(
          theme: theme,
        );
        appBarText = getLang("addBook");
        home = false;
        break;
      case "rentBook":
        activeWigdet = RentBook(theme: theme);
        appBarText = getLang("rentBook");
        home = false;
        break;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    activeWigdet = Home(
      theme: widget.theme,
      user: widget.user,
      onScreenChange: updateScreen,
    );
    appBarText = "";
    home = true;
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    var theme = widget.theme;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(
            color: colors[theme]["headerBorderColor"],
            height: 1.5,
          ),
        ),
        foregroundColor: colors[theme]["barTextColor"],
        title: BarText(text: appBarText),
        leading: home
            ? null
            : IconButton(
                onPressed: () {
                  updateScreen("home");
                },
                icon: const Icon(Icons.home),
              ),
        backgroundColor: colors[theme]["headerBackgroundColor"],
      ),
      drawer: SideMenu(
        theme: theme,
        user: user,
        onRefresh: widget.onThemeUpdate,
        onLogOut: widget.onLogOut,
        onScreenChange: updateScreen,
      ),
      backgroundColor: colors[theme]["mainBackgroundColor"],
      body: activeWigdet!,
    );
  }
}
