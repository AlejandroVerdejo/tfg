import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/registerscreen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    users;

    final userController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: colors[settings["theme"]]["mainBackgroundColor"],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Iniciar Sesión",
                style: styles[settings["theme"]]["loginTextStyle"],
              ),
              Image.asset(
                "assets/images/app_icon.png",
                width: 180,
                color: colors[settings["theme"]]["mainTextColor"],
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  style: styles[settings["theme"]]["normalTextStyle"],
                  controller: userController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Usuario",
                      labelStyle: styles[settings["theme"]]["normalTextStyle"],
                      floatingLabelStyle: styles[settings["theme"]]
                          ["normalTextStyle"],
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  obscureText: true,
                  style: styles[settings["theme"]]["normalTextStyle"],
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Constraseña",
                      labelStyle: styles[settings["theme"]]["normalTextStyle"],
                      floatingLabelStyle: styles[settings["theme"]]
                          ["normalTextStyle"],
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "¿No tienes una cuenta? Creala aquí.",
                    style: TextStyle(fontSize: 15),
                  )),
              const SizedBox(
                height: 25,
              ),
              OutlinedButton(
                style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300, 50))),
                onPressed: () {
                  if (users[userController.text]["password"] ==
                      passwordController.text) {
                    Map<String, dynamic> user = {
                      "username": users[userController.text]["username"],
                      "password": users[userController.text]["password"],
                      "level": users[userController.text]["level"]
                    };
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(user: user)));
                  }
                },
                child: const Text(
                  "Iniciar sesión",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ));
  }
}
