import 'package:flutter/material.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';

class BookList extends StatelessWidget {
  const BookList({
    super.key,
    this.categoriesFilter,
    this.genresFilter,
    this.editorialsFilter,
    this.languagesFilter,
    this.wishList,
    this.waitList,
  });

  final List<String>? categoriesFilter;
  final List<String>? genresFilter;
  final List<String>? editorialsFilter;
  final List<String>? languagesFilter;
  final List<String>? wishList;
  final List<String>? waitList;

  @override
  Widget build(BuildContext context) {
    var orderedBooks = Map.fromEntries(books.entries.toList()
      ..sort((b1, b2) {
        // Ordena por disponibilidad de mayor a menor | 1 disponible / 0 no disponible |
        // int aviableComp = b2.value["aviable"].compareTo(b1.value["aviable"]);
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
    if (wishList != null && wishList!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where((e) => wishList!.contains(e.key)),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por libros que se encuentren en la | Wait List | enviada
    if (waitList != null && waitList!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(
        bookslist.entries.where((e) => waitList!.contains(e.key)),
      );
      bookslist = filteredBooks;
    }
    // Filtrar por | Categorias |
    if (categoriesFilter != null && categoriesFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries
          .where((e) => categoriesFilter!.contains(e.value["category"])));
      bookslist = filteredBooks;
    }
    // Filtrar por | Generos |
    if (genresFilter != null && genresFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries.where((e) {
        List<String> bookGenres = List<String>.from(e.value["genres"]);
        return genresFilter!.every((genre) => bookGenres.contains(genre));
      }));
      // var filteredBooks = Map.fromEntries(bookslist.entries.where((e) =>
      //     (e.value["genres"] as List)
      //         .every((genre) => genresFilter.contains(genre))));
      bookslist = filteredBooks;
    }
    // Filtrar por | Editoriales |
    if (editorialsFilter != null && editorialsFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries
          .where((e) => editorialsFilter!.contains(e.value["editorial"])));
      bookslist = filteredBooks;
    }
    // Filtrar por | Idiomas |
    if (languagesFilter != null && languagesFilter!.isNotEmpty) {
      var filteredBooks = Map.fromEntries(bookslist.entries
          .where((e) => languagesFilter!.contains(e.value["language"])));
      bookslist = filteredBooks;
    }
    List<MapEntry<String, dynamic>> booklistentries =
        bookslist.entries.toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: booklistentries.length,
      // ignore: body_might_complete_normally_nullable
      itemBuilder: (context, index) {
        var bookentry = booklistentries[index];
        return BookListElement(book: bookentry.value);
      },
    );
  }
}
