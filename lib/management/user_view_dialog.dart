import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/list_data_text.dart';

class UserViewDialog extends StatefulWidget {
  const UserViewDialog({
    super.key,
    required this.theme,
    required this.user,
    required this.edit,
  });

  final String theme;
  final Map<String, dynamic> user;
  final bool edit;

  @override
  State<UserViewDialog> createState() => _UserViewDialogState();
}

class _UserViewDialogState extends State<UserViewDialog> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  FirestoreManager firestoreManager = FirestoreManager();

  void loadData() {
    usernameController.text = widget.user["username"];
    emailController.text = widget.user["email"];
    passwordController.text = widget.user["password"];
    levelController.text =
        widget.user["level"] == 1 ? "Trabajador" : "Administrador";
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var user = widget.user;
    usernameController.text = user["username"];
    return AlertDialog(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      content: widget.edit
          // ? Editar
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ? Nombre
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    name: "username",
                    controller: usernameController,
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, "Usuario"),
                  ),
                ),
                // ? Correo electronico
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    name: "email",
                    readOnly: true,
                    controller: emailController,
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, "Correo electronico"),
                  ),
                ),
                // ? Contraseña
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    name: "password",
                    controller: passwordController,
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, "Contraseña"),
                  ),
                ),
                // ? Nivel
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    name: "level",
                    readOnly: true,
                    controller: levelController,
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, "Nivel"),
                  ),
                ),
                OutlinedButton(
                  style: getStyle("loginButtonStyle", theme),
                  onPressed: () async {
                    Map<String, dynamic> newUserData = {
                      "username": usernameController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                      "level": levelController.text == "Trabajador" ? 1 : 0,
                    };
                    await firestoreManager.editUser(user);
                  },
                  child: Text(
                    getLang("addBook"),
                  ),
                ),
              ],
            )
          // ? Ver
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListDataText(
                    theme: theme, title: "Usuario", text: user["username"]),
                ListDataText(
                    theme: theme,
                    title: "Correo electronico",
                    text: user["email"]),
                ListDataText(
                    theme: theme, title: "Contraseña", text: user["password"]),
                ListDataText(
                    theme: theme,
                    title: "Nivel",
                    text: user["level"] == 1 ? "Trabajador" : "Administrador"),
              ],
            ),
    );
  }
}
