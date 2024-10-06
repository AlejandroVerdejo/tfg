import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/listdatatext.dart';
import 'package:tfg_library/widgets/text/sinopsisbooktext.dart';

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
            return Center(
              child: Text("${getLang("error")}"),
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
                title: BarText(
                  text: widget.book["title"],
                ),
                backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
              ),
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              body: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: Padding(
                      padding: bodyPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            // child: Image.asset(
                            //   "assets/images/books/${widget.book["image"]}",
                            //   width: bookImageSize,
                            // ),
                            child: Image.network(
                              "${widget.book["image"]}",
                              width: bookImageSize,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: BetterDivider(),
                          ),
                          ListDataText(
                              title: "${getLang("title")}",
                              text: "${widget.book["title"]}"),
                          ListDataText(
                              title: "${getLang("author")}",
                              text: "${widget.book["author"]}"),
                          ListDataText(
                              title: "${getLang("editorial")}",
                              text: "${widget.book["editorial"]}"),
                          ListDataText(
                              title: "${getLang("date")}",
                              text: "${widget.book["date"]}"),
                          ListDataText(
                              title: "${getLang("pages")}",
                              text: "${widget.book["pages"]}"),
                          ListDataText(
                              title: "${getLang("language")}",
                              text: "${widget.book["language"]}"),
                          ListDataText(
                              title: "${getLang("isbn")}",
                              text: "${widget.book["isbn"]}"),
                          ListDataText(
                              title: "${getLang("age")}",
                              text: "${widget.book["age"]}"),
                          ListDataText(
                              title: "${getLang("state")}",
                              text: widget.book["aviable"] == 1
                                  ? "${getLang("aviable")}"
                                  : "${getLang("not_aviable")}"),
                          ListDataText(
                              title: "${getLang("category")}",
                              text: "${widget.book["category"]}"),
                          ListDataText(
                              title: "${getLang("genres")}",
                              text: "${widget.book["genres"].join(", ")}"),
                          SinopsisBookText(
                              title: "${getLang("sinopsis")}",
                              text: "${widget.book["description"]}"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
