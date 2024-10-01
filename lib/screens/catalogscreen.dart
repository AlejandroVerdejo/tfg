import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colors["barTextColor"],
        title: const BarText(
          text: "Catalogo",
        ),
        backgroundColor: colors["headerBackgroundColor"],
      ),
      body: ListView(
        children: [
          BookListElement(book: books[1],),
          BookListElement(book: books[2],),
        ],
      ),
    );
  }
}

