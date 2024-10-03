import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/tempdata.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura que los bindings de Flutter estén inicializados
  SharedPreferences prefs = await SharedPreferences
      .getInstance(); // Esperar a que se carguen las preferencias
  if (!prefs.containsKey("theme")) {
    // Si no existe la clave
    await prefs.setString(
        "theme", "dark"); // Establecer el valor predeterminado
  }
  if (!prefs.containsKey("saved_user")) {
    // Si no existe la clave
    await prefs.setString(
        "saved_user", ""); // Establecer el valor predeterminado
  }
  // runApp(MainApp(var)); // Pasar el valor al widget principal
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

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
