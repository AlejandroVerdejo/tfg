import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';
import 'package:tfg_library/widgets/text/normal_richtext.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tfg_library/widgets/text/title_text.dart';

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
  bool updated = false;

  FirestoreManager firestoreManager = FirestoreManager();

  ModalRoute? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(() async {
      if (updated) {
        widget.onUpdate();
      }
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
    contentController.text = widget.contact["content"].replaceAll("<n>", "\n");
    commentController = TextEditingController();
    contactKey = widget.contactKey;
    contact = widget.contact;
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
          ),
        ),
        foregroundColor: colors[theme]["barTextColor"],
        backgroundColor: colors[theme]["headerBackgroundColor"],
      ),
      backgroundColor: colors[theme]["mainBackgroundColor"],
      body: ListView(
        children: [
          Container(
            padding: bodyPadding,
            child: Column(
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
                        "defaultTextFieldStyle", theme, getLang("type"), ""),
                  ),
                ),
                const SizedBox(height: 30),
                // ? Contenido
                TextSelectionTheme(
                  data: getStyle("loginFieldSelectionTheme", theme),
                  child: FormBuilderTextField(
                    controller: contentController,
                    maxLines: null,
                    readOnly: true,
                    name: "content",
                    style: getStyle("normalTextStyle", theme),
                    decoration: getTextFieldStyle(
                        "defaultTextFieldStyle", theme, getLang("content"), ""),
                  ),
                ),
                const SizedBox(height: 30),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: colors[theme]["mainTextColor"],
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: bodyPadding,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // ? Comentarios
                            StaggeredGrid.count(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10,
                              children:
                                  contact["comments"].map<Widget>((entry) {
                                int pos = count;
                                count++;
                                return Card(
                                  color: colors[theme]
                                      ["secondaryBackgroundColor"],
                                  child: Container(
                                    padding: cardPadding,
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    TitleText(
                                                        theme: theme,
                                                        text:
                                                            "${entry["date"]}  -  ${entry["user"]}"),
                                                    NormalRichText(
                                                        theme: theme,
                                                        text: entry["comment"]
                                                            .replaceAll(
                                                                "<n>", "\n"))
                                                  ],
                                                ),
                                              )
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
                                                  title: getLang(
                                                      "deleteCommentDialog-title"),
                                                  message: getLang(
                                                      "alertDialog-confirm"),
                                                  onAccept: () {
                                                    firestoreManager.delComment(
                                                        contactKey, pos);
                                                    contact["comments"]
                                                        .removeAt(pos);
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: colors[theme]
                                                ["headerBackgroundColor"],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            // ? Añadir Comentario
                            TextSelectionTheme(
                              data: getStyle("loginFieldSelectionTheme", theme),
                              child: FormBuilderTextField(
                                controller: commentController,
                                maxLines: null,
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
                                      Map<String, dynamic> newComment = {
                                        "user": widget.user["username"],
                                        "email": widget.user["email"],
                                        "date": DateFormat("dd/MM/yyyy").format(
                                          DateTime.now(),
                                        ),
                                        "comment": commentController.text
                                            .replaceAll("\n", "<n>"),
                                      };
                                      await firestoreManager.addComment(
                                          contactKey, newComment);
                                      commentController.text = "";
                                      contact["comments"].add(newComment);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8.0,
                      top: isAndroid ? -9 : -13.0,
                      child: Container(
                        color: colors[theme]["mainBackgroundColor"],
                        padding: const EdgeInsets.only(left: 3, right: 5),
                        child: NormalText(
                          theme: theme,
                          text: getLang("comments"),
                          style: getStyle("labelTextStyle", theme),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                DefaultButton(
                  theme: theme,
                  text: contact["prio"]
                      ? getLang("prio-off")
                      : getLang("prio-on"),
                  onClick: () async {
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
                ),
                const SizedBox(height: 30),
                DefaultButton(
                  theme: theme,
                  text: getLang("solve"),
                  onClick: () async {
                    await firestoreManager.archiveContact(contactKey);
                    // updated = true;
                    widget.onUpdate();
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
