import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/registerscreen.dart';
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
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Iniciar Sesión",
            style: TextStyle(fontSize: 50),
          ),
          Image.asset("assets/images/app_icon.png", scale: 2),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 350,
            child: TextField(
              controller: userController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Usuario"),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 350,
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Constraseña"),
            ),
          ),
          SizedBox(
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
              child: Text(
                "¿No tienes una cuenta? Creala aquí.",
                style: TextStyle(fontSize: 15),
              )),
          SizedBox(
            height: 25,
          ),
          OutlinedButton(
            style:
                ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300, 50))),
            onPressed: () {
              if (users[userController.text]["password"] ==
                  passwordController.text) {
                var user = {
                  "username": users[userController.text]["username"],
                  "password": users[userController.text]["password"],
                  "level": users[userController.text]["level"]
                };
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              }
              ;
            },
            child: Text(
              "Iniciar sesión",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    ));
  }
}
