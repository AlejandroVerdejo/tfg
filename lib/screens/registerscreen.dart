import 'package:flutter/material.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    users;

    final userController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: colors["mainBackgroundColor"],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Registrarse",
                style: styles["loginTextStyle"],
              ),
              Image.asset(
                "assets/images/app_icon.png",
                width: 180,
                color: colors["mainTextColor"],
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  style: styles["normalTextStyle"],
                  controller: userController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Usuario",
                      labelStyle: styles["normalTextStyle"],
                      floatingLabelStyle: styles["normalTextStyle"],
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
                  style: styles["normalTextStyle"],
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Constraseña",
                      labelStyle: styles["normalTextStyle"],
                      floatingLabelStyle: styles["normalTextStyle"],
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
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "¿Ya tienes una cuenta? Inicia sesión aquí.",
                    style: TextStyle(fontSize: 15),
                  )),
              const SizedBox(
                height: 25,
              ),
              OutlinedButton(
                style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300, 50))),
                onPressed: () {},
                child: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ));
  }
}
