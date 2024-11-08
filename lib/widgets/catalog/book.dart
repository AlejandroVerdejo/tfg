import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/screens/home_screen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/text/bar_text.dart';
import 'package:tfg_library/widgets/text/list_data_text.dart';
import 'package:tfg_library/widgets/text/sinopsis_book_text.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';

class Book extends StatefulWidget {
  const Book({
    super.key,
    required this.theme,
    required this.user,
    required this.book,
    required this.type,
    this.onUpdate,
    this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> user;
  final Map<String, dynamic> book;
  final String type;
  final VoidCallback? onUpdate;
  final Function(String)? onScreenChange;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  Future<Map<String, dynamic>> _loadData() async {
    bool inWishList = await firestoreManager.checkUserWishList(
        widget.user["email"], widget.book["isbn"]);
    bool inWaitList = await firestoreManager.checkUserWaitList(
        widget.user["email"], widget.book["isbn"]);
    return {
      "inWishList": inWishList,
      "inWaitList": inWaitList,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();
  bool updated = false;

  @override
  void initState() {
    super.initState();
    updated = false;
  }

  Future<void> _toggleWishList(bool inWishList, String email) async {
    if (inWishList) {
      await firestoreManager.deleteUserWishList(email, widget.book["isbn"]);
    } else {
      await firestoreManager.addUserWishList(email, widget.book["isbn"]);
    }
    setState(() {});
  }

  Future<void> _toggleWaitList(bool inWaitList, String email) async {
    if (inWaitList) {
      await firestoreManager.deleteUserWaitList(email, widget.book["isbn"]);
    } else {
      await firestoreManager.addUserWaitList(email, widget.book["isbn"]);
    }
    setState(() {});
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ModalRoute? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(() async {
      if (updated) {
        widget.onUpdate!();
      }
      Navigator.pop(context, updated);
      return true;
    });
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(() async => true);
    super.dispose();
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
            var user = widget.user;
            var book = widget.book;
            var inWishList = data["inWishList"];
            var inWaitList = data["inWaitList"];
            bool showOptions =
                user["level"] <= 1 && widget.type == "book" ? true : false;
            return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.5),
                    child: Container(
                      color: colors[theme]["headerBorderColor"],
                      height: 1.5,
                    )),
                foregroundColor: colors[theme]["barTextColor"],
                title: BarText(
                  text: book["title"],
                ),
                backgroundColor: colors[theme]["headerBackgroundColor"],
              ),
              backgroundColor: colors[theme]["mainBackgroundColor"],
              body: Stack(
                children: [
                  ListView(
                    children: [
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width),
                        child: Padding(
                          padding: bookBodyPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              showOptions
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Tooltip(
                                          message: getLang("editBook"),
                                          child: IconButton(
                                            onPressed: () async {
                                              // Meotodo para cargar EditBook
                                              widget.onScreenChange!(
                                                "editBook|${book["isbn"]}",
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: colors[theme]
                                                  ["headerTextColor"],
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: getLang("changeAviability"),
                                          child: IconButton(
                                            onPressed: () {
                                              firestoreManager
                                                  .updateAviability(book["id"]);
                                              widget.onUpdate!();
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.book_outlined,
                                              color: colors[theme]
                                                  ["headerTextColor"],
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: "deleteBook",
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DeleteDialog(
                                                    theme: theme,
                                                    title: getLang(
                                                        "deleteBookDialog-title"),
                                                    message: getLang(
                                                        "deleteBookDialog-content"),
                                                    onAccept: () {
                                                      firestoreManager
                                                          .deleteSingleBook(
                                                              widget
                                                                  .book["id"]);
                                                      widget.onUpdate!();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: colors[theme]
                                                  ["headerTextColor"],
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: getLang("deleteAllBooks"),
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DeleteDialog(
                                                    theme: theme,
                                                    title: getLang(
                                                        "deleteAllBookDialog-title"),
                                                    message: getLang(
                                                        "deleteBookDialog-content"),
                                                    onAccept: () {
                                                      firestoreManager
                                                          .deleteAllBooks(widget
                                                              .book["isbn"]);
                                                      widget.onUpdate!();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: colors[theme]
                                                  ["headerTextColor"],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              showOptions
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      child: BetterDivider(theme: theme),
                                    )
                                  : const SizedBox.shrink(),
                              Center(
                                child: Image.memory(
                                  book["image"],
                                  width: bookImageSize,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: BetterDivider(theme: theme),
                              ),
                              showOptions
                                  ? ListDataText(
                                      theme: theme,
                                      title: getLang("id"),
                                      text: "${book["id"]}")
                                  : const SizedBox.shrink(),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("title"),
                                  text: "${book["title"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("author"),
                                  text: "${book["author"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("editorial"),
                                  text: "${book["editorial"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("date"),
                                  text: "${book["date"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("pages"),
                                  text: "${book["pages"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("language"),
                                  text: "${book["language"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("isbn"),
                                  text: "${book["isbn"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("age"),
                                  text: "${book["age"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("state"),
                                  text: book["aviable"]
                                      ? getLang("aviable")
                                      : getLang("notAviable")),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("category"),
                                  text: "${book["category"]}"),
                              ListDataText(
                                  theme: theme,
                                  title: getLang("genres"),
                                  text: "${book["genres"].join(", ")}"),
                              book["aviable"] || book["return_date"] == null
                                  ? const SizedBox.shrink()
                                  : ListDataText(
                                      theme: theme,
                                      title: getLang("espectedAviable"),
                                      text: "${book["return_date"]}"),
                              SinopsisBookText(
                                  theme: theme,
                                  title: getLang("sinopsis"),
                                  text: "${book["description"]}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  user["level"] == 2
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: colors[theme]["headerBackgroundColor"],
                            padding: EdgeInsets.zero,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (widget.type == "wishlist") {
                                      updated = true;
                                    }
                                    inWishList
                                        ? showSnackBar(context,
                                            getLang("wishListToggle-del"))
                                        : showSnackBar(context,
                                            getLang("wishListToggle-add"));
                                    _toggleWishList(inWishList, user["email"]);
                                  },
                                  icon: Icon(
                                    inWishList
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: colors[theme]["headerTextColor"],
                                  ),
                                ),
                                book["aviable"]
                                    ? const SizedBox.shrink()
                                    : IconButton(
                                        onPressed: () {
                                          if (widget.type == "waitlist") {
                                            updated = true;
                                          }
                                          inWaitList
                                              ? showSnackBar(context,
                                                  getLang("waitListToggle-del"))
                                              : showSnackBar(
                                                  context,
                                                  getLang(
                                                      "waitListToggle-add"));
                                          _toggleWaitList(
                                              inWaitList, user["email"]);
                                        },
                                        icon: Icon(
                                          inWaitList
                                              ? Icons.timer
                                              : Icons.timer_outlined,
                                          color: colors[theme]
                                              ["headerTextColor"],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          }
        });
  }
}
