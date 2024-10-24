
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
    required this.theme,
    required this.book,
    this.onClose,
  });

  final String theme;
  final Map<String, dynamic> book;
  final VoidCallback? onClose;

  @override
  State<BookListElement> createState() => _BookListElementState();
}

class _BookListElementState extends State<BookListElement> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Book(
              theme: theme,
              book: widget.book,
            ),
          ),
        ).then(
          (result) {
            if (widget.onClose != null) {
              widget.onClose!();
            }
          },
        );
      },
      child: Opacity(
        opacity: widget.book["aviable"] ? 1 : 0.3,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: imageBookListPadding,
                          child: Image.memory(
                            widget.book["image"],
                            width: elementImageSize,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: BetterVerticalDivider(theme: theme),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListDataText(
                                theme: theme,
                                title: getLang("title"),
                                text: "${widget.book["title"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("author"),
                                text: "${widget.book["author"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("editorial"),
                                text: "${widget.book["editorial"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("language"),
                                text: "${widget.book["language"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("state"),
                                text: widget.book["aviable"]
                                    ? getLang("aviable")
                                    : getLang("notAviable")),
                            ListDataText(
                                theme: theme,
                                title: getLang("category"),
                                text: "${widget.book["category"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("genres"),
                                text: "${widget.book["genres"].join(", ")}"),
                            widget.book["aviable"] ||
                                    widget.book["return_date"] == null
                                ? const SizedBox.shrink()
                                : ListDataText(
                                    theme: theme,
                                    title: getLang("espectedAviable"),
                                    text: "${widget.book["return_date"]}")
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DescriptionRichText(
                        theme: theme, text: widget.book["description"]),
                  ),
                ],
              ),
              BetterDivider(theme: theme)
            ],
          ),
        ),
      ),
    );
  }
}
