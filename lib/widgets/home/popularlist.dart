import 'package:flutter/material.dart';
import 'package:tfg_library/widgets/home/popularlistelement.dart';
import 'package:tfg_library/styles.dart';

class PopularList extends StatelessWidget {
  const PopularList({
    super.key,
    required this.theme,
    required this.popularBooks,
  });

  final String theme;
  final List<String> popularBooks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bodyPadding,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 10,
              children: popularBooks.map<Widget>((popularBook) {
                // var book = books[popularBook]["00001"];
                return PopularListElement(theme: theme, bookkey: popularBook);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
