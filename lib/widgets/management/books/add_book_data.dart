import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/management/books/add_book.dart';
import 'package:tfg_library/widgets/management/select_dialog_field.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/description_richtext.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class AddBookData extends StatefulWidget {
  const AddBookData({
    super.key,
    required this.theme,
    this.bookkey,
    required this.onRefresh,
  });

  final String theme;
  final String? bookkey;
  final VoidCallback onRefresh;

  @override
  State<AddBookData> createState() => AddBookDataState();
}

bool bookLoaded = false;
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

bool buttonUsed = false;

class AddBookDataState extends State<AddBookData> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, List<String>> tags = await firestoreManager.getTags();
    Map<String, dynamic> book = {};
    if (widget.bookkey != null && widget.bookkey!.isNotEmpty) {
      bookLoaded = true;
      book = await firestoreManager.getMergedBook(widget.bookkey!);
    }
    return {
      "tags": tags,
      "book": book,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();
  StorageManager storageManager = StorageManager();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    // Asigna el valor de la primera carga
    clearData();
  }

  void clearData() {
    bookLoaded = false;
    titleController = TextEditingController();
    title = "";
    authorController = TextEditingController();
    author = "";
    editorialController = TextEditingController();
    editorial = "";
    dateController = TextEditingController();
    date = "";
    pagesController = TextEditingController();
    pages = "";
    languageController = TextEditingController();
    language = "";
    isbnController = TextEditingController();
    isbn = "";
    ageController = TextEditingController();
    age = "";
    stateController = TextEditingController();
    state = "";
    categoryController = TextEditingController();
    category = "";
    genresController = TextEditingController();
    genres = [];
    descriptionController = TextEditingController();
    description = "";

    image = null;

    buttonUsed = false;
  }

  void loadBookData(Map book) {
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
    stateController.text = getLang("aviable");
    state = getLang("aviable");
    categoryController.text = book["category"];
    category = book["category"];
    genresController.text = book["genres"].join(", ");
    genres = book["genres"];
    description = book["description"].replaceAll("<n><n>", "\n");
    descriptionController.text = description;

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

  void refresh() {
    setState(() {});
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
            var theme = widget.theme;
            var tags = data["tags"];
            var book = data["book"];
            if (bookLoaded) {
              loadBookData(book);
            }
            return FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  // ? Titulo
                  TextSelectionTheme(
                    data: getStyle("loginFieldSelectionTheme", theme),
                    child: FormBuilderTextField(
                      controller: titleController,
                      readOnly: bookLoaded,
                      name: "title",
                      style: getStyle("normalTextStyle", theme),
                      decoration: getTextFieldStyle(
                          "defaultTextFieldStyle", theme, getLang("title"), ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ? Autor
                  TextSelectionTheme(
                    data: getStyle("loginFieldSelectionTheme", theme),
                    child: FormBuilderTextField(
                      controller: authorController,
                      readOnly: bookLoaded,
                      name: "author",
                      style: getStyle("normalTextStyle", theme),
                      decoration: getTextFieldStyle("defaultTextFieldStyle",
                          theme, getLang("author"), ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
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
                      decoration: getTextFieldStyle("defaultTextFieldStyle",
                          theme, getLang("editorial"), ""),
                      onTap: !bookLoaded
                          ? () async {
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
                            }
                          : null,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
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
                          "defaultTextFieldStyle", theme, getLang("date"), ""),
                      onTap: !bookLoaded
                          ? () async {
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
                            }
                          : null,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ? Paginas
                  TextSelectionTheme(
                    data: getStyle("loginFieldSelectionTheme", theme),
                    child: FormBuilderTextField(
                      controller: pagesController,
                      readOnly: bookLoaded,
                      name: "pages",
                      style: getStyle("normalTextStyle", theme),
                      decoration: getTextFieldStyle(
                          "defaultTextFieldStyle", theme, getLang("pages"), ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
                        FormBuilderValidators.numeric(
                          errorText: getLang("formError-numeric"),
                        )
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
                      decoration: getTextFieldStyle("defaultTextFieldStyle",
                          theme, getLang("language"), ""),
                      onTap: !bookLoaded
                          ? () async {
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
                            }
                          : null,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ? ISBN
                  TextSelectionTheme(
                    data: getStyle("loginFieldSelectionTheme", theme),
                    child: FormBuilderTextField(
                      controller: isbnController,
                      readOnly: bookLoaded,
                      name: "isbn",
                      style: getStyle("normalTextStyle", theme),
                      decoration: getTextFieldStyle(
                          "defaultTextFieldStyle", theme, getLang("isbn"), ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ? Edad
                  TextSelectionTheme(
                    data: getStyle("loginFieldSelectionTheme", theme),
                    child: FormBuilderTextField(
                      controller: ageController,
                      readOnly: bookLoaded,
                      name: "age",
                      style: getStyle("normalTextStyle", theme),
                      decoration: getTextFieldStyle(
                          "defaultTextFieldStyle", theme, getLang("age"), ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
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
                          "defaultTextFieldStyle", theme, getLang("state"), ""),
                      onTap: () async {
                        SelectDialog.showModal(context,
                            showSearchBox: false,
                            backgroundColor: colors[theme]
                                ["mainBackgroundColor"],
                            selectedValue: state,
                            items: [getLang("aviable"), getLang("notAviable")],
                            itemBuilder: (context, item, isSelected) {
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
                          errorText: getLang("formError-required"),
                        ),
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
                      decoration: getTextFieldStyle("defaultTextFieldStyle",
                          theme, getLang("category"), ""),
                      onTap: !bookLoaded
                          ? () async {
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
                              });
                            }
                          : null,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
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
                      decoration: getTextFieldStyle("defaultTextFieldStyle",
                          theme, getLang("genres"), ""),
                      onTap: !bookLoaded
                          ? () async {
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
                                    text: getLang("accept"),
                                  ),
                                );
                              });
                            }
                          : null,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
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
                      readOnly: bookLoaded,
                      name: "description",
                      style: getStyle("normalTextStyle", theme),
                      decoration: getTextFieldStyle("defaultTextFieldStyle",
                          theme, getLang("sinopsis"), ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: getLang("formError-required"),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ? Seleccionar imagen
                  image == null
                      ? GestureDetector(
                          onTap: !loadBook
                              ? () async {
                                  _pickImage();
                                }
                              : null,
                          child: Container(
                            color: colors[theme]["secondaryBackgroundColor"],
                            constraints: const BoxConstraints(
                              minWidth: 250,
                              maxWidth: 300,
                              minHeight: 350,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image),
                                DescriptionRichText(
                                  theme: theme,
                                  text: getLang("imageSelect"),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: !loadBook
                              ? () async {
                                  _pickImage();
                                }
                              : null,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 250,
                              maxWidth: 300,
                              minHeight: 350,
                            ),
                            child: Image.memory(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),
                  // ? Añadir el libro
                  DefaultButton(
                    theme: theme,
                    text: getLang("addBook"),
                    onClick: () async {
                      if (!buttonUsed) {
                        buttonUsed = true;
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
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
                            "pages": int.parse(pagesController.text),
                            "return_date": "",
                            "description": descriptionController.text
                                .replaceAll("\n", "<n><n>"),
                          };
                          await firestoreManager.addBook(book);
                          if (!loadBook) {
                            await storageManager.addImage(
                                image!, isbnController.text);
                          }
                          showSnackBar(
                            context,
                            getLang("addBook-success"),
                          );
                          widget.onRefresh();
                        }
                        buttonUsed = false;
                      }
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        });
  }
}
