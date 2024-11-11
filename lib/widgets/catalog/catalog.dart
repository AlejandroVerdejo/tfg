import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/catalog/book_list.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/help_tooltip.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
// }

class Catalog extends StatefulWidget {
  const Catalog({
    super.key,
    required this.theme,
    required this.user,
    required this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> user;
  final Function(String) onScreenChange;

  @override
  State<Catalog> createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  Future<Map<String, dynamic>> _loadData() async {
    // Obtiene los | Libros |
    Map<String, dynamic> books = widget.user["level"] <= 1
        ? await firestoreManager.getUnMergedBooks()
        : await firestoreManager.getMergedBooks();
    // Obtiene los Tags | Categorias | Generos | Editoriales | Idiomas |
    Map<String, List<String>> tags = await firestoreManager.getTags();
    // Devuelve un mapa con los datos
    return {
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
    theme = widget.theme;
  }

  void refresh() {
    setState(() {});
  }

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  List<String> selectedCategories = [];
  List<String> selectedGenres = [];
  List<String> selectedEditorials = [];
  List<String> selectedLanguages = [];

  String theme = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Carga
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          // Error
          return const LoadingErrorWidget();
        } else {
          // Ejecucion
          final data = snapshot.data!;
          var tags = data["tags"];
          var books = data["books"];
          List<String> categories = tags["categories"];
          List<String> genres = tags["genres"];
          List<String> editorials = tags["editorials"];
          List<String> languages = tags["languages"];
          return ListView(
            children: [
              Container(
                padding: bodyPadding,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          ExpansionTile(
                            initiallyExpanded: expanded,
                            iconColor: colors[theme]["linkTextColor"],
                            // onExpansionChanged: ,
                            title: Row(
                              children: [
                                Expanded(
                                  child: NormalText(
                                    theme: theme,
                                    text: getLang("filters"),
                                  ),
                                ),
                                !isAndroid
                                    ? HelpTooltip(
                                        message: getLang("hScrollTooltip"),
                                        theme: theme,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            childrenPadding: expansionPadding,
                            children: [
                              BetterDivider(theme: theme),
                              //* Filtros para | Categorias |
                              NormalText(
                                theme: theme,
                                text: getLang("categories"),
                              ),
                              BetterDivider(theme: theme),
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
                                              "genreFilterChipStyle", theme),
                                          selectedColor: colors[theme]
                                              ["linkTextColor"],
                                          backgroundColor: colors[theme]
                                              ["chipBackgroundColor"],
                                          label: Text(tag),
                                          side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0), // Cambia la forma del borde
                                          ),
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
                              BetterDivider(theme: theme),
                              //* Filtros para | Generos |
                              NormalText(
                                theme: theme,
                                text: getLang("genres"),
                              ),
                              BetterDivider(theme: theme),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: genres.map((tag) {
                                    return FilterChip(
                                      labelStyle: getStyle(
                                          "genreFilterChipStyle", theme),
                                      selectedColor: colors[theme]
                                          ["linkTextColor"],
                                      backgroundColor: colors[theme]
                                          ["chipBackgroundColor"],
                                      label: Text(tag),
                                      side: const BorderSide(
                                          width: 0, color: Colors.transparent),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Cambia la forma del borde
                                      ),
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
                              BetterDivider(theme: theme),
                              //* Filtros para | Editoriales |
                              NormalText(
                                theme: theme,
                                text: getLang("editorials"),
                              ),
                              BetterDivider(theme: theme),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: editorials.map((tag) {
                                    return FilterChip(
                                      labelStyle: getStyle(
                                          "genreFilterChipStyle", theme),
                                      selectedColor: colors[theme]
                                          ["linkTextColor"],
                                      backgroundColor: colors[theme]
                                          ["chipBackgroundColor"],
                                      label: Text(tag),
                                      side: const BorderSide(
                                          width: 0, color: Colors.transparent),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Cambia la forma del borde
                                      ),
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
                              BetterDivider(theme: theme),
                              //* Filtros para | Idiomas |
                              NormalText(
                                theme: theme,
                                text: getLang("languages"),
                              ),
                              BetterDivider(theme: theme),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: languages.map((tag) {
                                    return FilterChip(
                                      labelStyle: getStyle(
                                          "genreFilterChipStyle", theme),
                                      selectedColor: colors[theme]
                                          ["linkTextColor"],
                                      backgroundColor: colors[theme]
                                          ["chipBackgroundColor"],
                                      label: Text(tag),
                                      side: const BorderSide(
                                          width: 0, color: Colors.transparent),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Cambia la forma del borde
                                      ),
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
                              BetterDivider(theme: theme),
                              Center(
                                child: DefaultButton(
                                  theme: theme,
                                  text: getLang("cleanFilters"),
                                  onClick: () {
                                    selectedCategories.clear();
                                    selectedGenres.clear();
                                    selectedEditorials.clear();
                                    selectedLanguages.clear();
                                    setState(() {});
                                  },
                                  style: "filtersButtonStyle",
                                ),
                              ),
                              BetterDivider(theme: theme),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BetterDivider(theme: theme),
                    BookList(
                      theme: theme,
                      user: widget.user,
                      books: books,
                      categoriesFilter: selectedCategories,
                      genresFilter: selectedGenres,
                      editorialsFilter: selectedEditorials,
                      languagesFilter: selectedLanguages,
                      onRefresh: refresh,
                      onScreenChange: widget.onScreenChange,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
