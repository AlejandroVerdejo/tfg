import 'package:flutter/material.dart';
import 'package:tfg_library/screens/catalogscreen.dart';
import 'package:tfg_library/screens/loginscreen.dart';
import 'package:tfg_library/screens/profilescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(""),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Column(
                  children: [
                    Text(
                      "Drawer Header",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                        radius: 40,
                        child: Icon(
                          Icons.person,
                          size: 40,
                        )),
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Catalogo"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CatalogScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Ajustes"),
              onTap: () {},
            ),
            // SizedBox(height: double.maxFinite,),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar sesión"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Prueba"),
      ),
    );
  }
}
