import 'package:flutter/material.dart';
import 'package:tfg_library/home/popularlistelement.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';

class PopularList extends StatelessWidget {
  const PopularList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var sortedPopularity = Map.fromEntries(popularity.entries.toList()
      ..sort(
        (a, b) => b.value.compareTo(a.value),
      ));

    var popularBooks = sortedPopularity.keys.toList().sublist(0, 3);

    return Padding(
      padding: bodyPadding,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 10,
              children: popularBooks.map<Widget>((popularBook) {
                var book = books[popularBook];
                // return Text("${books[popularBook]["title"]}");
                return PopularListElement(book: book);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
