import 'package:flutter/material.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';

class BookList extends StatelessWidget {
  const BookList({
    super.key,
    required this.categoriesFilter,
    required this.genresFilter,
    required this.editorialsFilter,
    required this.languagesFilter,
  });

  final List<String> categoriesFilter;
  final List<String> genresFilter;
  final List<String> editorialsFilter;
  final List<String> languagesFilter;

  @override
  Widget build(BuildContext context) {
    books.sort((a, b) {
      int aviableComp = b["aviable"].compareTo(a["aviable"]);
      if (aviableComp != 0) {
        return aviableComp;
      }
      return a["title"].compareTo(b["title"]);
    });
    List<Map<String, dynamic>> bookslist;
    bookslist = books;
    // Filtrar por | Categorias |
    if (categoriesFilter.isNotEmpty) {
      List<Map<String, dynamic>> filteredbooks = bookslist.where((map) {
        return categoriesFilter.contains((map["category"]));
      }).toList();
      bookslist = filteredbooks;
    }
    // Filtrar por | Generos |
    if (genresFilter.isNotEmpty) {
      List<Map<String, dynamic>> filteredbooks = bookslist.where((map) {
        var genres = map["genres"];
        return genresFilter.every((genre) => genres.contains(genre));
      }).toList();
      bookslist = filteredbooks;
    }
    // Filtrar por | Editoriales |
    if (editorialsFilter.isNotEmpty) {
      List<Map<String, dynamic>> filteredbooks = bookslist.where((map) {
        return editorialsFilter.contains((map["editorial"]));
      }).toList();
      bookslist = filteredbooks;
    }    
    // Filtrar por | Idiomas |
    if (languagesFilter.isNotEmpty) {
      List<Map<String, dynamic>> filteredbooks = bookslist.where((map) {
        return languagesFilter.contains((map["language"]));
      }).toList();
      bookslist = filteredbooks;
    }    

    return ListView.builder(
      shrinkWrap: true,
      itemCount: bookslist.length,
      // ignore: body_might_complete_normally_nullable
      itemBuilder: (context, index) => BookListElement(
        book: bookslist[index],
      ),
    );
  }
}
