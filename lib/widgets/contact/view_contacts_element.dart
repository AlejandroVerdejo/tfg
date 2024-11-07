import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/contact/contact_view.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class ViewContactsElement extends StatefulWidget {
  const ViewContactsElement({
    super.key,
    required this.theme,
    required this.contactKey,
    required this.contact,
  });

  final String theme;
  final String contactKey;
  final Map<String, dynamic> contact;

  @override
  State<ViewContactsElement> createState() => _ViewContactsElementState();
}

class _ViewContactsElementState extends State<ViewContactsElement> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var contactKey = widget.contactKey;
    var contact = widget.contact;
    return GestureDetector(
      child: Card(
        color: widget.contact["prio"]
            ? colors[theme]["priorityColor"]
            : colors[theme]["chipBackgroundColor"],
        elevation: 2,
        // margin: EdgeInsets.all(80),
        child: Padding(
          padding: cardPadding,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: NormalText(
                  theme: theme,
                  text: widget.contact["type"],
                  alignment: TextAlign.center,
                  style: getStyle("cardTextStyle", theme),
                ),
              ),
              Expanded(
                child: NormalText(
                  theme: theme,
                  text: widget.contact["user"],
                  alignment: TextAlign.center,
                  style: getStyle("cardTextStyle", theme),
                ),
              ),
              Expanded(
                child: NormalText(
                  theme: theme,
                  text: widget.contact["date"],
                  alignment: TextAlign.center,
                  style: getStyle("cardTextStyle", theme),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        log("contact-tap");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactView(
              theme: theme,
              contactKey: contactKey,
              contact: contact,
            ),
          ),
        );
      },
    );
  }
}
