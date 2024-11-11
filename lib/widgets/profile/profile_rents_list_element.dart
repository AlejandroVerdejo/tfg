import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/text/rent_date_text.dart';
import 'package:tfg_library/widgets/text/rent_text.dart';

class ProfileRentsListElement extends StatefulWidget {
  const ProfileRentsListElement({
    super.key,
    required this.theme,
    required this.isbn,
    required this.rent,
  });

  final String theme;
  final String isbn;
  final Map rent;

  @override
  State<ProfileRentsListElement> createState() =>
      _ProfileRentsListElementState();
}

class _ProfileRentsListElementState extends State<ProfileRentsListElement> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> book =
        await firestoreManager.getMergedBook(widget.isbn);
    return {
      "book": book,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Carga
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            // Error
            return const LoadingErrorWidget();
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var theme = widget.theme;
            var book = data["book"];
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
                  RentDateText(
                    theme: theme,
                    text: widget.rent["date"],
                    alignment: TextAlign.center,
                  )
                ],
              ),
            );
          }
        });
  }
}
