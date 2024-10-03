import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tfg_library/widgets/catalog/book.dart';
import 'package:tfg_library/widgets/text/descriptionrichtext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class BookListElement extends StatelessWidget {
  const BookListElement({
    super.key,
    required this.book,
  });

  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // log("tap");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Book(
                      book: book,
                    )));
      },
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/book.png",
                        width: !kIsWeb && Platform.isAndroid ? 100 : 200,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(text: book["title"]),
                            NormalText(text: book["author"]),
                            NormalText(
                                text: book["aviable"] == 1
                                    ? "Disponible"
                                    : "No disponible"),
                            NormalText(
                                // text: book["genres"].length <= 3
                                //     ? "Generos: ${book["genres"].join(", ")}"
                                //     : "Generos: ${book["genres"].sublist(0, 3).join(", ")}..."),
                                text: book["genres"].join(", ")),
                          ],
                        ),
                      )
                    ],
                  ),
                  DescriptionRichText(text: book["description"]),
                ],
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
