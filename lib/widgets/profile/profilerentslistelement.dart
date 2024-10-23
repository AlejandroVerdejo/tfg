import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/rentdatetext.dart';
import 'package:tfg_library/widgets/text/renttext.dart';

// class ProfileRentsListElement extends StatelessWidget {
//   const ProfileRentsListElement({
//     super.key,
//     required this.book,
//     required this.rent,
//   });

//   final Map book;
//   final Map rent;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: rentsElementWidth,
//       padding: const EdgeInsets.all(4.0),
//       child: Column(
//         children: [
//           SizedBox(
//             height: rentsElementHeight,
//             child: Image.network(
//               "${book["image"]}",
//               width: elementImageSize,
//             ),
//           ),
//           const BetterDivider(),
//           RentText(
//             text: book["title"],
//             alignment: TextAlign.center,
//           ),
//           RentDateText(
//             text: rent["date"],
//             alignment: TextAlign.center,
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class ProfileRentsListElement extends StatefulWidget {
  const ProfileRentsListElement({
    super.key,
    required this.isbn,
    required this.rent,
  });

  final String isbn;
  final Map rent;

  @override
  State<ProfileRentsListElement> createState() =>
      _ProfileRentsListElementState();
}

class _ProfileRentsListElementState extends State<ProfileRentsListElement> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme") ?? "ligth";
    Map<String, dynamic> book =
        await firestoreManager.getMergedBook(widget.isbn);
    return {"theme": theme, "book": book};
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
                  const BetterDivider(),
                  RentText(
                    text: book["title"],
                    alignment: TextAlign.center,
                  ),
                  RentDateText(
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
