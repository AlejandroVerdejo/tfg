import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/management/add_book.dart';
import 'package:tfg_library/management/edit_book.dart';
import 'package:tfg_library/management/rent_book.dart';
import 'package:tfg_library/management/return_book.dart';
import 'package:tfg_library/management/users.dart';
import 'package:tfg_library/widgets/catalog/catalog.dart';
import 'package:tfg_library/widgets/profile/profile.dart';
import 'package:tfg_library/widgets/userlists/wait_list.dart';
import 'package:tfg_library/widgets/userlists/wish_list.dart';
import 'package:tfg_library/widgets/home/home.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/sidemenu/side_menu.dart';
import 'package:tfg_library/widgets/text/bar_text.dart';

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
  Map<String, dynamic> user = {};

  FirestoreManager firestoreManager = FirestoreManager();
  StorageManager storageManager = StorageManager();
  Widget? activeWigdet;
  String appBarText = "";
  bool home = true;

  void updateScreen(String screen) {
    String bookId = "";
    if (screen.contains("editBook")) {
      var splitted = screen.split("|");
      screen = splitted[0];
      bookId = splitted[1];
    }
    var theme = widget.theme;
    switch (screen) {
      // ? | INICIO |
      case "home":
        activeWigdet = Home(
          theme: theme,
          user: user,
          onScreenChange: updateScreen,
        );
        appBarText = "";
        home = true;
        break;
      // ? | PERFIL |
      case "profile":
        activeWigdet = Profile(
          theme: theme,
          user: user,
          onUpdate: updateUser,
        );
        appBarText = getLang("profile");
        home = false;
        break;
      // ? | USUARIOS |
      case "users":
        activeWigdet = Users(theme: theme);
        appBarText = getLang("users");
        home = false;
        break;
      // ? | CATALOGO |
      case "catalog":
        activeWigdet = Catalog(
          theme: theme,
          user: user,
          onScreenChange: updateScreen,
        );
        appBarText = getLang("catalog");
        home = false;
        break;
      // ? | LISTA DE DESEADOS |
      case "wishlist":
        activeWigdet = WishList(
          theme: theme,
          user: user,
          email: user["email"],
        );
        appBarText = getLang("wishlist");
        home = false;
        break;
      // ? | LISTA DE RECORDATORIOS |
      case "waitlist":
        activeWigdet = WaitList(
          theme: theme,
          user: user,
          email: user["email"],
        );
        appBarText = getLang("waitlist");
        home = false;
        break;
      // ? | AÑADIR LIBROS |
      case "addBook":
        activeWigdet = AddBook(
          theme: theme,
        );
        appBarText = getLang("addBook");
        home = false;
        break;
      // ? | EDITAR LIBRO |
      case "editBook":
        activeWigdet = EditBook(
          theme: theme,
          bookKey: bookId,
          onEdit: updateScreen,
        );
        appBarText = getLang("editBook");
        break;
      // ? | PRESTAMO |
      case "rentBook":
        activeWigdet = RentBook(theme: theme);
        appBarText = getLang("rentBook");
        home = false;
        break;
      // ? | DEVOLUCION |
      case "returnBook":
        activeWigdet = ReturnBook(theme: theme);
        appBarText = getLang("returnBook");
        home = false;
    }
    setState(() {});
  }

  void updateUser() async {
    log("refresh");
    user = await firestoreManager.getUser(widget.user["email"]);
    widget.user["pfp"] = await storageManager.getPFP(widget.user["email"]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // activeWigdet = Home(
    //   theme: widget.theme,
    //   user: widget.user,
    //   onScreenChange: updateScreen,
    // );
    user = widget.user;
    activeWigdet = Profile(
      theme: widget.theme,
      user: user,
      onUpdate: updateUser,
    );
    appBarText = "";
    // home = true;
    home = false;
  }

  @override
  Widget build(BuildContext context) {
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
