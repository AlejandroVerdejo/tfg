import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/contact/view_contacts_element.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class ViewContacts extends StatefulWidget {
  const ViewContacts({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<ViewContacts> createState() => ViewContactsState();
}

class ViewContactsState extends State<ViewContacts> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> contacts = await firestoreManager.getContacts();
    return {"contacts": contacts};
  }

  FirestoreManager firestoreManager = FirestoreManager();
  String theme = "";

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
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
          var contacts = data["contacts"];

          return GridView.builder(
            padding: bodyPadding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 25,
              mainAxisSpacing: 10,
            ),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              String key = contacts.keys.elementAt(index);
              Map<String, dynamic> item = contacts[key]!;

              return ViewContactsElement(
                theme: theme,
                contactKey: key,
                contact: item,
              );
            },
          );
        }
      },
    );
  }
}
