import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/renttext.dart';

class RentBookBookData extends StatefulWidget {
  const RentBookBookData({
    super.key,
    required this.theme,
    required this.bookkey,
  });

  final String theme;
  final String bookkey;

  @override
  State<RentBookBookData> createState() => _RentBookBookDataState();
}

class _RentBookBookDataState extends State<RentBookBookData> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> book =
        await firestoreManager.getUnMergedBook(widget.bookkey);
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
                  const SizedBox(height: 20),
                  RentText(
                    theme: theme,
                    text: book["title"],
                    alignment: TextAlign.center,
                  ),
                  RentText(
                    theme: theme,
                    text: book["aviable"]
                        ? getLang("aviable")
                        : getLang("notAviable"),
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        });
  }
}
