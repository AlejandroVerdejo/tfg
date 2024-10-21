import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class AddBook extends StatefulWidget {
  const AddBook({
    super.key,
  });

  @override
  State<AddBook> createState() => _AddBookState();
}

FirestoreManager firestoreManager = FirestoreManager();

TextEditingController existentBookController = TextEditingController();

class _AddBookState extends State<AddBook> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
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
                  text: getLang("rentBook"),
                ),
                backgroundColor: colors[theme]["headerBackgroundColor"],
              ),
              backgroundColor: colors[theme]["mainBackgroundColor"],
              body: Padding(
                padding: bodyPadding,
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 350,
                      child: TextSelectionTheme(
                        data: getStyle("loginFieldSelectionTheme", theme),
                        child: TextField(
                          style: getStyle("normalTextStyle", theme),
                          controller: existentBookController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      getStyle("loginFieldBorderSide", theme)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      getStyle("loginFieldBorderSide", theme)),
                              border: const OutlineInputBorder(),
                              labelText: getLang("bookId"),
                              labelStyle: getStyle("normalTextStyle", theme),
                              floatingLabelStyle:
                                  getStyle("normalTextStyle", theme),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    OutlinedButton(
                      style: getStyle("loginButtonStyle", theme),
                      onPressed: () async {
                        if (existentBookController.text.isNotEmpty) {
                          if (await firestoreManager.checkBook(existentBookController.text)) {
                            log("checkbook-true");
                          }
                          // bookLoaded = await firestoreManager
                          //     .checkBook(existentBookController.text);
                          // log("user: ${bookLoaded.toString()}");
                          // if (bookLoaded) {
                          //   book = bookController.text;
                          //   bookAviable = await firestoreManager
                          //       .checkBookAviability(book);
                          // } else {
                          //   showSnackBar(
                          //       context, getLang("rentBookLoadUser-error"));
                          // }
                          setState(() {});
                        }
                      },
                      child: Text(
                        "Cargar libro existente",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
