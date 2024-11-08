import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';
import 'package:tfg_library/widgets/text/bar_text.dart';
import 'package:tfg_library/widgets/text/normal_richtext.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ContactView extends StatefulWidget {
  const ContactView({
    super.key,
    required this.theme,
    required this.user,
    required this.contactKey,
    required this.contact,
    required this.onUpdate,
  });

  final String theme;
  final Map<String, dynamic> user;
  final String contactKey;
  final Map<String, dynamic> contact;
  final VoidCallback onUpdate;

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  TextEditingController typeController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String contactKey = "";
  Map<String, dynamic> contact = {};
  bool coment = false;
  bool updated = false;

  FirestoreManager firestoreManager = FirestoreManager();

  ModalRoute? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(() async {
      log("cerrar");
      if (updated) {
        log("updated");
        widget.onUpdate();
      }
      Navigator.pop(context, updated);
      return true;
    });
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(() async => true);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    typeController.text = widget.contact["type"];
    contentController.text = widget.contact["content"];
    commentController = TextEditingController();
    contactKey = widget.contactKey;
    contact = widget.contact;
    coment = false;
    updated = false;
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    var theme = widget.theme;
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.5),
              child: Container(
                color: colors[theme]["headerBorderColor"],
                height: 1.5,
              )),
          foregroundColor: colors[theme]["barTextColor"],
          title: BarText(
            // text: "${contact["type"]} - $contactKey",
            text: "",
          ),
          backgroundColor: colors[theme]["headerBackgroundColor"],
        ),
        backgroundColor: colors[theme]["mainBackgroundColor"],
        body: Container(
          padding: bodyPadding,
          child: ListView(
            children: [
              // ? Tipo
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  controller: typeController,
                  readOnly: true,
                  name: "type",
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, "Tipo", ""),
                ),
              ),
              const SizedBox(height: 30),
              // ? Contenido
              TextSelectionTheme(
                data: getStyle("loginFieldSelectionTheme", theme),
                child: FormBuilderTextField(
                  controller: contentController,
                  readOnly: true,
                  name: "content",
                  style: getStyle("normalTextStyle", theme),
                  decoration: getTextFieldStyle(
                      "defaultTextFieldStyle", theme, "Contenido", ""),
                ),
              ),
              const SizedBox(height: 30),
              // ? Comentarios
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                children: contact["comments"].map<Widget>((entry) {
                  int pos = count;
                  count++;
                  return Card(
                    color: colors[theme]["chipBackgroundColor"],
                    child: Container(
                      padding: bodyPadding,
                      width: double.maxFinite,
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                NormalRichText(
                                  theme: theme,
                                  text:
                                      "${entry["date"]}   -   ${entry["user"]}\n${entry["comment"]}",
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteDialog(
                                          theme: theme,
                                          title:
                                              "Se eliminara el siguiente comentario",
                                          message: "¿Estas seguro?",
                                          onAccept: () {
                                            log("borrar - $pos");
                                            firestoreManager.delComment(
                                                contactKey, pos);
                                            contact["comments"].removeAt(pos);
                                            setState(() {});
                                          });
                                    });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: colors[theme]["mainTextColor"],
                              ))
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: getStyle("loginButtonStyle", theme),
                    onPressed: () async {
                      if (contact["prio"]) {
                        await firestoreManager.setContactPriority(
                            contactKey, false);
                        contact["prio"] = false;
                        updated = true;
                        setState(() {});
                      } else {
                        await firestoreManager.setContactPriority(
                            contactKey, true);
                        contact["prio"] = true;
                        updated = true;
                        setState(() {});
                      }
                    },
                    child: Text(
                      contact["prio"] ? "Quitar prioridad" : "Dar prioridad",
                    ),
                  ),
                  OutlinedButton(
                    style: getStyle("loginButtonStyle", theme),
                    onPressed: () async {
                      coment = !coment;
                      setState(() {});
                    },
                    child: Text(
                      "Añadir comentario",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // ? Comentario
              coment
                  ? TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: FormBuilderTextField(
                        controller: commentController,
                        name: "comment",
                        style: getStyle("normalTextStyle", theme),
                        decoration: getTextFieldWButtonStyle(
                          "defaultTextFieldStyle",
                          theme,
                          "",
                          "",
                          Icons.send,
                          () async {
                            if (commentController.text.isNotEmpty) {
                              log("enviado");
                              log("${widget.user["username"]} - ${widget.user["email"]}");
                              Map<String, dynamic> newComment = {
                                "user": widget.user["username"],
                                "email": widget.user["email"],
                                "date": DateFormat("dd/MM/yyyy")
                                    .format(DateTime.now()),
                                "comment": commentController.text,
                              };
                              await firestoreManager.addComment(
                                  contactKey, newComment);
                              commentController.text = "";
                            }
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
              OutlinedButton(
                style: getStyle("loginButtonStyle", theme),
                onPressed: () async {
                  await firestoreManager.archiveContact(contactKey);
                  // updated = true;
                  widget.onUpdate();
                  Navigator.pop(context, false);
                },
                child: Text(
                  getLang("solve"),
                ),
              ),
            ],
          ),
        ));
  }
}
