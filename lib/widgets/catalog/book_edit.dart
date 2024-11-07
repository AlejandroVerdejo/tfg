import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/description_richtext.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class BookEdit extends StatefulWidget {
  const BookEdit({
    super.key,
    required this.theme,
    required this.book,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> book;
  final Map<String, dynamic> user;

  @override
  State<BookEdit> createState() => _BookEditState();
}

TextEditingController titleController = TextEditingController();
String title = "";
TextEditingController authorController = TextEditingController();
String author = "";
TextEditingController editorialController = TextEditingController();
String editorial = "";
TextEditingController dateController = TextEditingController();
String date = "";
TextEditingController pagesController = TextEditingController();
String pages = "";
TextEditingController languageController = TextEditingController();
String language = "";
TextEditingController isbnController = TextEditingController();
String isbn = "";
TextEditingController ageController = TextEditingController();
String age = "";
TextEditingController stateController = TextEditingController();
String state = "";
TextEditingController categoryController = TextEditingController();
String category = "";
TextEditingController genresController = TextEditingController();
List<dynamic> genres = [];
TextEditingController descriptionController = TextEditingController();
String description = "";

Uint8List? image;

FirestoreManager firestoreManager = FirestoreManager();

class _BookEditState extends State<BookEdit> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<Map<String, dynamic>> _loadPreferences() async {
    Map<String, List<String>> tags = await firestoreManager.getTags();
    return {
      "tags": tags,
    };
  }

  @override
  void initState() {
    super.initState();
    var book = widget.book;
    titleController.text = book["title"];
    title = book["title"];
    authorController.text = book["author"];
    author = book["author"];
    editorialController.text = book["editorial"];
    editorial = book["editorial"];
    dateController.text = book["date"];
    date = book["date"];
    pagesController.text = book["pages"].toString();
    pages = book["pages"].toString();
    languageController.text = book["language"];
    language = book["language"];
    isbnController.text = book["isbn"];
    isbn = book["isbn"];
    ageController.text = book["age"];
    age = book["age"];
    stateController.text =
        book["aviable"] ? getLang("aviable") : getLang("notAviable");
    state = book["aviable"] ? getLang("aviable") : getLang("notAviable");
    categoryController.text = book["category"];
    category = book["category"];
    genresController.text = book["genres"].join(", ");
    genres = book["genres"];
    descriptionController.text = book["description"];
    description = book["description"];

    image = book["image"];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: bodyPadding,
          child: FutureBuilder(
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
                  var theme = widget.theme;
                  var tags = data["tags"];
                  return FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // ? Titulo
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: titleController,
                            name: "title",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("title"), ""),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Autor
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: authorController,
                            name: "author",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("author"), ""),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Editorial
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: editorialController,
                            readOnly: true,
                            name: "editorial",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("editorial"), ""),
                            onTap: () async {
                              SelectDialog.showModal(context,
                                  showSearchBox: false,
                                  backgroundColor: colors[theme]
                                      ["mainBackgroundColor"],
                                  selectedValue: editorial,
                                  items: tags["editorials"],
                                  itemBuilder: (context, item, isSelected) {
                                return SelectDialogField(
                                  theme: theme,
                                  item: item,
                                  isSelected: isSelected,
                                );
                              }, onChange: (String selected) {
                                editorial = selected;
                                editorialController.text = editorial;
                                // setState(() {});
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Fecha de publicación
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: dateController,
                            readOnly: true,
                            name: "date",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("date"), ""),
                            onTap: () async {
                              DateTime? datePicked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1800),
                                  lastDate: DateTime(2100),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                        data:
                                            getStyle("datePickerStyle", theme),
                                        child: child!);
                                  });
                              if (datePicked != null) {
                                // dateLoaded = true;
                                dateController.text =
                                    DateFormat("dd/MM/yyyy").format(datePicked);
                                date =
                                    DateFormat("dd/MM/yyyy").format(datePicked);
                                // setState(() {});
                              }
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Paginas
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: pagesController,
                            name: "pages",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("pages"), ""),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                              FormBuilderValidators.numeric(
                                  errorText: getLang("formError-numeric"))
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Idioma
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: languageController,
                            readOnly: true,
                            name: "language",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("language"), ""),
                            onTap: () async {
                              SelectDialog.showModal(context,
                                  showSearchBox: false,
                                  backgroundColor: colors[theme]
                                      ["mainBackgroundColor"],
                                  selectedValue: language,
                                  items: tags["languages"],
                                  itemBuilder: (context, item, isSelected) {
                                return SelectDialogField(
                                  theme: theme,
                                  item: item,
                                  isSelected: isSelected,
                                );
                              }, onChange: (String selected) {
                                language = selected;
                                languageController.text = language;
                                // setState(() {});
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? ISBN
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: isbnController,
                            name: "isbn",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("isbn"), ""),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Edad
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: ageController,
                            name: "age",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle", theme, getLang("age"), ""),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Estado
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: stateController,
                            readOnly: true,
                            name: "state",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("state"), ""),
                            onTap: () async {
                              SelectDialog.showModal(context,
                                  showSearchBox: false,
                                  backgroundColor: colors[theme]
                                      ["mainBackgroundColor"],
                                  selectedValue: state,
                                  items: [
                                    getLang("aviable"),
                                    getLang("notAviable")
                                  ], itemBuilder: (context, item, isSelected) {
                                return SelectDialogField(
                                  theme: theme,
                                  item: item,
                                  isSelected: isSelected,
                                );
                              }, onChange: (String selected) {
                                state = selected;
                                stateController.text = state;
                                // setState(() {});
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Categoria
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: categoryController,
                            readOnly: true,
                            name: "category",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("category"), ""),
                            onTap: () async {
                              SelectDialog.showModal(context,
                                  showSearchBox: false,
                                  backgroundColor: colors[theme]
                                      ["mainBackgroundColor"],
                                  selectedValue: category,
                                  items: tags["categories"],
                                  itemBuilder: (context, item, isSelected) {
                                return SelectDialogField(
                                  theme: theme,
                                  item: item,
                                  isSelected: isSelected,
                                );
                              }, onChange: (String selected) {
                                category = selected;
                                categoryController.text = category;
                                // setState(() {});
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Generos
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            controller: genresController,
                            readOnly: true,
                            name: "genres",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("genres"), ""),
                            onTap: () async {
                              SelectDialog.showModal(context,
                                  showSearchBox: false,
                                  backgroundColor: colors[theme]
                                      ["mainBackgroundColor"],
                                  multipleSelectedValues: genres,
                                  items: tags["genres"],
                                  itemBuilder: (context, item, isSelected) {
                                return SelectDialogField(
                                  theme: theme,
                                  item: item,
                                  isSelected: isSelected,
                                );
                              }, onMultipleItemsChange:
                                      (List<dynamic> selected) {
                                genres = selected;
                                genresController.text = genres.join(", ");
                                // setState(() {});
                              }, okButtonBuilder: (context, onPressed) {
                                return TextButton(
                                    onPressed: onPressed,
                                    child: NormalText(
                                        theme: theme,
                                        text: getLang("selectDialogButton")));
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Sinopsis
                        TextSelectionTheme(
                          data: getStyle("loginFieldSelectionTheme", theme),
                          child: FormBuilderTextField(
                            maxLines: null,
                            controller: descriptionController,
                            name: "description",
                            style: getStyle("normalTextStyle", theme),
                            decoration: getTextFieldStyle(
                                "defaultTextFieldStyle",
                                theme,
                                getLang("sinopsis"), ""),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: getLang("formError-required")),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ? Seleccionar imagen
                        image == null
                            ? GestureDetector(
                                child: Container(
                                  color: colors[theme]
                                      ["secondaryBackgroundColor"],
                                  constraints: BoxConstraints(
                                    minWidth: 250, // Ancho mínimo
                                    maxWidth: 300, // Ancho máximo
                                    minHeight: 350, // Altura mínima
                                    // maxHeight: 400, // Altura máxima
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.image),
                                      DescriptionRichText(
                                          theme: theme,
                                          text: "Selecciona una imagen"),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  _pickImage();
                                },
                              )
                            : GestureDetector(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: 250, // Ancho mínimo
                                    maxWidth: 300, // Ancho máximo
                                    minHeight: 350, // Altura mínima
                                    // maxHeight: 400, // Altura máxima
                                  ),
                                  child: Image.memory(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () async {
                                  _pickImage();
                                },
                              ),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          style: getStyle("loginButtonStyle", theme),
                          onPressed: () async {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              Map<String, dynamic> book = {
                                "title": titleController.text,
                                "author": authorController.text,
                                "isbn": isbnController.text,
                                "aviable":
                                    stateController.text == getLang("aviable")
                                        ? true
                                        : false,
                                "category": categoryController.text,
                                "date": dateController.text,
                                "age": ageController.text,
                                "editorial": editorialController.text,
                                "genres": genres,
                                "language": languageController.text,
                                // "id": "",
                                "pages": int.parse(pagesController.text),
                                "return_date": "",
                                "description": descriptionController.text
                                    .replaceAll("\n", "<n><n>"),
                              };
                              await firestoreManager.addBook(book);
                              // if (!loadBook) {
                              //   await storageManager.addImage(image!, isbnController.text);
                              // }
                            } else {}
                          },
                          child: Text(
                            getLang("addBook"),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }
}
