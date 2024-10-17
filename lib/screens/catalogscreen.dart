import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/catalog/booklist.dart';
import 'package:tfg_library/widgets/helptooltip.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
// }

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Metodo para obtener la preferencia del tema
  Future<Map<String, dynamic>> _loadData() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme")!; // Valor predeterminado
    // Obtiene los | Libros |
    Map<String, dynamic> books = await firestoreManager.getMergedBooks();
    // Obtiene los Tags | Categorias | Generos | Editoriales | Idiomas |
    Map<String, List<String>> tags = await firestoreManager.getTags();
    // Devuelve un mapa con los datos
    return {
      "theme": theme,
      "books": books,
      "tags": tags,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

  bool expanded = true;

  @override
  void initState() {
    super.initState();
    // Asigna un valor diferente en la primera carga
    expanded = false;
  }

  List<String> selectedCategories = [];
  List<String> selectedGenres = [];
  List<String> selectedEditorials = [];
  List<String> selectedLanguages = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Carga
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Error
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          // Ejecucion
          final data = snapshot.data!;
          List<String> categories = data["tags"]["categories"];
          List<String> genres = data["tags"]["genres"];
          List<String> editorials = data["tags"]["editorials"];
          List<String> languages = data["tags"]["languages"];
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
                text: getLang("catalog"),
              ),
              backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
            ),
            backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
            body: Padding(
              padding: bodyPadding,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    initiallyExpanded: expanded,
                    iconColor: colors[data["theme"]]["linkTextColor"],
                    // onExpansionChanged: ,
                    title: Row(
                      children: [
                        Expanded(
                          child: NormalText(
                            text: getLang("filters"),
                          ),
                        ),
                        !isAndroid
                            ? HelpTooltip(
                                message: getLang("hScrollTooltip"),
                                theme: data["theme"],
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BetterDivider(),
                            //* Filtros para | Categorias |
                            NormalText(text: getLang("categories")),
                            const BetterDivider(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: categories.map((tag) {
                                      return FilterChip(
                                        labelStyle: getStyle(
                                            "genreFilterChipStyle",
                                            data["theme"]),
                                        selectedColor: colors[data["theme"]]
                                            ["linkTextColor"],
                                        backgroundColor: colors[data["theme"]]
                                            ["chipBackgroundColor"],
                                        label: Text(tag),
                                        selected:
                                            selectedCategories.contains(tag),
                                        onSelected: (bool selected) {
                                          setState(() {
                                            expanded = true;
                                            if (selected) {
                                              selectedCategories.add(tag);
                                            } else {
                                              selectedCategories.remove(tag);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const BetterDivider(),
                            //* Filtros para | Generos |
                            NormalText(text: getLang("genres")),
                            const BetterDivider(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
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
                            ),
                            const BetterDivider(),
                            //* Filtros para | Editoriales |
                            NormalText(text: getLang("editorials")),
                            const BetterDivider(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: editorials.map((tag) {
                                  return FilterChip(
                                    labelStyle: getStyle(
                                        "genreFilterChipStyle",
                                        data["theme"]),
                                    selectedColor: colors[data["theme"]]
                                        ["linkTextColor"],
                                    backgroundColor: colors[data["theme"]]
                                        ["chipBackgroundColor"],
                                    label: Text(tag),
                                    selected:
                                        selectedEditorials.contains(tag),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        expanded = true;
                                        if (selected) {
                                          selectedEditorials.add(tag);
                                        } else {
                                          selectedEditorials.remove(tag);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            const BetterDivider(),
                            //* Filtros para | Idiomas |
                            NormalText(text: getLang("languages")),
                            const BetterDivider(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: languages.map((tag) {
                                  return FilterChip(
                                    labelStyle: getStyle(
                                        "genreFilterChipStyle",
                                        data["theme"]),
                                    selectedColor: colors[data["theme"]]
                                        ["linkTextColor"],
                                    backgroundColor: colors[data["theme"]]
                                        ["chipBackgroundColor"],
                                    label: Text(tag),
                                    selected: selectedLanguages.contains(tag),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        expanded = true;
                                        if (selected) {
                                          selectedLanguages.add(tag);
                                        } else {
                                          selectedLanguages.remove(tag);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            const BetterDivider(),
                            Center(
                              child: OutlinedButton(
                                  style: getStyle(
                                      "filtersButtonStyle", data["theme"]),
                                  onPressed: () {
                                    selectedCategories.clear();
                                    selectedGenres.clear();
                                    selectedEditorials.clear();
                                    selectedLanguages.clear();
                                    setState(() {});
                                  },
                                  child: Text(getLang("cleanFilters"))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BetterDivider(),
                  Expanded(
                    child: BookList(
                      books: data["books"],
                      categoriesFilter: selectedCategories,
                      genresFilter: selectedGenres,
                      editorialsFilter: selectedEditorials,
                      languagesFilter: selectedLanguages,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
