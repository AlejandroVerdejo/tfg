import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class Book extends StatefulWidget {
  const Book({
    super.key,
    required this.book,
  });

  final Map<String, dynamic> book;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme") ?? "light";
    return {"theme": theme};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Carga
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Error
            return const Center(
              child: Text("Error"),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.5),
                    child: Container(
                      color: colors[data["theme"]]["headerBorderColor"],
                      height: 1.5,
                    )),
                foregroundColor: colors[data["theme"]]["barTextColor"],
                title: const BarText(
                  text: "Catalogo",
                ),
                backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
              ),
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              body: ListView(
                children: [
                  Image.asset(
                    "assets/images/book.png",
                  )
                ],
              ),
            );
          }
        });
  }
}
