import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/contact/contact_view.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class ViewContactsElement extends StatefulWidget {
  const ViewContactsElement({
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
            // ? colors[theme]["priorityColor"]
            ? colors[theme]["headerBackgroundColor"]
            : colors[theme]["secondaryBackgroundColor"],
        elevation: 2,
        child: Padding(
          padding: cardPadding,
          child: isAndroid
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NormalText(
                      theme: theme,
                      text: widget.contact["type"],
                      alignment: TextAlign.center,
                    ),
                    NormalText(
                      theme: theme,
                      text: widget.contact["user"],
                      alignment: TextAlign.center,
                    ),
                    NormalText(
                      theme: theme,
                      text: widget.contact["date"],
                      alignment: TextAlign.center,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: NormalText(
                        theme: theme,
                        text: widget.contact["type"],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: NormalText(
                        theme: theme,
                        text: widget.contact["user"],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: NormalText(
                        theme: theme,
                        text: widget.contact["date"],
                        alignment: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactView(
              theme: theme,
              user: widget.user,
              contactKey: contactKey,
              contact: contact,
              onUpdate: widget.onUpdate,
            ),
          ),
        );
      },
    );
  }
}
