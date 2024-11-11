import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/book_list_element.dart';
import 'package:tfg_library/widgets/userlists/user_book_list_element.dart';

class BookList extends StatefulWidget {
  const BookList({
    super.key,
    required this.theme,
    required this.books,
    required this.user,
    this.type,
    this.categoriesFilter,
    this.genresFilter,
    this.editorialsFilter,
    this.languagesFilter,
    this.wishList,
    this.waitList,
    this.onRefresh,
    this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> books;
  final Map<String, dynamic> user;
  final String? type;
  final List<String>? categoriesFilter;
  final List<String>? genresFilter;
  final List<String>? editorialsFilter;
  final List<String>? languagesFilter;
  final List<dynamic>? wishList;
  final List<dynamic>? waitList;
  final VoidCallback? onRefresh;
  final Function(String)? onScreenChange;

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  void initState() {
    super.initState();
    titleFilterController.text = "";
  }

  TextEditingController titleFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var orderedBooks = Map.fromEntries(
      widget.books.entries.toList()
        ..sort((b1, b2) {
          // Ordena por disponibilidad de mayor a menor | 1 disponible / 0 no disponible |
          int aviableComp = (b2.value["aviable"] ? 1 : 0)
              .compareTo(b1.value["aviable"] ? 1 : 0);
          // Ordena por nombre si tienen la misma disponibilidad
          if (aviableComp == 0) {
            return b1.value["title"].compareTo(b2.value["title"]);
          }
          return aviableComp;
        }),
    );
    Map<String, dynamic> bookslist;
    bookslist = orderedBooks;
    // Filtrar por libros que se encuentren en la | Wish List | enviada
    if (widget.type == "wishlist") {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) => widget.wishList!.contains(e.key),
        ),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por libros que se encuentren en la | Wait List | enviada
    if (widget.type == "waitlist") {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) => widget.waitList!.contains(e.key),
        ),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por | Categorias |
    if (widget.categoriesFilter != null &&
        widget.categoriesFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) => widget.categoriesFilter!.contains(e.value["category"]),
        ),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por | Generos |
    if (widget.genresFilter != null && widget.genresFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) {
            List<String> bookGenres = List<String>.from(e.value["genres"]);
            return widget.genresFilter!.every(
              (genre) => bookGenres.contains(genre),
            );
          },
        ),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por | Editoriales |
    if (widget.editorialsFilter != null &&
        widget.editorialsFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) => widget.editorialsFilter!.contains(e.value["editorial"]),
        ),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por | Idiomas |
    if (widget.languagesFilter != null && widget.languagesFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) => widget.languagesFilter!.contains(e.value["language"]),
        ),
      );
      bookslist = filteredBooks;
    }

    // Filtrar por | Titulo |
    if (titleFilterController.text.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where(
          (e) => e.value["title"]
              .toLowerCase()
              .contains(titleFilterController.text.toLowerCase()),
        ),
      );
      bookslist = filteredBooks;
    }

    List<MapEntry<String, dynamic>> booklistentries =
        bookslist.entries.toList();
    return Column(
      children: [
        TextSelectionTheme(
          data: getStyle("loginFieldSelectionTheme", theme),
          child: TextField(
            style: getStyle("normalTextStyle", theme),
            controller: titleFilterController,
            decoration: getTextFieldStyle(
              "filterTextFieldStyle",
              theme,
              getLang("editorial"),
              getLang("catalog-hint"),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: booklistentries.map((entry) {
            if (widget.type == "wishlist" || widget.type == "waitlist") {
              return UserBookListElement(
                theme: theme,
                user: widget.user,
                type: widget.type!,
                book: entry.value,
                onDelete: widget.onRefresh!,
              );
            }
            return BookListElement(
              theme: theme,
              user: widget.user,
              type: "book",
              book: entry.value,
              onClose: widget.onRefresh,
              onScreenChange: widget.onScreenChange,
            );
          }).toList(),
        ),
      ],
    );
  }
}
