import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/contact/view_contacts_element.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/text/normal_text.dart';

class ViewContacts extends StatefulWidget {
  const ViewContacts({
    super.key,
    required this.theme,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> user;

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

  void _update() {
    setState(() {});
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
          var contacts = data["contacts"];
          contacts = contacts.entries.toList();
          return Container(
            padding: bodyPadding,
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: contacts.map<Widget>((entry) {
                return ViewContactsElement(
                  theme: theme,
                  user: widget.user,
                  contactKey: entry.key,
                  contact: entry.value,
                  onUpdate: _update,
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
