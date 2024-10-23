import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/addbookdata.dart';
import 'package:tfg_library/management/addtagsdialog.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class AddBook extends StatefulWidget {
  const AddBook({
    super.key,
  });

  @override
  State<AddBook> createState() => _AddBookState();
}

FirestoreManager firestoreManager = FirestoreManager();

TextEditingController existentBookController = TextEditingController();
bool loadBook = false;

class _AddBookState extends State<AddBook> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    return {"theme": theme};
  }

  // final GlobalKey<_AddBookDataState> childMethod = GlobalKey<_AddBookDataState>();
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
              child: Text(getLang("error")),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var theme = data["theme"];
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
                  text: getLang("addBook"),
                ),
                backgroundColor: colors[theme]["headerBackgroundColor"],
              ),
              backgroundColor: colors[theme]["mainBackgroundColor"],
              body: ListView(
                children: [
                  Center(
                    child: Container(
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
                                    "defaultTextFieldStyle",
                                    theme,
                                    getLang("bookId")),
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
                                    // key: childKey,
                                    bookkey: existentBookController.text,
                                  )
                                : AddBookData(
                                    key: childKey,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
