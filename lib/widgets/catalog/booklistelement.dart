import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/betterverticaldivider.dart';
import 'package:tfg_library/widgets/catalog/book.dart';
import 'package:tfg_library/widgets/text/descriptionrichtext.dart';
import 'package:tfg_library/widgets/text/listdatatext.dart';

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
      child: Expanded(
        child: Opacity(
          opacity: book["aviable"] ? 1 : 0.3,
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
                          padding: imageBookListPadding,
                          child: isAndroid
                              ? Image.network(
                                  "${book["image_url"]}",
                                  width: elementImageSize,
                                )
                              : Image.asset(
                                  "assets/images/books/${book["image_asset"]}",
                                  width: elementImageSize,
                                ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: BetterVerticalDivider(),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListDataText(
                                  title: getLang("title"),
                                  text: "${book["title"]}"),
                              ListDataText(
                                  title: getLang("author"),
                                  text: "${book["author"]}"),
                              ListDataText(
                                  title: getLang("editorial"),
                                  text: "${book["editorial"]}"),
                              ListDataText(
                                  title: getLang("language"),
                                  text: "${book["language"]}"),
                              ListDataText(
                                  title: getLang("state"),
                                  text: book["aviable"]
                                      ? getLang("aviable")
                                      : getLang("not_aviable")),
                              ListDataText(
                                  title: getLang("category"),
                                  text: "${book["category"]}"),
                              ListDataText(
                                  title: getLang("genres"),
                                  text: "${book["genres"].join(", ")}"),
                              book["aviable"] || book["return_date"] == null
                                  ? const SizedBox.shrink()
                                  : ListDataText(
                                      title: getLang("espectedAviable"),
                                      text: "${book["return_date"]}")
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DescriptionRichText(text: book["description"]),
                  ],
                ),
                const BetterDivider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
