import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/management/books/add_book.dart';
import 'package:tfg_library/widgets/management/books/edit_book.dart';
import 'package:tfg_library/widgets/management/rents/rent_book.dart';
import 'package:tfg_library/widgets/management/returns/return_book.dart';
import 'package:tfg_library/widgets/management/tags/tags.dart';
import 'package:tfg_library/widgets/management/users/users.dart';
import 'package:tfg_library/widgets/catalog/catalog.dart';
import 'package:tfg_library/widgets/contact/contact.dart';
import 'package:tfg_library/widgets/contact/view_contacts.dart';
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
    required this.widgetTheme,
    required this.onLogOut,
    required this.onThemeUpdate,
  });

  final Map<String, dynamic> user;
  final String widgetTheme;
  final VoidCallback onLogOut;
  final VoidCallback onThemeUpdate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> user = {};

  FirestoreManager firestoreManager = FirestoreManager();
  StorageManager storageManager = StorageManager();
  final GlobalKey<HomeState> homeChildKey = GlobalKey<HomeState>();
  final GlobalKey<ProfileState> profileChildKey = GlobalKey<ProfileState>();
  final GlobalKey<CatalogState> catalogChildKey = GlobalKey<CatalogState>();
  final GlobalKey<WishListState> wishlistChildKey = GlobalKey<WishListState>();
  final GlobalKey<WaitListState> waitlistChildKey = GlobalKey<WaitListState>();
  final GlobalKey<AddBookState> addBookChildKey = GlobalKey<AddBookState>();
  final GlobalKey<EditBookState> editBookChildKey = GlobalKey<EditBookState>();
  final GlobalKey<RentBookState> rentBookChildKey = GlobalKey<RentBookState>();
  final GlobalKey<ReturnBookState> returnBookChildKey =
      GlobalKey<ReturnBookState>();
  final GlobalKey<ContactState> contactChildKey = GlobalKey<ContactState>();
  final GlobalKey<ViewContactsState> viewContactsChildKey =
      GlobalKey<ViewContactsState>();
  final GlobalKey<UsersState> usersChildKey = GlobalKey<UsersState>();
  final GlobalKey<TagsState> tagsChildKey = GlobalKey<TagsState>();

  Widget? activeWigdet;
  String currentWidget = "";
  String appBarText = "";
  String theme = "";

  void updateScreen(String screen) {
    currentWidget = screen;
    String bookId = "";
    if (screen.contains("editBook")) {
      var splitted = screen.split("|");
      screen = splitted[0];
      bookId = splitted[1];
    }
    switch (screen) {
      // ? | INICIO |
      case "home":
        activeWigdet = Home(
          key: homeChildKey,
          theme: theme,
          user: user,
          onScreenChange: updateScreen,
        );
        appBarText = getLang("home");
        break;
      // ? | PERFIL |
      case "profile":
        activeWigdet = Profile(
          key: profileChildKey,
          theme: theme,
          user: user,
          onUpdate: updateUser,
        );
        appBarText = getLang("profile");
        break;
      // ? | USUARIOS |
      case "users":
        activeWigdet = Users(
          key: usersChildKey,
          theme: theme,
          user: user,
        );
        appBarText = getLang("users");
        break;
      // ? | CATALOGO |
      case "catalog":
        activeWigdet = Catalog(
          key: catalogChildKey,
          theme: theme,
          user: user,
          onScreenChange: updateScreen,
        );
        appBarText = getLang("catalog");
        break;
      // ? | LISTA DE DESEADOS |
      case "wishlist":
        activeWigdet = WishList(
          key: wishlistChildKey,
          theme: theme,
          user: user,
          email: user["email"],
        );
        appBarText = getLang("wishlist");
        break;
      // ? | LISTA DE RECORDATORIOS |
      case "waitlist":
        activeWigdet = WaitList(
          key: waitlistChildKey,
          theme: theme,
          user: user,
          email: user["email"],
        );
        appBarText = getLang("waitlist");
        break;
      // ? | AÑADIR LIBROS |
      case "addBook":
        activeWigdet = AddBook(
          key: addBookChildKey,
          theme: theme,
        );
        appBarText = getLang("addBook");
        break;
      // ? | EDITAR LIBRO |
      case "editBook":
        activeWigdet = EditBook(
          key: editBookChildKey,
          theme: theme,
          bookKey: bookId,
          onEdit: updateScreen,
        );
        appBarText = getLang("editBook");
        break;
      // ? | PRESTAMO |
      case "rentBook":
        activeWigdet = RentBook(
          key: rentBookChildKey,
          theme: theme,
        );
        appBarText = getLang("rentBook");
        break;
      // ? | DEVOLUCION |
      case "returnBook":
        activeWigdet = ReturnBook(
          key: returnBookChildKey,
          theme: theme,
        );
        appBarText = getLang("returnBook");
        break;
      // ? | CONTACTAR |
      case "contact":
        activeWigdet = Contact(
          key: contactChildKey,
          theme: theme,
          user: user,
        );
        appBarText = getLang("contactUs");
        break;
      // ? | MENSAJES |
      case "contacts":
        activeWigdet = ViewContacts(
          key: viewContactsChildKey,
          theme: theme,
          user: user,
        );
        appBarText = getLang("contacts");
        break;
      // ? | ETIQUETAS |
      case "tags":
        activeWigdet = Tags(
          key: tagsChildKey,
          theme: theme,
        );
        appBarText = getLang("tags");
        break;
    }
    setState(() {});
  }

  void updateUser() async {
    user = await firestoreManager.getUser(widget.user["email"]);
    widget.user["pfp"] = await storageManager.getPFP(widget.user["email"]);
    setState(() {});
  }

  void updateTheme() async {
    widget.onThemeUpdate();
    theme == "dark" ? theme = "light" : theme = "dark";
    await Future.delayed(const Duration(milliseconds: 50));
    switch (currentWidget) {
      case "home":
        homeChildKey.currentState?.refreshTheme();
        break;
      case "profile":
        profileChildKey.currentState?.refreshTheme();
        break;
      case "catalog":
        catalogChildKey.currentState?.refreshTheme();
        break;
      case "wishlist":
        wishlistChildKey.currentState?.refreshTheme();
        break;
      case "waitlist":
        waitlistChildKey.currentState?.refreshTheme();
        break;
      case "contact":
        contactChildKey.currentState?.refreshTheme();
        break;
      case "contacts":
        viewContactsChildKey.currentState?.refreshTheme();
        break;
      // * Eliminar y hacer estas ventanas de retroceso?
      case "addBook":
        addBookChildKey.currentState?.refreshTheme();
        break;
      case "editBook":
        editBookChildKey.currentState?.refreshTheme();
        break;
      case "rentBook":
        rentBookChildKey.currentState?.refreshTheme();
        break;
      case "returnBook":
        returnBookChildKey.currentState?.refreshTheme();
        break;
      case "tags":
        tagsChildKey.currentState?.refreshTheme();
        break;
      case "users":
        usersChildKey.currentState?.refreshTheme();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    activeWigdet = Home(
      key: homeChildKey,
      theme: widget.widgetTheme,
      user: widget.user,
      onScreenChange: updateScreen,
    );
    user = widget.user;
    appBarText = getLang("home");
    currentWidget = "home";
    theme = widget.widgetTheme;
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: colors[theme]["headerBackgroundColor"],
      ),
      drawer: SideMenu(
        theme: theme,
        user: user,
        onRefresh: updateTheme,
        onLogOut: widget.onLogOut,
        onScreenChange: updateScreen,
      ),
      backgroundColor: colors[theme]["mainBackgroundColor"],
      body: activeWigdet!,
    );
  }
}
