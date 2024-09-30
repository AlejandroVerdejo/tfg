import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tfg_library/screens/loginscreen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Registrarse",
            style: TextStyle(fontSize: 50),
          ),
          Image.asset("assets/images/app_icon.png", scale: 2),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 350,
            child: TextField(
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                "¿Ya tienes una cuenta? Inicia sesión aquí.",
                style: TextStyle(fontSize: 15),
              )),
          SizedBox(
            height: 25,
          ),
          OutlinedButton(
            style:
                ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(300, 50))),
            onPressed: () {},
            child: Text(
              "Registrarse",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    ));
  }
}
