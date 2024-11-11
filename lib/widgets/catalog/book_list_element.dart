import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/better_vertical_divider.dart';
import 'package:tfg_library/widgets/catalog/book.dart';
import 'package:tfg_library/widgets/text/description_richtext.dart';
import 'package:tfg_library/widgets/text/list_data_text.dart';

class BookListElement extends StatefulWidget {
  const BookListElement({
    super.key,
    required this.theme,
    required this.user,
    required this.book,
    required this.type,
    this.onClose,
    this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> user;
  final Map<String, dynamic> book;
  final String type;
  final VoidCallback? onClose;
  final Function(String)? onScreenChange;

  @override
  State<BookListElement> createState() => _BookListElementState();
}

class _BookListElementState extends State<BookListElement> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var book = widget.book;
    var user = widget.user;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Book(
              theme: theme,
              user: user,
              book: book,
              type: widget.type,
              onUpdate: widget.onClose,
              onScreenChange: widget.onScreenChange,
            ),
          ),
        );
      },
      child: Opacity(
        opacity: book["aviable"] ? 1 : 0.3,
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
                          book["image"],
                          width: elementImageSize,
                        ),
                      ),
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
                                text: "${book["title"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("author"),
                                text: "${book["author"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("editorial"),
                                text: "${book["editorial"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("language"),
                                text: "${book["language"]}"),
                            ListDataText(
                              theme: theme,
                              title: getLang("state"),
                              text: book["aviable"]
                                  ? getLang("aviable")
                                  : getLang("notAviable"),
                            ),
                            ListDataText(
                                theme: theme,
                                title: getLang("category"),
                                text: "${book["category"]}"),
                            ListDataText(
                                theme: theme,
                                title: getLang("genres"),
                                text: "${book["genres"].join(", ")}"),
                            book["aviable"] || book["return_date"] == null
                                ? const SizedBox.shrink()
                                : ListDataText(
                                    theme: theme,
                                    title: getLang("espectedAviable"),
                                    text: "${book["return_date"]}")
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DescriptionRichText(
                        theme: theme, text: book["description"]),
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
