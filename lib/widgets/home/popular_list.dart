import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/home/popular_list_element.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class PopularList extends StatefulWidget {
  const PopularList({
    super.key,
    required this.theme,
    required this.popularBooks,
  });

  final String theme;
  final List<String> popularBooks;

  @override
  State<PopularList> createState() => _PopularListState();
}

class _PopularListState extends State<PopularList> {
  Future<Map<String, dynamic>> _loadData() async {
    List<Map<String, dynamic>> books =
        await firestoreManager.getBooksList(widget.popularBooks);
    return {
      "books": books,
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
            var books = data["books"];
            return Padding(
              padding: bodyPadding,
              child: Column(
                children: [
                  NormalText(
                    theme: theme,
                    text: getLang("popularBooks"),
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      children: books.map<Widget>((book) {
                        return PopularListElement(theme: theme, book: book);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
