import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/betterverticaldivider.dart';
import 'package:tfg_library/widgets/catalog/book.dart';
import 'package:tfg_library/widgets/text/descriptionrichtext.dart';
import 'package:tfg_library/widgets/text/listdatatext.dart';

class BookListElement extends StatefulWidget {
  const BookListElement({
    super.key,
    required this.book,
    this.onClose,
  });

  final Map<String, dynamic> book;
  final VoidCallback? onClose;

  @override
  State<BookListElement> createState() => _BookListElementState();
}

class _BookListElementState extends State<BookListElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("tap");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Book(
                      book: widget.book,
                    ))).then((result) {
          log("Log: message");
          if (widget.onClose != null) {
            widget.onClose!();
          }
        });
        // if (result != null) {
        // }
      },
      child: Expanded(
        child: Opacity(
          opacity: widget.book["aviable"] ? 1 : 0.3,
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
                            child: Image.network(
                              "${widget.book["image"]}",
                              width: elementImageSize,
                            )),
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
                                  text: "${widget.book["title"]}"),
                              ListDataText(
                                  title: getLang("author"),
                                  text: "${widget.book["author"]}"),
                              ListDataText(
                                  title: getLang("editorial"),
                                  text: "${widget.book["editorial"]}"),
                              ListDataText(
                                  title: getLang("language"),
                                  text: "${widget.book["language"]}"),
                              ListDataText(
                                  title: getLang("state"),
                                  text: widget.book["aviable"]
                                      ? getLang("aviable")
                                      : getLang("not_aviable")),
                              ListDataText(
                                  title: getLang("category"),
                                  text: "${widget.book["category"]}"),
                              ListDataText(
                                  title: getLang("genres"),
                                  text: "${widget.book["genres"].join(", ")}"),
                              widget.book["aviable"] ||
                                      widget.book["return_date"] == null
                                  ? const SizedBox.shrink()
                                  : ListDataText(
                                      title: getLang("espectedAviable"),
                                      text: "${widget.book["return_date"]}")
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DescriptionRichText(text: widget.book["description"]),
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
