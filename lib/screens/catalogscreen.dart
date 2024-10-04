import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/catalog/booklist.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

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

  bool expanded = true;

  @override
  void initState() {
    super.initState();
    // Asigna un valor diferente en la primera carga
    expanded = false;
  }

  List<String> selectedGenres = [];

  List<String> selectedEditorials = [];

  List<String> selectedLanguages = [];

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
                title: BarText(
                  text: "${getLang("catalog")}",
                ),
                backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
              ),
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              body: Padding(
                padding: bodyPadding,
                child: Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ExpansionTile(
                        initiallyExpanded: expanded,
                        // onExpansionChanged: ,
                        title: NormalText(
                          text: "${getLang("filters")}",
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalText(text: "${getLang("genres")}"),
                                const Divider(),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: genres.map((tag) {
                                    return FilterChip(
                                      labelStyle: getStyle(
                                          "genreFilterChipStyle",
                                          data["theme"]),
                                      selectedColor: colors[data["theme"]]
                                          ["linkTextColor"],
                                      backgroundColor: colors[data["theme"]]
                                          ["chipBackgroundColor"],
                                      label: Text(tag),
                                      selected: selectedGenres.contains(tag),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          expanded = true;
                                          if (selected) {
                                            selectedGenres.add(tag);
                                          } else {
                                            selectedGenres.remove(tag);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      Expanded(
                          child: BookList(
                        filter: selectedGenres,
                      )),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
