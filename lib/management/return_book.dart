import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/rent_book_user_data.dart';
import 'package:tfg_library/management/return_book_list.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';

class ReturnBook extends StatefulWidget {
  const ReturnBook({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<ReturnBook> createState() => _ReturnBookState();
}

FirestoreManager firestoreManager = FirestoreManager();

TextEditingController userController = TextEditingController();
bool userLoaded = false;
String user = "";
List<dynamic> userActiveRents = [];
int position = -1;

class _ReturnBookState extends State<ReturnBook> {
  @override
  void initState() {
    super.initState();
    // Asigna el valor de la primera carga
    userController = TextEditingController();
    userLoaded = false;
    user = "";
    userActiveRents = [];
    position = -1;
  }

  void _update() {
    userController = TextEditingController();
    userLoaded = false;
    user = "";
    userActiveRents = [];
    setState(() {});
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onSelected(int selected) {
    position = selected;
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return ListView(
      children: [
        Padding(
          padding: bodyPadding,
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    // ? Usuario
                    TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: FormBuilderTextField(
                        controller: userController,
                        name: "user",
                        style: getStyle("normalTextStyle", theme),
                        decoration: getTextFieldStyle(
                            "defaultTextFieldStyle", theme, getLang("userId")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: getLang("formError-required")),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 30),
                    OutlinedButton(
                      style: getStyle("loginButtonStyle", theme),
                      onPressed: () async {
                        if (userController.text.isNotEmpty) {
                          userLoaded = await firestoreManager
                              .checkUser(userController.text);
                          userActiveRents = await firestoreManager
                              .getUserActiveRents(userController.text);
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
                        ? RentBookUserData(theme: theme, email: user)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 15),
                    BetterDivider(theme: theme),
                    const SizedBox(height: 15),
                    userLoaded
                        ? ReturnBookList(
                            theme: theme,
                            onSelected: onSelected,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 15),
                    BetterDivider(theme: theme),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      style: getStyle("loginButtonStyle", theme),
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          // await firestoreManager.newUserRent(user, book, date);
                          if (position > -1) {
                            log("-valido-");
                            log("-libro- ${userActiveRents[position]["bookData"]["title"]}");
                            log("-posicion- ${userActiveRents[position]["listPosition"]}");
                            log("-isbn- ${userActiveRents[position]["book"]["isbn"]}");
                            log("-id- ${userActiveRents[position]["book"]["id"]}");
                            await firestoreManager.returnUserRent(
                              userController.text,
                              userActiveRents[position]["book"]["isbn"],
                              userActiveRents[position]["book"]["id"],
                              userActiveRents[position]["listPosition"],
                            );
                            // setState(() {
                            //   _update();
                            // });
                          } else {
                            showSnackBar(
                                context, "Selecciona un libro para devolver");
                          }
                        }
                      },
                      child: Text(getLang("returnBookAction")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
