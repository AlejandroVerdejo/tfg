import 'package:flutter/material.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';

class BookList extends StatelessWidget {
  const BookList({
    super.key,
    required this.filter,
  });

  final List<String> filter;

  @override
  Widget build(BuildContext context) {
    books.sort((b, a) => a["aviable"].compareTo(b["aviable"]));
    List<Map<String, dynamic>> bookslist;
    if (filter.isNotEmpty) {
      List<Map<String, dynamic>> filteredbooks = books.where((map) {
        var genres = map["genres"];
        return genres.any((genre) => filter.contains(genre));
      }).toList();
      bookslist = filteredbooks;
    } else {
      bookslist = books;
    }

    return ListView.builder(
      itemCount: bookslist.length,
      // ignore: body_might_complete_normally_nullable
      itemBuilder: (context, index) => BookListElement(
        book: bookslist[index],
      ),
    );
  }
}
