import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/rentbookbookdata.dart';
import 'package:tfg_library/management/rentbookuserdata.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class RentBook extends StatefulWidget {
  const RentBook({
    super.key,
  });

  @override
  State<RentBook> createState() => _RentBookState();
}

FirestoreManager firestoreManager = FirestoreManager();

TextEditingController bookController = TextEditingController();
bool bookLoaded = false;
String book = "";
bool bookAviable = false;
TextEditingController userController = TextEditingController();
bool userLoaded = false;
String user = "";
TextEditingController dateController = TextEditingController();
bool dateLoaded = false;
String date = "";

class _RentBookState extends State<RentBook> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    return {"theme": theme};
  }

  @override
  void initState() {
    super.initState();
    // Asigna un valor diferente en la primera carga
    bookController = TextEditingController();
    bookLoaded = false;
    book = "";
    bookAviable = false;
    userController = TextEditingController();
    userLoaded = false;
    user = "";
    dateController = TextEditingController();
    dateLoaded = false;
    date = "";
  }

  void _update() {
    bookController = TextEditingController();
    bookLoaded = false;
    book = "";
    bookAviable = false;
    userController = TextEditingController();
    userLoaded = false;
    user = "";
    dateController = TextEditingController();
    dateLoaded = false;
    date = "";
    setState(() {});
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
                          controller: bookController,
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
                        if (bookController.text.isNotEmpty) {
                          bookLoaded = await firestoreManager
                              .checkBook(bookController.text);
                          log("user: ${bookLoaded.toString()}");
                          if (bookLoaded) {
                            book = bookController.text;
                            bookAviable = await firestoreManager
                                .checkBookAviability(book);
                          } else {
                            showSnackBar(
                                context, getLang("rentBookLoadUser-error"));
                          }
                          setState(() {});
                        }
                      },
                      child: Text(
                        getLang("rentBookLoadBook"),
                      ),
                    ),
                    const SizedBox(height: 15),
                    bookLoaded
                        ? RentBookBookData(bookkey: book)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350,
                      child: TextSelectionTheme(
                        data: getStyle("loginFieldSelectionTheme", theme),
                        child: TextField(
                          style: getStyle("normalTextStyle", theme),
                          controller: userController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      getStyle("loginFieldBorderSide", theme)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      getStyle("loginFieldBorderSide", theme)),
                              border: const OutlineInputBorder(),
                              labelText: getLang("userId"),
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
                        if (userController.text.isNotEmpty) {
                          userLoaded = await firestoreManager
                              .checkUser(userController.text);
                          log("user: ${userLoaded.toString()}");
                          if (userLoaded) {
                            user = userController.text;
                          } else {
                            showSnackBar(
                                context, getLang("rentBookLoadUser-error"));
                          }
                          setState(() {});
                        }
                      },
                      child: Text(
                        getLang("rentBookLoadUser"),
                      ),
                    ),
                    const SizedBox(height: 15),
                    userLoaded
                        ? RentBookUserData(email: user)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 15),
                    // DatePicker?
                    SizedBox(
                      width: 350,
                      child: TextSelectionTheme(
                        data: getStyle("loginFieldSelectionTheme", theme),
                        child: TextField(
                          style: getStyle("normalTextStyle", theme),
                          controller: dateController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      getStyle("loginFieldBorderSide", theme)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      getStyle("loginFieldBorderSide", theme)),
                              border: const OutlineInputBorder(),
                              labelText: getLang("returnDate"),
                              labelStyle: getStyle("normalTextStyle", theme),
                              floatingLabelStyle:
                                  getStyle("normalTextStyle", theme),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                          readOnly: true,
                          onTap: () async {
                            DateTime? datePicked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                      // data: ThemeData.f
                                      data: ThemeData(
                                          primaryColor: colors[theme]
                                              ["mainBackgroundColor"],
                                          colorScheme: ColorScheme(
                                              primary: colors[theme]
                                                  ["linkTextColor"],
                                              onPrimary: colors[theme]
                                                  ["mainTextColor"],
                                              secondary: colors[theme]
                                                  ["mainTextColor"],
                                              onSecondary: colors[theme]
                                                  ["mainTextColor"],
                                              surface: colors[theme]
                                                  ["mainBackgroundColor"],
                                              onSurface: colors[theme]
                                                  ["mainTextColor"],
                                              error: Colors.red,
                                              onError: Colors.white,
                                              brightness: Brightness.light),
                                          dialogBackgroundColor: Colors.red),
                                      child: child!);
                                });
                            if (datePicked != null) {
                              dateLoaded = true;
                              dateController.text =
                                  DateFormat("dd/MM/yyyy").format(datePicked);
                              date =
                                  DateFormat("dd/MM/yyyy").format(datePicked);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const BetterDivider(),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      style: getStyle("loginButtonStyle", theme),
                      onPressed:
                          bookLoaded && bookAviable && userLoaded && dateLoaded
                              ? () async {
                                  log("prestamo");
                                  await firestoreManager.newUserRent(
                                      user, book, date);
                                  setState(() {
                                    _update();
                                  });
                                }
                              : null,
                      child: Text(getLang("rentBookAction")),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
