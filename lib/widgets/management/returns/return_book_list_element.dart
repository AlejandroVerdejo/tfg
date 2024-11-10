import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/management/returns/return_book_list.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';
import 'package:tfg_library/widgets/text/title_text.dart';

class ReturnBookListElement extends StatelessWidget {
  const ReturnBookListElement({
    super.key,
    required this.theme,
    required this.widget,
    required this.rent,
  });

  final String theme;
  final ReturnBookList widget;
  final Map<String, dynamic> rent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        minWidth: 600,
        maxWidth: 800,
      ),
      decoration: BoxDecoration(
        // color: colors[theme]["mainBackgroundColorTransparent"],
        border: Border.all(color: colors[theme]["mainTextColor"], width: 1),
        // borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.memory(
            rent["bookData"]["image"],
            width: elementImageSize,
          ),
          Expanded(
            child: Column(
              children: [
                TitleText(
                  theme: theme,
                  text: getLang("title"),
                  alignment: TextAlign.center,
                ),
                NormalText(
                  theme: widget.theme,
                  text: rent["bookData"]["title"],
                  alignment: TextAlign.center,
                ),
                TitleText(
                  theme: theme,
                  text: getLang("returnDate"),
                  alignment: TextAlign.center,
                ),
                NormalText(
                  theme: widget.theme,
                  text: rent["date"],
                  alignment: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Icon(
                  rent["position"] == selected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: colors[theme]["mainTextColor"],
                ),
              ],
            ),
          ),
          // NormalText(theme: theme, text: )
        ],
      ),
    );
  }
}
