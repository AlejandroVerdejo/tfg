import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';
import 'package:tfg_library/widgets/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/message_dialog.dart';

class UserViewDialog extends StatefulWidget {
  const UserViewDialog({
    super.key,
    required this.theme,
    required this.user,
    required this.edit,
    required this.onEdit,
    required this.deleteAviable,
  });

  final String theme;
  final Map<String, dynamic> user;
  final bool edit;
  final VoidCallback onEdit;
  final bool deleteAviable;

  @override
  State<UserViewDialog> createState() => _UserViewDialogState();
}

class _UserViewDialogState extends State<UserViewDialog> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  bool edit = false;

  FirestoreManager firestoreManager = FirestoreManager();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    edit = widget.edit;
    loadData();
  }

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
    return AlertDialog(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      scrollable: true,
      content: Container(
        width: dialogWidth,
        padding: dialogPadding,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  !edit
                      ?
                      // ? Editar
                      IconButton(
                          onPressed: () {
                            edit = true;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.edit,
                            color: colors[theme]["mainTextColor"],
                          ),
                        )
                      :
                      // ? Cancelar
                      IconButton(
                          onPressed: () {
                            edit = false;
                            loadData();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: colors[theme]["mainTextColor"],
                          ),
                        ),
                  // ? Eliminar
                  IconButton(
                    onPressed: widget.deleteAviable
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteDialog(
                                  theme: theme,
                                  title: getLang("deleteUser"),
                                  message: getLang("confirmation"),
                                  onAccept: () async {
                                    await firestoreManager
                                        .deleteUser(user["email"]);
                                    widget.onEdit();
                                    Navigator.pop(context, false);
                                  },
                                );
                              },
                            );
                          }
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MessageDialog(
                                  theme: theme,
                                  message: getLang("userDeleteMessage-unable"),
                                );
                              },
                            );
                          },
                    icon: Icon(
                      Icons.delete,
                      color: colors[theme]["headerBackgroundColor"],
                    ),
                  ),
                ],
              ),

              // ? Correo electronico
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  name: "email",
                  controller: emailController,
                  readOnly: true,
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("email"), ""),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: getLang("formError-required"),
                    ),
                    FormBuilderValidators.email(
                      errorText: getLang("formError-email"),
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 15),
              // ? Nombre
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  name: "username",
                  controller: usernameController,
                  readOnly: !edit,
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("username"), ""),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: getLang("formError-required"),
                    ),
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
                  readOnly: !edit,
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, getLang("password"), ""),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: getLang("formError-required"),
                    ),
                    FormBuilderValidators.minLength(
                      8,
                      errorText: getLang("formError-minLength"),
                    )
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
                      "defaultTextFieldStyle", theme, getLang("level"), ""),
                  onTap: edit
                      ? () async {
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
                        }
                      : null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: getLang("formError-required"),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 15),
              edit
                  // ? Guardar
                  ? DefaultButton(
                      theme: theme,
                      text: getLang("save"),
                      onClick: () async {
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
                          widget.onEdit();
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
