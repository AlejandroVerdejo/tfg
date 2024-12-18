import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({
    super.key,
    required this.theme,
    required this.onUserAdded,
  });

  final String theme;
  final Function(Map) onUserAdded;

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FirestoreManager firestoreManager = FirestoreManager();
  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController levelController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890*-_/";
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    levelController = TextEditingController();
    passwordController.text = passwordGenerator();
  }

  String passwordGenerator() => String.fromCharCodes(
        Iterable.generate(
          12,
          (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return AlertDialog(
      backgroundColor: colors[widget.theme]["mainBackgroundColor"],
      scrollable: true,
      content: FormBuilder(
        key: _formKey,
        child: Container(
          width: dialogWidth,
          padding: dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ? | CORREO ELECTRONICO |
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  name: "email",
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("email"), ""),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        errorText: getLang("formError-required"),
                      ),
                      FormBuilderValidators.email(
                        errorText: getLang("formError-email"),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // ? | USUARIO |
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  name: "username",
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("user"), ""),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: getLang("formError-required"),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 30),
              // ? | CONTRASEÑA |
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  readOnly: true,
                  controller: passwordController,
                  name: "password",
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("password"), ""),
                  // obscureText: true,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        errorText: getLang("formError-required"),
                      ),
                      FormBuilderValidators.minLength(
                        8,
                        errorText: getLang("formError-minLength"),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // ? | NIVEL |
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  readOnly: true,
                  controller: levelController,
                  name: "level",
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("level"), ""),
                  onTap: () async {
                    SelectDialog.showModal(context,
                        showSearchBox: false,
                        backgroundColor: colors[theme]["mainBackgroundColor"],
                        selectedValue: levelController.text,
                        items: [getLang("worker"), getLang("admin")],
                        itemBuilder: (context, item, isSelected) {
                      return SelectDialogField(
                        theme: theme,
                        item: item,
                        isSelected: isSelected,
                      );
                    }, onChange: (String selected) {
                      levelController.text = selected;
                      // setState(() {});
                    });
                  },
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        errorText: getLang("formError-required"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DefaultButton(
                theme: theme,
                text: getLang("addUser"),
                onClick: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    var values = _formKey.currentState?.value;
                    if (await firestoreManager.checkUser(values?["email"])) {
                      showSnackBar(
                        context,
                        getLang("formError-usedEmail"),
                      );
                    } else {
                      Map<String, dynamic> user = {
                        "email": values?["email"],
                        "username": values?["username"],
                        "password": values?["password"],
                        "level": 1
                      };
                      await firestoreManager.addUser(user);
                      widget.onUserAdded(user);
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
