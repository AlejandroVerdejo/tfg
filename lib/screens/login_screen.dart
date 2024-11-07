import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.theme,
    required this.onLogIn,
  });

  final String theme;
  final VoidCallback onLogIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _saveUser(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("savedUser", email);
    widget.onLogIn();
  }

  @override
  void initState() {
    super.initState();
    login = true;
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FirestoreManager firestoreManager = FirestoreManager();
  final _formKey = GlobalKey<FormBuilderState>();
  bool login = true;

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return Scaffold(
      backgroundColor: colors[theme]["mainBackgroundColor"],
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
                      style: getStyle("loginTextStyle", theme),
                    ),
                    Image.asset(
                      "assets/images/app_icon.png",
                      width: 180,
                      color: colors[theme]["mainTextColor"],
                    ),
                    const SizedBox(height: 30),
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
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "username",
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle",
                                  theme,
                                  getLang("username"), ""),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: getLang("formError-required")),
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
                        decoration: getTextFieldStyle("defaultTextFieldStyle",
                            theme, getLang("password"), ""),
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
                        theme,
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
                      style: getStyle("loginButtonStyle", theme),
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          var values = _formKey.currentState?.value;
                          if (login) {
                            if (await firestoreManager
                                .checkUser(values?["email"])) {
                              if (await firestoreManager.checkPassword(
                                  values?["email"], values?["password"])) {
                                _saveUser(values?["email"]);
                              } else {
                                showSnackBar(context, getLang("loginError"));
                              }
                            } else {
                              showSnackBar(context, getLang("loginError"));
                            }
                          } else {
                            if (await firestoreManager
                                .checkUser(values?["email"])) {
                              showSnackBar(context, getLang("registerError"));
                            } else {
                              Map<String, dynamic> user = {
                                "email": values?["email"],
                                "username": values?["username"],
                                "password": values?["password"],
                                "level": 2
                              };
                              await firestoreManager.addUser(user);
                              _saveUser(values?["email"]);
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
}
