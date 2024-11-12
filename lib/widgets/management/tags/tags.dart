import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/management/tags/tags_tile.dart';

class Tags extends StatefulWidget {
  const Tags({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<Tags> createState() => TagsState();
}

class TagsState extends State<Tags> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> tags = await firestoreManager.getTags();
    List<String> contactTypes = await firestoreManager.getContactTypes();
    return {
      "tags": tags,
      "contactTypes": contactTypes,
    };
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
    contactTypesExpanded = false;
    genresExpanded = false;
    categoriesExpanded = false;
    languagesExpanded = false;
    editorialsExpanded = false;
  }

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  FirestoreManager firestoreManager = FirestoreManager();
  String theme = "";
  bool contactTypesExpanded = false;
  bool genresExpanded = false;
  bool categoriesExpanded = false;
  bool languagesExpanded = false;
  bool editorialsExpanded = false;

  void updateContactTypes(List<String> contactTypes) async {
    await firestoreManager.updateContactType(contactTypes);
  }

  void updateEditorials(List<String> editorials) async {
    await firestoreManager.updateEditorials(editorials);
  }

  void updateCategories(List<String> categories) async {
    await firestoreManager.updateCategories(categories);
  }

  void updateGenres(List<String> genres) async {
    await firestoreManager.updateGenres(genres);
  }

  void updateLanguages(List<String> languages) async {
    await firestoreManager.updateLanguages(languages);
  }

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
            return const Center(
              child: Text("Error"),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var contactTypes = data["contactTypes"];
            var tags = data["tags"];
            return ListView(
              children: [
                Padding(
                  padding: bodyPadding,
                  child: Column(
                    children: [
                      // ? Tipos de soporte
                      TagsTile(
                        theme: theme,
                        expandedState: contactTypesExpanded,
                        tagsList: contactTypes,
                        title: getLang("contactTypes"),
                        onAdd: updateContactTypes,
                        onDelete: updateContactTypes,
                        deleteText: getLang("deleteContactTypeDialog-title"),
                      ),
                      const SizedBox(height: 30),
                      // ? Editoriales
                      TagsTile(
                        theme: theme,
                        expandedState: editorialsExpanded,
                        tagsList: tags["editorials"],
                        title: getLang("editorials"),
                        onAdd: updateEditorials,
                        onDelete: updateEditorials,
                        deleteText: getLang("deleteEditorial-title"),
                      ),
                      const SizedBox(height: 30),
                      // ? Idioma
                      TagsTile(
                        theme: theme,
                        expandedState: languagesExpanded,
                        tagsList: tags["languages"],
                        title: getLang("languages"),
                        onAdd: updateLanguages,
                        onDelete: updateLanguages,
                        deleteText: getLang("deleteLanguage-title"),
                      ),
                      const SizedBox(height: 30),
                      // ? Categoria
                      TagsTile(
                        theme: theme,
                        expandedState: categoriesExpanded,
                        tagsList: tags["categories"],
                        title: getLang("categories"),
                        onAdd: updateCategories,
                        onDelete: updateCategories,
                        deleteText: getLang("deleteCategory-title"),
                      ),
                      const SizedBox(height: 30),
                      // ? Genero
                      TagsTile(
                        theme: theme,
                        expandedState: genresExpanded,
                        tagsList: tags["genres"],
                        title: getLang("genres"),
                        onAdd: updateGenres,
                        onDelete: updateGenres,
                        deleteText: getLang("deleteGenre-title"),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
