import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/rentdatetext.dart';
import 'package:tfg_library/widgets/text/renttext.dart';

class ProfileRentsListElement extends StatelessWidget {
  const ProfileRentsListElement({
    super.key,
    required this.book,
    required this.rent,
  });

  final Map book;
  final Map rent;

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
          RentDateText(
            text: rent["date"],
            alignment: TextAlign.center,
          )
        ],
      ),
    );
  }
}
