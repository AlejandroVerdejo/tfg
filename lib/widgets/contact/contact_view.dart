import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/bar_text.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class ContactView extends StatefulWidget {
  const ContactView({
    super.key,
    required this.theme,
    required this.contactKey,
    required this.contact,
  });

  final String theme;
  final String contactKey;
  final Map<String, dynamic> contact;

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var contactKey = widget.contactKey;
    var contact = widget.contact;
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
        body: Center());
  }
}
