import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/text/rent_text.dart';

class PopularListElement extends StatefulWidget {
  const PopularListElement({
    super.key,
    required this.theme,
    required this.book,
  });

  final String theme;
  final Map<String, dynamic> book;

  @override
  State<PopularListElement> createState() => _PopularListElementState();
}

class _PopularListElementState extends State<PopularListElement> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var book = widget.book;
    return Container(
      width: rentsElementWidth,
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          SizedBox(
            height: rentsElementHeight,
            child: Image.memory(
              book["image"],
              width: elementImageSize,
            ),
          ),
          BetterDivider(theme: theme),
          RentText(
            theme: theme,
            text: book["title"],
            alignment: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
