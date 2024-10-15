import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/home/popularlistelement.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';

class PopularList extends StatelessWidget {
  const PopularList({
    super.key,
    required this.popularBooks,
  });

  final List<String> popularBooks;

  @override
  Widget build(BuildContext context) {
    // var sortedPopularity = Map.fromEntries(popularity.entries.toList()
    //   ..sort(
    //     (a, b) => b.value.compareTo(a.value),
    //   ));

    // var popularBooks = sortedPopularity.keys.toList().sublist(0, 3);

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
                return PopularListElement(bookkey: popularBook);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
