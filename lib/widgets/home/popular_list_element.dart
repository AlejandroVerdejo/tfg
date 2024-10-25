import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/text/rent_text.dart';

class PopularListElement extends StatefulWidget {
  const PopularListElement({
    super.key,
    required this.theme,
    required this.bookkey,
  });

  final String theme;
  final String bookkey;

  @override
  State<PopularListElement> createState() => _PopularListElementState();
}

class _PopularListElementState extends State<PopularListElement> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> book =
        await firestoreManager.getMergedBook(widget.bookkey);
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Error
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var theme = widget.theme;
            return Container(
              width: rentsElementWidth,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  SizedBox(
                    height: rentsElementHeight,
                    child: Image.memory(
                      data["book"]["image"],
                      width: elementImageSize,
                    ),
                  ),
                  BetterDivider(theme: theme),
                  RentText(
                    theme: theme,
                    text: data["book"]["title"],
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        });
  }
}
