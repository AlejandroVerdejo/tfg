import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/text/list_data_text.dart';
import 'package:tfg_library/widgets/text/sinopsis_book_text.dart';
import 'package:tfg_library/widgets/userlists/delete_book_list_dialog.dart';

class BookData extends StatefulWidget {
  const BookData({
    super.key,
    required this.theme,
    required this.book,
    required this.user,
    required this.showOptions,
    this.onUpdate,
    required this.valueUpdate,
    required this.updated,
    this.onEdit,
    required this.inWishList,
    required this.inWaitList,
    required this.type,
  });

  final String theme;
  final Map<String, dynamic> book;
  final Map<String, dynamic> user;
  final bool showOptions;
  final VoidCallback? onUpdate;
  final VoidCallback valueUpdate;
  final VoidCallback updated;
  final VoidCallback? onEdit;
  final bool inWishList;
  final bool inWaitList;
  final String type;

  @override
  State<BookData> createState() => _BookDataState();
}

class _BookDataState extends State<BookData> {
  FirestoreManager firestoreManager = FirestoreManager();

  Future<void> _toggleWishList(bool inWishList, String email) async {
    if (inWishList) {
      await firestoreManager.deleteUserWishList(email, widget.book["isbn"]);
    } else {
      await firestoreManager.addUserWishList(email, widget.book["isbn"]);
    }
    // setState(() {});
    widget.valueUpdate();
  }

  Future<void> _toggleWaitList(bool inWaitList, String email) async {
    if (inWaitList) {
      await firestoreManager.deleteUserWaitList(email, widget.book["isbn"]);
    } else {
      await firestoreManager.addUserWaitList(email, widget.book["isbn"]);
    }
    // setState(() {});
    widget.valueUpdate();
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var book = widget.book;
    var user = widget.user;
    var showOptions = widget.showOptions;
    var inWishList = widget.inWishList;
    var inWaitList = widget.inWaitList;
    var type = widget.type;
    return Stack(
      children: [
        ListView(
          children: [
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Padding(
                padding: bookBodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showOptions
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Tooltip(
                                message: "Editar libro",
                                child: IconButton(
                                  onPressed: () async {
                                    widget.onEdit!();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: colors[theme]["headerTextColor"],
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Cambiar disponibilidad",
                                child: IconButton(
                                  onPressed: () {
                                    firestoreManager
                                        .updateAviability(book["id"]);
                                    widget.onUpdate!();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.book_outlined,
                                    color: colors[theme]["headerTextColor"],
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Eliminar este libro",
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DeleteBookListDialog(
                                          theme: theme,
                                          title:
                                              getLang("deleteBookDialog-title"),
                                          message: getLang(
                                              "deleteBookDialog-content"),
                                          onAccept: () {
                                            firestoreManager.deleteSingleBook(
                                                widget.book["id"]);
                                            widget.onUpdate!();
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: colors[theme]["headerTextColor"],
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Eliminar todos los libros como este",
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DeleteBookListDialog(
                                          theme: theme,
                                          title: getLang(
                                              "deleteAllBookDialog-title"),
                                          message: getLang(
                                              "deleteBookDialog-content"),
                                          onAccept: () {
                                            firestoreManager.deleteAllBooks(
                                                widget.book["isbn"]);
                                            widget.onUpdate!();
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: colors[theme]["headerTextColor"],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    showOptions
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
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
        Positioned(
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
                  onPressed: () async {
                    if (type == "wishlist") {
                      widget.updated();
                    }
                    inWishList
                        ? showSnackBar(context, getLang("wishListToggle-del"))
                        : showSnackBar(context, getLang("wishListToggle-add"));
                    _toggleWishList(inWishList, user["email"]);
                  },
                  icon: Icon(
                    inWishList ? Icons.bookmark : Icons.bookmark_border,
                    color: colors[theme]["headerTextColor"],
                  ),
                ),
                book["aviable"]
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () async {
                          if (type == "waitlist") {
                            widget.updated();
                          }
                          inWaitList
                              ? showSnackBar(
                                  context, getLang("waitListToggle-del"))
                              : showSnackBar(
                                  context, getLang("waitListToggle-add"));
                          _toggleWaitList(inWaitList, user["email"]);
                        },
                        icon: Icon(
                          inWaitList ? Icons.timer : Icons.timer_outlined,
                          color: colors[theme]["headerTextColor"],
                        ),
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
