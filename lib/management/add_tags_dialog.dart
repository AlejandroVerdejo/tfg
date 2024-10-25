import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class AddTagsDialog extends StatelessWidget {
  const AddTagsDialog({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  Widget build(BuildContext context) {
    TextEditingController editorialController = TextEditingController();
    TextEditingController languageController = TextEditingController();
    TextEditingController genreController = TextEditingController();
    TextEditingController categoryController = TextEditingController();

    FirestoreManager firestoreManager = FirestoreManager();

    return AlertDialog(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      title: NormalText(
        theme: theme,
        text: getLang("addTags"),
      ),
      content: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextSelectionTheme(
              data: getStyle("loginFieldSelectionTheme", theme),
              child: TextField(
                style: getStyle("normalTextStyle", theme),
                controller: editorialController,
                decoration: getTextFieldStyle(
                    "defaultTextFieldStyle", theme, getLang("editorial")),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: getStyle("loginButtonStyle", theme),
            onPressed: () async {
              if (editorialController.text.isNotEmpty) {
                firestoreManager.addEditorial(editorialController.text);
                editorialController.text = "";
              }
            },
            child: Text(
              getLang("addTag-editorial"),
            ),
          ),
          const SizedBox(height: 10),
          BetterDivider(theme: theme),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextSelectionTheme(
              data: getStyle("loginFieldSelectionTheme", theme),
              child: TextField(
                style: getStyle("normalTextStyle", theme),
                controller: languageController,
                decoration: getTextFieldStyle(
                    "defaultTextFieldStyle", theme, getLang("language")),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: getStyle("loginButtonStyle", theme),
            onPressed: () async {
              if (languageController.text.isNotEmpty) {
                firestoreManager.addLanguage(languageController.text);
                languageController.text = "";
              }
            },
            child: Text(
              getLang("addTag-language"),
            ),
          ),
          const SizedBox(height: 10),
          BetterDivider(theme: theme),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextSelectionTheme(
              data: getStyle("loginFieldSelectionTheme", theme),
              child: TextField(
                style: getStyle("normalTextStyle", theme),
                controller: categoryController,
                decoration: getTextFieldStyle(
                    "defaultTextFieldStyle", theme, getLang("category")),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: getStyle("loginButtonStyle", theme),
            onPressed: () async {
              if (categoryController.text.isNotEmpty) {
                firestoreManager.addCategory(categoryController.text);
                categoryController.text = "";
              }
            },
            child: Text(
              getLang("addTag-category"),
            ),
          ),
          const SizedBox(height: 10),
          BetterDivider(theme: theme),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextSelectionTheme(
              data: getStyle("loginFieldSelectionTheme", theme),
              child: TextField(
                style: getStyle("normalTextStyle", theme),
                controller: genreController,
                decoration: getTextFieldStyle(
                    "defaultTextFieldStyle", theme, getLang("genre")),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: getStyle("loginButtonStyle", theme),
            onPressed: () async {
              if (genreController.text.isNotEmpty) {
                firestoreManager.addGenre(genreController.text);
                genreController.text = "";
              }
            },
            child: Text(
              getLang("addTag-genre"),
            ),
          ),
          const SizedBox(height: 10),
          BetterDivider(theme: theme),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
