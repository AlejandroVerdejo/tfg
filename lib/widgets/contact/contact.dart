import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class Contact extends StatefulWidget {
  const Contact({
    super.key,
    required this.theme,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> user;

  @override
  State<Contact> createState() => ContactState();
}

class ContactState extends State<Contact> {
  Future<Map<String, dynamic>> _loadData() async {
    List<String> types = await firestoreManager.getContactTypes();
    return {"types": types};
  }

  FirestoreManager firestoreManager = FirestoreManager();
  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController typeController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String theme = "";

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
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
              child: Text(snapshot.error.toString()),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var user = widget.user;
            var types = data["types"];
            return ListView(
              children: [
                Container(
                  padding: bodyPadding,
                  child: Column(
                    children: [
                      FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              // ? Tipo
                              TextSelectionTheme(
                                data:
                                    getStyle("loginFieldSelectionTheme", theme),
                                child: FormBuilderTextField(
                                  controller: typeController,
                                  readOnly: true,
                                  name: "type",
                                  style: getStyle("normalTextStyle", theme),
                                  decoration: getTextFieldStyle(
                                      "defaultTextFieldStyle",
                                      theme,
                                      "Tipo",
                                      ""),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText:
                                            getLang("formError-required")),
                                  ]),
                                  onTap: () async {
                                    log("types");
                                    SelectDialog.showModal(context,
                                        showSearchBox: false,
                                        backgroundColor: colors[theme]
                                            ["mainBackgroundColor"],
                                        selectedValue: typeController.text,
                                        items: types, itemBuilder:
                                            (context, item, isSelected) {
                                      return SelectDialogField(
                                        theme: theme,
                                        item: item,
                                        isSelected: isSelected,
                                      );
                                    }, onChange: (String selected) {
                                      typeController.text = selected;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 30),
                              // ? Sinopsis
                              TextSelectionTheme(
                                data:
                                    getStyle("loginFieldSelectionTheme", theme),
                                child: FormBuilderTextField(
                                  maxLines: null,
                                  controller: contentController,
                                  name: "content",
                                  style: getStyle("normalTextStyle", theme),
                                  decoration: getTextFieldStyle(
                                      "defaultTextFieldStyle",
                                      theme,
                                      "Contenido",
                                      ""),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText:
                                            getLang("formError-required")),
                                  ]),
                                ),
                              ),
                              const SizedBox(height: 30),
                              OutlinedButton(
                                style: getStyle("loginButtonStyle", theme),
                                onPressed: () async {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    Map<String, dynamic> contact = {
                                      "user": user["email"],
                                      "active": true,
                                      "prio": false,
                                      "type": typeController.text,
                                      "content": contentController.text
                                          .replaceAll("\n", "<n><n>"),
                                      "comments": [],
                                      "date": DateFormat("dd/MM/yyyy")
                                          .format(DateTime.now())
                                    };
                                    await firestoreManager.newContact(contact);
                                  }
                                },
                                child: Text(
                                  getLang("send"),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
