import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';
import 'package:tfg_library/widgets/deletebooklistdialog.dart';

class UserBookListElement extends StatefulWidget {
  const UserBookListElement({
    super.key,
    required this.type,
    required this.book,
    required this.onDelete,
  });

  final String type;
  final Map<String, dynamic> book;
  final VoidCallback onDelete;

  @override
  State<UserBookListElement> createState() => _UserBookListElementState();
}

class _UserBookListElementState extends State<UserBookListElement> {
  Future<void> _delete() async {
    FirestoreManager firestoreManager = FirestoreManager();
    widget.type == "wishlist"
        ? await firestoreManager.deleteUserWishList(
            "correo@correo.com", widget.book["isbn"])
        : await firestoreManager.deleteUserWaitList(
            "correo@correo.com", widget.book["isbn"]);
    // setState(() {});
    widget.onDelete();
  }

  void _refresh() {
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BookListElement(
          book: widget.book,
          onClose: _refresh,
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Tooltip(
            message: getLang("deleteFromList"),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteBookListDialog(
                          onAccept: _delete,
                        );
                      });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ),
        ),
      ],
    );
  }
}
