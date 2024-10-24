
import 'package:flutter/material.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';
import 'package:tfg_library/widgets/userlists/userbooklistelement.dart';

class BookList extends StatefulWidget {
  const BookList({
    super.key,
    required this.theme,
    required this.books,
    this.type,
    this.categoriesFilter,
    this.genresFilter,
    this.editorialsFilter,
    this.languagesFilter,
    this.wishList,
    this.waitList,
    this.onRefresh,
  });

  final String theme;
  final Map<String, dynamic> books;
  final String? type;
  final List<String>? categoriesFilter;
  final List<String>? genresFilter;
  final List<String>? editorialsFilter;
  final List<String>? languagesFilter;
  final List<dynamic>? wishList;
  final List<dynamic>? waitList;
  final VoidCallback? onRefresh;

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var orderedBooks = Map.fromEntries(widget.books.entries.toList()
      ..sort((b1, b2) {
        // Ordena por disponibilidad de mayor a menor | 1 disponible / 0 no disponible |
        int aviableComp = (b2.value["aviable"] ? 1 : 0)
            .compareTo(b1.value["aviable"] ? 1 : 0);
        // Ordena por nombre si tienen la misma disponibilidad
        if (aviableComp == 0) {
          return b1.value["title"].compareTo(b2.value["title"]);
        }
        return aviableComp;
      }));
    Map<String, dynamic> bookslist;
    bookslist = orderedBooks;
    // Filtrar por libros que se encuentren en la | Wish List | enviada
    if (widget.type == "wishlist") {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where((e) => widget.wishList!.contains(e.key)),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por libros que se encuentren en la | Wait List | enviada
    if (widget.type == "waitlist") {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where((e) => widget.waitList!.contains(e.key)),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por | Categorias |
    if (widget.categoriesFilter != null &&
        widget.categoriesFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries.where(
          (e) => widget.categoriesFilter!.contains(e.value["category"])));
      bookslist = filteredBooks;
    }
    // Filtrar por | Generos |
    if (widget.genresFilter != null && widget.genresFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries.where((e) {
        List<String> bookGenres = List<String>.from(e.value["genres"]);
        return widget.genresFilter!
            .every((genre) => bookGenres.contains(genre));
      }));
      bookslist = filteredBooks;
    }
    // Filtrar por | Editoriales |
    if (widget.editorialsFilter != null &&
        widget.editorialsFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries.where(
          (e) => widget.editorialsFilter!.contains(e.value["editorial"])));
      bookslist = filteredBooks;
    }
    // Filtrar por | Idiomas |
    if (widget.languagesFilter != null && widget.languagesFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries
          .where((e) => widget.languagesFilter!.contains(e.value["language"])));
      bookslist = filteredBooks;
    }
    List<MapEntry<String, dynamic>> booklistentries =
        bookslist.entries.toList();

    return Wrap(
        spacing: 8.0, // Espacio horizontal entre los chips
        runSpacing: 8.0, // Espacio vertical entre las filas de chips
        children: booklistentries.map((entry) {
          if (widget.type == "wishlist" || widget.type == "waitlist") {
            return UserBookListElement(
              theme: theme,
              type: widget.type!,
              book: entry.value,
              onDelete: widget.onRefresh!,
            );
          }
          return BookListElement(
            theme: theme,
            book: entry.value,
          );
        }).toList());
  }
}
