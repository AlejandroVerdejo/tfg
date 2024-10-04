import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normalrichtext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: Padding(
                      padding: bodyPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/${widget.book["image"]}",
                              width: bookImageSize,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Divider(),
                          ),
                          NormalText(
                              text:
                                  "${getLang("title")}: ${widget.book["title"]}"),
                          NormalText(
                              text:
                                  "${getLang("author")}: ${widget.book["author"]}"),
                          NormalText(
                              text:
                                  "${getLang("editorial")}: ${widget.book["editorial"]}"),
                          NormalText(
                              text:
                                  "${getLang("date")}: ${widget.book["date"]}"),
                          NormalText(
                              text:
                                  "${getLang("pages")}: ${widget.book["pages"]}"),
                          NormalText(
                              text:
                                  "${getLang("language")}: ${widget.book["language"]}"),
                          NormalText(
                              text:
                                  "${getLang("isbn")}: ${widget.book["isbn"]}"),
                          NormalText(
                              text: "${getLang("age")}: ${widget.book["age"]}"),
                          NormalText(
                              text:
                                  "${getLang("state")}: ${widget.book["aviable"] == 1 ? "${getLang("aviable")}" : "${getLang("not_aviable")}"}"),
                          NormalText(
                              text:
                                  "${getLang("category")}: ${widget.book["category"]}"),
                          NormalText(
                              text:
                                  "${getLang("genres")}: ${widget.book["genres"].join(", ")}"),
                          // const Padding(
                          //   padding: EdgeInsets.only(top: 20, bottom: 20),
                          //   child: Divider(),
                          // ),
                          NormalRichText(
                              text:
                                  "${getLang("sinopsis")}: ${widget.book["description"]}"),
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
