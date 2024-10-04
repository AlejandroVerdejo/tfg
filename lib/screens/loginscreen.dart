import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/registerscreen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Metodo para obtener la preferencia del tema
  Future<Map<String, dynamic>> _loadPreferences() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme") ?? "light"; // Valor predeterminado
    // Devuelve un mapa con las preferencias
    return {"theme": theme};
  }

  @override
  Widget build(BuildContext context) {
    users;

    final userController = TextEditingController();
    final passwordController = TextEditingController();

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
              child: Text("${getLang("error")}"),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            return Scaffold(
                backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${getLang("login")}",
                        style: getStyle("loginTextStyle", data["theme"]),
                      ),
                      Image.asset(
                        "assets/images/app_icon.png",
                        width: 180,
                        color: colors[data["theme"]]["mainTextColor"],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextSelectionTheme(
                          data: getStyle(
                              "loginFieldSelectionTheme", data["theme"]),
                          child: TextField(
                            style: getStyle("normalTextStyle", data["theme"]),
                            maxLength: 16,
                            controller: userController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: getStyle(
                                        "loginFieldBorderSide", data["theme"])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: getStyle(
                                        "loginFieldBorderSide", data["theme"])),
                                border: const OutlineInputBorder(),
                                labelText: "${getLang("user")}",
                                labelStyle:
                                    getStyle("normalTextStyle", data["theme"]),
                                floatingLabelStyle:
                                    getStyle("normalTextStyle", data["theme"]),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextSelectionTheme(
                          data: getStyle(
                              "loginFieldSelectionTheme", data["theme"]),
                          child: TextField(
                            obscureText: true,
                            style: getStyle("normalTextStyle", data["theme"]),
                            maxLength: 16,
                            controller: passwordController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: getStyle(
                                        "loginFieldBorderSide", data["theme"])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: getStyle(
                                        "loginFieldBorderSide", data["theme"])),
                                border: const OutlineInputBorder(),
                                labelText: "${getLang("password")}",
                                labelStyle:
                                    getStyle("normalTextStyle", data["theme"]),
                                floatingLabelStyle:
                                    getStyle("normalTextStyle", data["theme"]),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextButton(
                          style: getStyle(
                            "loginTextButtonStyle",
                            data["theme"],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            "${getLang("login_createHere")}",
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      OutlinedButton(
                        style: getStyle("loginButtonStyle", data["theme"]),
                        onPressed: () {
                          if (users[userController.text]["password"] ==
                              passwordController.text) {
                            Map<String, dynamic> user = {
                              "username": users[userController.text]
                                  ["username"],
                              "password": users[userController.text]
                                  ["password"],
                              "level": users[userController.text]["level"]
                            };
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(user: user)));
                          }
                        },
                        child: Text(
                          "${getLang("login")}",
                        ),
                      )
                    ],
                  ),
                ));
          }
        });
  }
}
