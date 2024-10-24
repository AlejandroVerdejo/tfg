
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/management/addbook.dart';
import 'package:tfg_library/screens/homescreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tfg_library/styles.dart';
import 'firebase/firebase_options.dart';

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
  String savedUser = prefs.getString("savedUser") ?? "";
  Map<String, dynamic> user = {};
  if (savedUser.isNotEmpty) {
    user = await firestoreManager.getUser(savedUser);
  }
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

  Map<String, dynamic> user = {};
  String theme = "";

  @override
  void initState() {
    super.initState();
    user = widget.savedUser.isNotEmpty ? widget.savedUser : {};
    theme = widget.theme;
  }

  void _onLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedUser = prefs.getString("savedUser")!;
    user = await firestoreManager.getUser(savedUser);
    setState(() {});
  }

  void _onLogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("savedUser", "");
    user = {};
    setState(() {});
  }

  void _themeUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    theme = prefs.getString("theme")! == "dark" ? "light" : "dark";
    await prefs.setString("theme", theme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // initialize();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colors[theme]["mainBackgroundColor"],
        body: Center(
          child: user.isNotEmpty
              ? HomeScreen(
                  user: user,
                  theme: theme,
                  onLogOut: _onLogOut,
                  onThemeUpdate: _themeUpdate,
                )
              : LoginScreen(
                  theme: theme,
                  onLogIn: _onLogIn,
                ),
        ),
      ),
    );
  }
}
