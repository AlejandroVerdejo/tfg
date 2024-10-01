import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/tempdata.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    settings;
    users;

    // ignore: unused_local_variable
    Map<String, dynamic> user;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: settings["saved_user"] == true
              ? HomeScreen(
                  user: user = {
                  "username": users[settings["saved_user_user"]]["username"],
                  "password": users[settings["saved_user_user"]]["password"],
                  "level": users[settings["saved_user_user"]]["level"]
                })
              : const LoginScreen(),
        ),
      ),
    );
  }
}
