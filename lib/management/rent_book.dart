import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/management/rent_book_book_data.dart';
import 'package:tfg_library/management/rent_book_user_data.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';

class RentBook extends StatefulWidget {
  const RentBook({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<RentBook> createState() => _RentBookState();
}

FirestoreManager firestoreManager = FirestoreManager();

TextEditingController bookController = TextEditingController();
bool bookLoaded = false;
String book = "";
bool bookAviable = false;
TextEditingController userController = TextEditingController();
bool userLoaded = false;
String user = "";
TextEditingController dateController = TextEditingController();
bool dateLoaded = false;
String date = "";

class _RentBookState extends State<RentBook> {
  @override
  void initState() {
    super.initState();
    // Asigna el valor de la primera carga
    bookController = TextEditingController();
    bookLoaded = false;
    book = "";
    bookAviable = false;
    userController = TextEditingController();
    userLoaded = false;
    user = "";
    dateController = TextEditingController();
    dateLoaded = false;
    date = "";
  }

  void _update() {
    bookController = TextEditingController();
    bookLoaded = false;
    book = "";
    bookAviable = false;
    userController = TextEditingController();
    userLoaded = false;
    user = "";
    dateController = TextEditingController();
    dateLoaded = false;
    date = "";
    setState(() {});
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    return Padding(
      padding: bodyPadding,
      child: ListView(
        children: [
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                // ? Libro
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    controller: bookController,
                    name: "book",
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, getLang("bookId")),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: getLang("formError-required")),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  style: getStyle("loginButtonStyle", theme),
                  onPressed: () async {
                    if (bookController.text.isNotEmpty) {
                      bookLoaded = await firestoreManager
                          .checkIndividualBook(bookController.text);
                      if (bookLoaded) {
                        book = bookController.text;
                        bookAviable =
                            await firestoreManager.checkBookAviability(book);
                      } else {
                        showSnackBar(
                            context, getLang("rentBookLoadUser-error"));
                      }
                      setState(() {});
                    }
                  },
                  child: Text(
                    getLang("rentBookLoadBook"),
                  ),
                ),
                const SizedBox(height: 15),
                bookLoaded
                    ? RentBookBookData(
                        theme: theme,
                        bookkey: book,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 15),
                // ? Usuario
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    controller: userController,
                    name: "user",
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, getLang("userId")),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: getLang("formError-required")),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  style: getStyle("loginButtonStyle", theme),
                  onPressed: () async {
                    if (userController.text.isNotEmpty) {
                      userLoaded =
                          await firestoreManager.checkUser(userController.text);
                      if (userLoaded) {
                        user = userController.text;
                      } else {
                        showSnackBar(
                            context, getLang("rentBookLoadUser-error"));
                      }
                      setState(() {});
                    }
                  },
                  child: Text(
                    getLang("rentBookLoadUser"),
                  ),
                ),
                const SizedBox(height: 15),
                userLoaded
                    ? RentBookUserData(theme: theme, email: user)
                    : const SizedBox.shrink(),
                const SizedBox(height: 15),
                // ? Fecha de devolucion
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    controller: dateController,
                    readOnly: true,
                    name: "date",
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, getLang("returnDate")),
                    onTap: () async {
                      DateTime? datePicked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                                data: getStyle("datePickerStyle", theme),
                                child: child!);
                          });
                      if (datePicked != null) {
                        dateLoaded = true;
                        dateController.text =
                            DateFormat("dd/MM/yyyy").format(datePicked);
                        date = DateFormat("dd/MM/yyyy").format(datePicked);
                      }
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: getLang("formError-required")),
                    ]),
                  ),
                ),
                const SizedBox(height: 15),
                BetterDivider(theme: theme),
                const SizedBox(height: 15),
                OutlinedButton(
                  style: getStyle("loginButtonStyle", theme),
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      await firestoreManager.newUserRent(user, book, date);
                      setState(() {
                        _update();
                      });
                    }
                  },
                  child: Text(getLang("rentBookAction")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}