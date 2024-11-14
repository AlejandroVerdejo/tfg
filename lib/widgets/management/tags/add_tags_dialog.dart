import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class AddTagsDialog extends StatefulWidget {
  const AddTagsDialog({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<AddTagsDialog> createState() => _AddTagsDialogState();
}

class _AddTagsDialogState extends State<AddTagsDialog> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> tags = await firestoreManager.getTags();
    return {"tags": tags};
  }

  FirestoreManager firestoreManager = FirestoreManager();
  final _formEditorialKey = GlobalKey<FormBuilderState>();
  final _formLanguageKey = GlobalKey<FormBuilderState>();
  final _formCategoryKey = GlobalKey<FormBuilderState>();
  final _formGenreKey = GlobalKey<FormBuilderState>();

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController editorialController = TextEditingController();
    TextEditingController languageController = TextEditingController();
    TextEditingController genreController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    var theme = widget.theme;
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
            var tags = data["tags"];
            return AlertDialog(
              backgroundColor: colors[widget.theme]["mainBackgroundColor"],
              title: NormalText(
                theme: theme,
                text: getLang("addTags"),
              ),
              scrollable: true,
              content: Container(
                width: dialogWidth,
                padding: dialogPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ? Editorial
                    FormBuilder(
                      key: _formEditorialKey,
                      child: Column(
                        children: [
                          TextSelectionTheme(
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "editorial",
                              controller: editorialController,
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle",
                                  theme,
                                  getLang("editorial"),
                                  ""),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: getLang("formError-required"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ? Añadir editorial
                          DefaultButton(
                            theme: theme,
                            text: getLang("addTag-editorial"),
                            onClick: () async {
                              if (_formEditorialKey.currentState
                                      ?.saveAndValidate() ??
                                  false) {
                                if (!tags["editorials"]
                                    .contains(editorialController.text)) {
                                  firestoreManager
                                      .addEditorial(editorialController.text);
                                  editorialController.text = "";
                                } else {
                                  showSnackBar(
                                      context, getLang("tagRegister-error"));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BetterDivider(theme: theme),
                    const SizedBox(height: 20),
                    // ? Idioma
                    FormBuilder(
                      key: _formLanguageKey,
                      child: Column(
                        children: [
                          TextSelectionTheme(
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "language",
                              controller: languageController,
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle",
                                  theme,
                                  getLang("language"),
                                  ""),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: getLang("formError-required"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ? Añadir idioma
                          DefaultButton(
                            theme: theme,
                            text: getLang("addTag-language"),
                            onClick: () async {
                              if (_formLanguageKey.currentState
                                      ?.saveAndValidate() ??
                                  false) {
                                if (!tags["languages"]
                                    .contains(languageController.text)) {
                                  firestoreManager
                                      .addLanguage(languageController.text);
                                  languageController.text = "";
                                } else {
                                  showSnackBar(
                                      context, getLang("tagRegister-error"));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BetterDivider(theme: theme),
                    const SizedBox(height: 20),
                    // ? Categoria
                    FormBuilder(
                      key: _formCategoryKey,
                      child: Column(
                        children: [
                          TextSelectionTheme(
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "category",
                              controller: categoryController,
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle",
                                  theme,
                                  getLang("category"),
                                  ""),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: getLang("formError-required"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ? Añadir categoria
                          DefaultButton(
                            theme: theme,
                            text: getLang("addTag-category"),
                            onClick: () async {
                              if (_formCategoryKey.currentState
                                      ?.saveAndValidate() ??
                                  false) {
                                if (!tags["categories"]
                                    .contains(categoryController.text)) {
                                  firestoreManager
                                      .addCategory(categoryController.text);
                                  categoryController.text = "";
                                } else {
                                  showSnackBar(
                                      context, getLang("tagRegister-error"));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BetterDivider(theme: theme),
                    const SizedBox(height: 20),
                    // ? Genero
                    FormBuilder(
                      key: _formGenreKey,
                      child: Column(
                        children: [
                          TextSelectionTheme(
                            data: getStyle("loginFieldSelectionTheme", theme),
                            child: FormBuilderTextField(
                              name: "genre",
                              controller: genreController,
                              style: getStyle("normalTextStyle", theme),
                              decoration: getTextFieldStyle(
                                  "defaultTextFieldStyle",
                                  theme,
                                  getLang("genre"),
                                  ""),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: getLang("formError-required"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ? Añadir genero
                          DefaultButton(
                            theme: theme,
                            text: getLang("addTag-genre"),
                            onClick: () async {
                              if (_formGenreKey.currentState
                                      ?.saveAndValidate() ??
                                  false) {
                                if (!tags["genres"]
                                    .contains(genreController.text)) {
                                  firestoreManager
                                      .addGenre(genreController.text);
                                  genreController.text = "";
                                } else {
                                  showSnackBar(
                                      context, getLang("tagRegister-error"));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
