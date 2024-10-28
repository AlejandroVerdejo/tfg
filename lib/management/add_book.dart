import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/add_book_data.dart';
import 'package:tfg_library/management/add_tags_dialog.dart';
import 'package:tfg_library/styles.dart';

class AddBook extends StatefulWidget {
  const AddBook({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<AddBook> createState() => _AddBookState();
}

FirestoreManager firestoreManager = FirestoreManager();

TextEditingController existentBookController = TextEditingController();
bool loadBook = false;

class _AddBookState extends State<AddBook> {
  final GlobalKey<AddBookDataState> childKey = GlobalKey<AddBookDataState>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    // Asigna el valor de la primera carga
    existentBookController = TextEditingController();
    loadBook = false;
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return ListView(
      children: [
        Container(
          padding: bodyPadding,
          width: double.maxFinite,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    controller: existentBookController,
                    name: "bookId",
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, getLang("bookId")),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  style: getStyle("loginButtonStyle", theme),
                  onPressed: () async {
                    if (existentBookController.text.isNotEmpty) {
                      if (await firestoreManager
                          .checkBook(existentBookController.text)) {
                        loadBook = true;
                      }
                      setState(() {});
                      // childKey.currentState?.refresh();
                    }
                  },
                  child: Text(
                    getLang("loadBook"),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  style: getStyle("loginButtonStyle", theme),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddTagsDialog(theme: theme);
                        });
                    childKey.currentState?.refresh();
                  },
                  child: Text(
                    getLang("addTags"),
                  ),
                ),
                const SizedBox(height: 30),
                loadBook
                    ? AddBookData(
                        theme: theme,
                        // key: childKey,
                        bookkey: existentBookController.text,
                      )
                    : AddBookData(
                        theme: theme,
                        key: childKey,
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}