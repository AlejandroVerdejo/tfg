import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
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
      child: Opacity(
        opacity: book["aviable"] == 0 ? 0.5 : 1,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Image.asset(
                          "assets/images/${book["image"]}",
                          width: elementImageSize,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                                text: "${getLang("title")}: ${book["title"]}"),
                            NormalText(
                                text:
                                    "${getLang("author")}: ${book["author"]}"),
                            NormalText(
                                text:
                                    "${getLang("editorial")}: ${book["editorial"]}"),
                            NormalText(
                                text:
                                    "${getLang("language")}: ${book["language"]}"),
                            NormalText(
                                text:
                                    "${getLang("state")}: ${book["aviable"] == 1 ? "${getLang("aviable")}" : "${getLang("not_aviable")}"}"),
                            NormalText(
                                text:
                                    "${getLang("category")}: ${book["category"]}"),
                            NormalText(
                                // text: book["genres"].length <= 3
                                //     ? "Generos: ${book["genres"].join(", ")}"
                                //     : "Generos: ${book["genres"].sublist(0, 3).join(", ")}..."),
                                text:
                                    "${getLang("genres")}: ${book["genres"].join(", ")}"),
                          ],
                        ),
                      )
                    ],
                  ),
                  DescriptionRichText(text: book["description"]),
                ],
              ),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}
