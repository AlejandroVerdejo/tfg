import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/booklist.dart';

class WishList extends StatefulWidget {
  const WishList({
    super.key,
    required this.theme,
    required this.email,
  });

  final String theme;
  final String email;

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
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
          var theme = widget.theme;
          var books = data["books"];
          var wishlist = data["wishlist"];
          return ListView(
            children: [
              Container(
                padding: bodyPadding,
                child: BookList(
                  theme: theme,
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
