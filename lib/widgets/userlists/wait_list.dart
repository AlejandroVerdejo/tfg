import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/book_list.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';

class WaitList extends StatefulWidget {
  const WaitList({
    super.key,
    required this.theme,
    required this.user,
    required this.email,
  });

  final String theme;
  final Map<String, dynamic> user;
  final String email;

  @override
  State<WaitList> createState() => WaitListState();
}

class WaitListState extends State<WaitList> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> books = await firestoreManager.getMergedBooks();
    List<dynamic> waitlist =
        await firestoreManager.getUserWaitList(widget.email);
    // Devuelve un mapa con los datos
    return {
      "books": books,
      "waitlist": waitlist,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  String theme = "";

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
  }

  void _update() {
    setState(() {});
  }

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
            var books = data["books"];
            var waitlist = data["waitlist"];
            return ListView(
              children: [
                Container(
                  padding: bodyPadding,
                  child: BookList(
                    theme: theme,
                    user: widget.user,
                    books: books,
                    type: "waitlist",
                    waitList: waitlist,
                    onRefresh: _update,
                  ),
                ),
              ],
            );
          }
        });
  }
}
