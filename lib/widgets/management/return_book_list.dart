import 'package:flutter/material.dart';
import 'package:tfg_library/widgets/management/return_book.dart';
import 'package:tfg_library/widgets/management/return_book_list_element.dart';

class ReturnBookList extends StatefulWidget {
  const ReturnBookList(
      {super.key, required this.theme, required this.onSelected});

  final String theme;
  final Function(int) onSelected;

  @override
  State<ReturnBookList> createState() => _ReturnBookListState();
}

int selected = -1;

class _ReturnBookListState extends State<ReturnBookList> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    int count = 0;
    return Wrap(
      direction: Axis.vertical,
      spacing: 30,
      children: userActiveRents.map((item) {
        item["position"] = count;
        count++;
        return GestureDetector(
          onTap: () {
            selected = item["position"];
            widget.onSelected(selected);
            setState(() {});
          },
          child: ReturnBookListElement(
            theme: theme,
            widget: widget,
            rent: item,
          ),
        );
      }).toList(),
    );
  }
}
