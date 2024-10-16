import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/booklist.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  Future<Map<String, dynamic>> _loadData() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme") ?? "dark"; // Valor predeterminado
    Map<String, dynamic> books = await firestoreManager.getMergedBooks();
    List<dynamic> wishlist =
        await firestoreManager.getUserWishList(widget.email);
    // Devuelve un mapa con los datos
    return {
      "theme": theme,
      "books": books,
      "wishlist": wishlist,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  void _update() {
    log("Log: update");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            // Ejecucion
            final data = snapshot.data!;
            var theme = data["theme"];
            var wishlist = data["wishlist"];
            return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.5),
                    child: Container(
                      color: colors[theme]["headerBorderColor"],
                      height: 1.5,
                    )),
                foregroundColor: colors[theme]["barTextColor"],
                title: BarText(
                  text: getLang("wishlist"),
                ),
                backgroundColor: colors[theme]["headerBackgroundColor"],
              ),
              backgroundColor: colors[theme]["mainBackgroundColor"],
              body: Padding(
                padding: bodyPadding,
                child: BookList(
                  books: data["books"],
                  type: "wishlist",
                  wishList: wishlist,
                  onRefresh: _update,
                ),
              ),
            );
          }
        });
  }
}
