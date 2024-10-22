import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura que los bindings de Flutter estén inicializados
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirestoreManager firestoreManager = FirestoreManager();
  SharedPreferences prefs = await SharedPreferences
      .getInstance(); // Esperar a que se carguen las preferencias
  if (!prefs.containsKey("theme")) {
    // Si no existe la clave
    await prefs.setString(
        "theme", "dark"); // Establecer el valor predeterminado
  }
  if (!prefs.containsKey("savedUser")) {
    // Si no existe la clave
    await prefs.setString(
        "savedUser", ""); // Establecer el valor predeterminado
  }
  String theme = prefs.getString("theme") ?? "dark";
  log(theme);
  String savedUser = prefs.getString("savedUser") ?? "";
  log(savedUser);
  log(savedUser.isNotEmpty.toString());
  Map<String, dynamic> user = {};
  if (savedUser.isNotEmpty) {
    log("getuser1");
    user = await firestoreManager.getUser(savedUser);
    log("getuser2");
  }
  log(user.toString());
  runApp(MainApp(
    theme: theme,
    savedUser: user,
  ));
  // runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.theme,
    required this.savedUser,
  });

  final String theme;
  final Map<String, dynamic> savedUser;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initialize();

    // ignore: unused_local_variable
    Map<String, dynamic> user;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: widget.savedUser.isNotEmpty
              ? HomeScreen(user: widget.savedUser)
              : const LoginScreen(),
        ),
      ),
    );
  }
}
