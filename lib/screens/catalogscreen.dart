import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/catalog/booklistelement.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
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
            return const Center(
              child: Text("Error"),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.5),
                    child: Container(
                      color: colors[data["theme"]]["headerBorderColor"],
                      height: 1.5,
                    )),
                foregroundColor: colors[data["theme"]]["barTextColor"],
                title: const BarText(
                  text: "Catalogo",
                ),
                backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
              ),
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              body: ListView(
                children: [
                  BookListElement(
                    book: books[1],
                  ),
                  BookListElement(
                    book: books[2],
                  ),
                ],
              ),
            );
          }
        });
  }
}
