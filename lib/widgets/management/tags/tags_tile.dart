import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/default_button.dart';
import 'package:tfg_library/widgets/delete_dialog.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class TagsTile extends StatefulWidget {
  const TagsTile({
    super.key,
    required this.theme,
    required this.expandedState,
    required this.tagsList,
    required this.title,
    required this.onDelete,
    required this.onAdd,
    required this.deleteText,
  });

  final String theme;
  final bool expandedState;
  final List<String> tagsList;
  final String title;
  final void Function(List<String>) onDelete;
  final void Function(List<String>) onAdd;
  final String deleteText;

  @override
  State<TagsTile> createState() => _TagsTileState();
}

class _TagsTileState extends State<TagsTile> {
  @override
  void initState() {
    super.initState();
    tagsList = widget.tagsList;
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<String> tagsList = [];

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var title = widget.title;
    var deleteText = widget.deleteText;
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: colors[theme]["mainTextColor"],
          width: 1.0,
        ),
      ),
      child: ExpansionTile(
        title: NormalText(theme: theme, text: title),
        childrenPadding: expansionPadding,
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
        initiallyExpanded: widget.expandedState,
        children: [
          StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            children: tagsList.map<Widget>((entry) {
              return GestureDetector(
                child: Card(
                  color: colors[theme]["secondaryBackgroundColor"],
                  elevation: 2,
                  child: Padding(
                    padding: cardPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: NormalText(
                            theme: theme,
                            text: entry,
                          ),
                        ),
                        // ? Eliminar
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteDialog(
                                        theme: theme,
                                        title: deleteText,
                                        message: getLang("confirmation"),
                                        onAccept: () {
                                          tagsList.remove(entry);
                                          widget.onDelete(tagsList);
                                          setState(() {});
                                        });
                                  });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: colors[theme]["headerBackgroundColor"],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          DefaultButton(
            theme: widget.theme,
            text: getLang("add"),
            onClick: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController newTagController =
                        TextEditingController();
                    final formKey = GlobalKey<FormBuilderState>();
                    return AlertDialog(
                      backgroundColor: colors[theme]["mainBackgroundColor"],
                      scrollable: true,
                      content: FormBuilder(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextSelectionTheme(
                              data: getStyle("loginFieldSelectionTheme", theme),
                              child: FormBuilderTextField(
                                name: "newTag",
                                controller: newTagController,
                                style: getStyle("normalTextStyle", theme),
                                decoration: getTextFieldStyle(
                                    "defaultTextFieldStyle", theme, "", ""),
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
                            DefaultButton(
                                theme: theme,
                                text: getLang("add"),
                                onClick: () {
                                  if (formKey.currentState?.saveAndValidate() ??
                                      false) {
                                    if (!tagsList
                                        .contains(newTagController.text)) {
                                      tagsList.add(newTagController.text);
                                      widget.onAdd(tagsList);
                                      Navigator.pop(context, false);
                                      setState(() {});
                                    } else {
                                      showSnackBar(context,
                                          getLang("tagRegister-error"));
                                    }
                                  }
                                })
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
