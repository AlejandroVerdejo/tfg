import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/book_list.dart';

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
  State<WaitList> createState() => _WaitListState();
}

class _WaitListState extends State<WaitList> {
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
            var theme = widget.theme;
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
