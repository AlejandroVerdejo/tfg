import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/renttext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentBookBookData extends StatefulWidget {
  const RentBookBookData({
    super.key,
    required this.bookkey,
  });

  final String bookkey;

  @override
  State<RentBookBookData> createState() => _RentBookBookDataState();
}

class _RentBookBookDataState extends State<RentBookBookData> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    Map<String, dynamic> book =
        await firestoreManager.getUnMergedBook(widget.bookkey);
    return {
      "theme": theme,
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
            var book = data["book"];
            return Container(
              width: rentsElementWidth,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  SizedBox(
                    height: rentsElementHeight,
                    child: Image.network(
                      "${book["image"]}",
                      width: elementImageSize,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RentText(
                    text: book["title"],
                    alignment: TextAlign.center,
                  ),
                  RentText(
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
