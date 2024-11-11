import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';

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

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            // Error
            return const LoadingErrorWidget();
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
                              data: getStyle("loginFieldSelectionTheme", theme),
                              child: FormBuilderTextField(
                                controller: typeController,
                                readOnly: true,
                                name: "type",
                                style: getStyle("normalTextStyle", theme),
                                decoration: getTextFieldStyle(
                                    "defaultTextFieldStyle",
                                    theme,
                                    getLang("type"),
                                    ""),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: getLang("formError-required"),
                                  ),
                                ]),
                                onTap: () async {
                                  SelectDialog.showModal(
                                    context,
                                    showSearchBox: false,
                                    backgroundColor: colors[theme]
                                        ["mainBackgroundColor"],
                                    selectedValue: typeController.text,
                                    items: types,
                                    itemBuilder: (context, item, isSelected) {
                                      return SelectDialogField(
                                        theme: theme,
                                        item: item,
                                        isSelected: isSelected,
                                      );
                                    },
                                    onChange: (String selected) {
                                      typeController.text = selected;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            // ? Sinopsis
                            TextSelectionTheme(
                              data: getStyle("loginFieldSelectionTheme", theme),
                              child: FormBuilderTextField(
                                maxLines: null,
                                controller: contentController,
                                name: "content",
                                style: getStyle("normalTextStyle", theme),
                                decoration: getTextFieldStyle(
                                    "defaultTextFieldStyle",
                                    theme,
                                    getLang("content"),
                                    ""),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: getLang("formError-required"),
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(height: 30),
                            DefaultButton(
                              theme: theme,
                              text: getLang("send"),
                              onClick: () async {
                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  Map<String, dynamic> contact = {
                                    "user": user["email"],
                                    "active": true,
                                    "prio": false,
                                    "type": typeController.text,
                                    "content": contentController.text
                                        .replaceAll("\n", "<n><n>"),
                                    "comments": [],
                                    "date": DateFormat("dd/MM/yyyy").format(
                                      DateTime.now(),
                                    )
                                  };
                                  await firestoreManager.newContact(contact);
                                  contentController.text = "";
                                  typeController.text = "";
                                  showSnackBar(
                                    context,
                                    getLang("send-confirmation"),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
