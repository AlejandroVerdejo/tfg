import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/book_list.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';

class WishList extends StatefulWidget {
  const WishList({
    super.key,
    required this.theme,
    required this.user,
    required this.email,
  });

  final String theme;
  final Map<String, dynamic> user;
  final String email;

  @override
  State<WishList> createState() => WishListState();
}

class WishListState extends State<WishList> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> books = await firestoreManager.getMergedBooks();
    List<dynamic> wishlist =
        await firestoreManager.getUserWishList(widget.email);
    // Devuelve un mapa con los datos
    return {
      "books": books,
      "wishlist": wishlist,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  String theme = "";

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Carga
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          // Error
          return const LoadingErrorWidget();
        } else {
          // Ejecucion
          final data = snapshot.data!;
          var books = data["books"];
          var wishlist = data["wishlist"];
          return ListView(
            children: [
              Container(
                padding: bodyPadding,
                child: BookList(
                  theme: theme,
                  user: widget.user,
                  books: books,
                  type: "wishlist",
                  wishList: wishlist,
                  onRefresh: _update,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
