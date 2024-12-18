import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/catalog/book_list_element.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/userlists/user_book_list_element.dart';

class UserBookList extends StatefulWidget {
  const UserBookList({
    super.key,
    required this.theme,
    required this.user,
    required this.type,
    this.list,
    this.onRefresh,
  });

  final String theme;
  final Map<String, dynamic> user;
  final String type;
  final List<dynamic>? list;
  final VoidCallback? onRefresh;

  @override
  State<UserBookList> createState() => _UserBookListState();
}

class _UserBookListState extends State<UserBookList> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    Map<String, dynamic> books =
        await firestoreManager.getMergedBooksList(widget.list!);
    return {
      "books": books,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadPreferences(),
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
            var theme = widget.theme;
            var books = data["books"];
            var orderedBooks = Map.fromEntries(
              books.entries.toList()
                ..sort(
                  (b1, b2) {
                    // Ordena por disponibilidad de mayor a menor | 1 disponible / 0 no disponible |
                    int aviableComp = (b2.value["aviable"] ? 1 : 0)
                        .compareTo(b1.value["aviable"] ? 1 : 0);
                    // Ordena por nombre si tienen la misma disponibilidad
                    if (aviableComp == 0) {
                      return b1.value["title"].compareTo(b2.value["title"]);
                    }
                    return aviableComp;
                  },
                ),
            );
            Map<dynamic, dynamic> bookslist;
            bookslist = orderedBooks;
            // Filtrar por libros que se encuentren en la | Wish List | enviada
            if (widget.type == "wishlist") {
              var filteredBooks = Map.fromEntries(
                bookslist.entries.where(
                  (e) => widget.list!.contains(e.key),
                ),
              );
              bookslist = filteredBooks;
            }
            // Filtrar por libros que se encuentren en la | Wait List | enviada
            if (widget.type == "waitlist") {
              var filteredBooks = Map.fromEntries(
                bookslist.entries.where(
                  (e) => widget.list!.contains(e.key),
                ),
              );
              bookslist = filteredBooks;
            }

            List<MapEntry<dynamic, dynamic>> booklistentries =
                bookslist.entries.toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: booklistentries.length,
              itemBuilder: (context, index) {
                var bookentry = booklistentries[index];
                if (widget.type == "wishlist" || widget.type == "waitlist") {
                  return UserBookListElement(
                    theme: theme,
                    user: widget.user,
                    type: widget.type,
                    book: bookentry.value,
                    onDelete: widget.onRefresh!,
                  );
                }
                return BookListElement(
                  theme: theme,
                  user: widget.user,
                  book: bookentry.value,
                  type: widget.type,
                );
              },
            );
          }
        });
  }
}
