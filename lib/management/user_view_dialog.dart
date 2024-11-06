import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/list_data_text.dart';

class UserViewDialog extends StatefulWidget {
  const UserViewDialog({
    super.key,
    required this.theme,
    required this.user,
    required this.edit,
    this.onEdit,
  });

  final String theme;
  final Map<String, dynamic> user;
  final bool edit;
  final VoidCallback? onEdit;

  @override
  State<UserViewDialog> createState() => _UserViewDialogState();
}

class _UserViewDialogState extends State<UserViewDialog> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  FirestoreManager firestoreManager = FirestoreManager();
  final _formKey = GlobalKey<FormBuilderState>();

  void loadData() {
    usernameController.text = widget.user["username"];
    emailController.text = widget.user["email"];
    passwordController.text = widget.user["password"];
    levelController.text =
        widget.user["level"] == 1 ? getLang("worker") : getLang("admin");
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var user = widget.user;
    usernameController.text = user["username"];
    if (widget.edit) {
      loadData();
    }
    return AlertDialog(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      content: Container(
        width: dialogWidth,
        padding: dialogPadding,
        child: widget.edit
            // ? Editar
            ? FormBuilder(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ? Nombre
                    TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: FormBuilderTextField(
                        name: "username",
                        controller: usernameController,
                        style: getStyle("normalTextStyle", theme),
                        decoration: getTextFieldStyle("defaultTextFieldStyle",
                            theme, getLang("Username")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: getLang("formError-required")),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // ? Correo electronico
                    TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: FormBuilderTextField(
                        name: "email",
                        readOnly: true,
                        controller: emailController,
                        style: getStyle("normalTextStyle", theme),
                        decoration: getTextFieldStyle(
                            "defaultTextFieldStyle", theme, getLang("email")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: getLang("formError-required")),
                          FormBuilderValidators.email(
                              errorText: getLang("formError-email"))
                        ]),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // ? Contraseña
                    TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: FormBuilderTextField(
                        name: "password",
                        controller: passwordController,
                        style: getStyle("normalTextStyle", theme),
                        decoration: getTextFieldStyle("defaultTextFieldStyle",
                            theme, getLang("password")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: getLang("formError-required")),
                          FormBuilderValidators.minLength(8,
                              errorText: getLang("formError-minLength"))
                        ]),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // ? Nivel
                    TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: FormBuilderTextField(
                        name: "level",
                        readOnly: true,
                        controller: levelController,
                        style: getStyle("normalTextStyle", theme),
                        decoration: getTextFieldStyle(
                            "defaultTextFieldStyle", theme, getLang("level")),
                        onTap: () async {
                          SelectDialog.showModal(context,
                              showSearchBox: false,
                              backgroundColor: colors[theme]
                                  ["mainBackgroundColor"],
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
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: getLang("formError-required")),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      style: getStyle("loginButtonStyle", theme),
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          Map<String, dynamic> newUserData = {
                            "username": usernameController.text,
                            "email": emailController.text,
                            "password": passwordController.text,
                            "level": levelController.text == getLang("worker")
                                ? 1
                                : 0,
                          };
                          await firestoreManager.editUser(newUserData);
                          Navigator.of(context).pop();
                          widget.onEdit!();
                        }
                      },
                      child: Text(
                        getLang("save"),
                      ),
                    ),
                  ],
                ),
              )
            // ? Ver
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListDataText(
                      theme: theme,
                      title: getLang("username"),
                      text: user["username"]),
                  ListDataText(
                      theme: theme,
                      title: getLang("email"),
                      text: user["email"]),
                  ListDataText(
                      theme: theme,
                      title: getLang("email"),
                      text: user["password"]),
                  ListDataText(
                      theme: theme,
                      title: getLang("level"),
                      text: user["level"] == 1
                          ? getLang("worker")
                          : getLang("admin")),
                ],
              ),
      ),
    );
  }
}
