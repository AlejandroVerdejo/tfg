import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/book_list_element.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';

class UserBookListElement extends StatefulWidget {
  const UserBookListElement({
    super.key,
    required this.theme,
    required this.user,
    required this.type,
    required this.book,
    required this.onDelete,
  });

  final String theme;
  final Map<String, dynamic> user;
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
            widget.user["email"], widget.book["isbn"])
        : await firestoreManager.deleteUserWaitList(
            widget.user["email"], widget.book["isbn"]);
    widget.onDelete();
  }

  void _refresh() {
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return Stack(
      children: [
        BookListElement(
          theme: theme,
          user: widget.user,
          book: widget.book,
          type: widget.type,
          onClose: _refresh,
        ),
        // ? Eliminar de la lista
        Positioned(
          top: 0,
          right: 0,
          child: Tooltip(
            message: getLang("deleteFromList"),
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteDialog(
                        theme: theme,
                        title: getLang("deleteBookListDialog-title"),
                        message: getLang("alertDialog-confirm"),
                        onAccept: _delete,
                      );
                    });
              },
              icon: Icon(
                Icons.delete,
                color: colors[theme]["headerBackgroundColor"],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
