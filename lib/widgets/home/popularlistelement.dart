import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/renttext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularListElement extends StatefulWidget {
  const PopularListElement({
    super.key,
    required this.bookkey,
  });

  final String bookkey;

  @override
  State<PopularListElement> createState() => _PopularListElementState();
}

class _PopularListElementState extends State<PopularListElement> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    Map<String, dynamic> book =
        await firestoreManager.getMergedBook(widget.bookkey);
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
              child: Text(getLang("error")),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            return Container(
              width: rentsElementWidth,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  SizedBox(
                    height: rentsElementHeight,
                    child: Image.network(
                      "${data["book"]["image"]}",
                      width: elementImageSize,
                    ),
                  ),
                  const BetterDivider(),
                  RentText(
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
