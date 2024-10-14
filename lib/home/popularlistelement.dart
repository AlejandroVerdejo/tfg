import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/renttext.dart';

class PopularListElement extends StatelessWidget {
  const PopularListElement({
    super.key,
    required this.book,
  });

  final Map book;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: rentsElementWidth,
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          SizedBox(
            height: rentsElementHeight,
            child: Image.asset(
              "assets/images/books/${book["image_asset"]}",
              width: elementImageSize,
            ),
          ),
          const BetterDivider(),
          RentText(
            text: book["title"],
            alignment: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
