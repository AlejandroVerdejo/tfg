import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Metodo para obtener la preferencia del tema
  Future<Map<String, dynamic>> _loadData() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme")!; // Valor predeterminado
    // Devuelve un mapa con los datos
    return {"theme": theme};
  }

  void _saveUser(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("savedUser", email);
  }

  FirestoreManager firestoreManager = FirestoreManager();
  final _formKey = GlobalKey<FormBuilderState>();
  bool login = true;

  @override
  void initState() {
    super.initState();
    login = true;
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
            child: Text(getLang("error")),
          );
        } else {
          // Ejecucion
          final data = snapshot.data!;
          var theme = data["theme"];
          return Scaffold(
            backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
            body: ListView(
              children: [
                Center(
                  child: SizedBox(
                    width: 500,
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 90),
                          Text(
                            login ? getLang("login") : getLang("register"),
                            style: getStyle("loginTextStyle", data["theme"]),
                          ),
                          Image.asset(
                            "assets/images/app_icon.png",
                            width: 180,
                            color: colors[data["theme"]]["mainTextColor"],
                          ),
                          const SizedBox(height: 30),
                          TextSelectionTheme(
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "email",
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle", theme, "Email"),
                              keyboardType: TextInputType.emailAddress,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                      errorText: getLang("formError-required")),
                                  FormBuilderValidators.email(
                                      errorText: getLang("formError-email"))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          login
                              ? const SizedBox.shrink()
                              : TextSelectionTheme(
                                  data: getStyle(
                                      "loginFieldSelectionTheme", theme),
                                  child: FormBuilderTextField(
                                    name: "username",
                                    style: getStyle("normalTextStyle", theme),
                                    decoration: getTextFieldStyle(
                                        "defaultTextFieldStyle",
                                        theme,
                                        "Nombre de usuario"),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText:
                                              getLang("formError-required")),
                                    ]),
                                  ),
                                ),
                          login
                              ? const SizedBox.shrink()
                              : const SizedBox(height: 30),
                          TextSelectionTheme(
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "password",
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle", theme, "Contraseña"),
                              obscureText: true,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                      errorText: getLang("formError-required")),
                                  FormBuilderValidators.minLength(8,
                                      errorText: getLang("formError-minLength"))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                            style: getStyle(
                              "loginTextButtonStyle",
                              data["theme"],
                            ),
                            onPressed: () {
                              setState(() {
                                login ? login = false : login = true;
                              });
                            },
                            child: Text(
                              login
                                  ? getLang("login_createHere")
                                  : getLang("login_loginHere"),
                            ),
                          ),
                          const SizedBox(height: 30),
                          OutlinedButton(
                            style: getStyle("loginButtonStyle", data["theme"]),
                            onPressed: () async {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                log("form-ok");
                                var values = _formKey.currentState?.value;
                                if (login) {
                                  if (await firestoreManager
                                      .checkUser(values?["email"])) {
                                    if (await firestoreManager.checkPassword(
                                        values?["email"],
                                        values?["password"])) {
                                      Map<String, dynamic> user =
                                          await firestoreManager
                                              .getUser(values?["email"]);
                                      _saveUser(values?["email"]);
                                      Navigator.push(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen(user: user),
                                        ),
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            child: Text(
                              getLang("login"),
                            ),
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
      },
    );
  }
}
