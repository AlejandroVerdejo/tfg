import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';
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
  FirestoreManager firestoreManager = FirestoreManager();
  final _formEditorialKey = GlobalKey<FormBuilderState>();
  final _formLanguageKey = GlobalKey<FormBuilderState>();
  final _formCategoryKey = GlobalKey<FormBuilderState>();
  final _formGenreKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController editorialController = TextEditingController();
    TextEditingController languageController = TextEditingController();
    TextEditingController genreController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    var theme = widget.theme;
    return AlertDialog(
      backgroundColor: colors[widget.theme]["mainBackgroundColor"],
      title: NormalText(
        theme: theme,
        text: getLang("addTags"),
      ),
      content: Container(
        width: dialogWidth,
        padding: dialogPadding,
        child: ListView(
          children: [
            Column(
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
                          decoration: getTextFieldStyle("defaultTextFieldStyle",
                              theme, getLang("editorial"), ""),
                          obscureText: true,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: getStyle("loginButtonStyle", widget.theme),
                        onPressed: () async {
                          if (_formEditorialKey.currentState
                                  ?.saveAndValidate() ??
                              false) {
                            firestoreManager
                                .addEditorial(editorialController.text);
                            editorialController.text = "";
                          }
                        },
                        child: Text(
                          getLang("addTag-editorial"),
                        ),
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
                          decoration: getTextFieldStyle("defaultTextFieldStyle",
                              theme, getLang("language"), ""),
                          obscureText: true,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: getStyle("loginButtonStyle", widget.theme),
                        onPressed: () async {
                          if (_formLanguageKey.currentState
                                  ?.saveAndValidate() ??
                              false) {
                            firestoreManager
                                .addLanguage(languageController.text);
                            languageController.text = "";
                          }
                        },
                        child: Text(
                          getLang("addTag-language"),
                        ),
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
                          decoration: getTextFieldStyle("defaultTextFieldStyle",
                              theme, getLang("category"), ""),
                          obscureText: true,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: getStyle("loginButtonStyle", widget.theme),
                        onPressed: () async {
                          if (_formCategoryKey.currentState
                                  ?.saveAndValidate() ??
                              false) {
                            firestoreManager
                                .addCategory(categoryController.text);
                            categoryController.text = "";
                          }
                        },
                        child: Text(
                          getLang("addTag-category"),
                        ),
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
                          decoration: getTextFieldStyle("defaultTextFieldStyle",
                              theme, getLang("genre"), ""),
                          obscureText: true,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: getStyle("loginButtonStyle", widget.theme),
                        onPressed: () async {
                          if (_formGenreKey.currentState?.saveAndValidate() ??
                              false) {
                            firestoreManager.addGenre(genreController.text);
                            genreController.text = "";
                          }
                        },
                        child: Text(
                          getLang("addTag-genre"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                BetterDivider(theme: theme),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
