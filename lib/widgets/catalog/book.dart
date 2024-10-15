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
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme") ?? "light";
    return {"theme": theme};
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
              body: Stack(
                children: [
                  ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width),
                        child: Padding(
                          padding: bookBodyPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: isAndroid
                                    ? Image.network(
                                        "${widget.book["image_url"]}",
                                        width: bookImageSize,
                                      )
                                    : Image.asset(
                                        "assets/images/books/${widget.book["image"]}",
                                        width: bookImageSize,
                                      ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: BetterDivider(),
                              ),
                              // ListDataText(
                              //     title: getLang("id"),
                              //     text: "${widget.book["id"]}"),
                              ListDataText(
                                  title: getLang("title"),
                                  text: "${widget.book["title"]}"),
                              ListDataText(
                                  title: getLang("author"),
                                  text: "${widget.book["author"]}"),
                              ListDataText(
                                  title: getLang("editorial"),
                                  text: "${widget.book["editorial"]}"),
                              ListDataText(
                                  title: getLang("date"),
                                  text: "${widget.book["date"]}"),
                              ListDataText(
                                  title: getLang("pages"),
                                  text: "${widget.book["pages"]}"),
                              ListDataText(
                                  title: getLang("language"),
                                  text: "${widget.book["language"]}"),
                              ListDataText(
                                  title: getLang("isbn"),
                                  text: "${widget.book["isbn"]}"),
                              ListDataText(
                                  title: getLang("age"),
                                  text: "${widget.book["age"]}"),
                              ListDataText(
                                  title: getLang("state"),
                                  text: widget.book["aviable"]
                                      ? getLang("aviable")
                                      : getLang("not_aviable")),
                              ListDataText(
                                  title: getLang("category"),
                                  text: "${widget.book["category"]}"),
                              ListDataText(
                                  title: getLang("genres"),
                                  text: "${widget.book["genres"].join(", ")}"),
                              widget.book["aviable"] ||
                                      widget.book["return_date"] == null
                                  ? const SizedBox.shrink()
                                  : ListDataText(
                                      title: getLang("espectedAviable"),
                                      text: "${widget.book["return_date"]}"),
                              SinopsisBookText(
                                  title: getLang("sinopsis"),
                                  text: "${widget.book["description"]}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: colors[data["theme"]]["headerBackgroundColor"],
                      padding: EdgeInsets.zero,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bookmark_border,
                              color: colors[data["theme"]]["headerTextColor"],
                            ),
                          ),
                          widget.book["aviable"]
                              ? const SizedBox.shrink()
                              : IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.timer_outlined,
                                    color: colors[data["theme"]]
                                        ["headerTextColor"],
                                  ),
                                ),
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
