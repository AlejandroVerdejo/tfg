import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/management/user_list_element.dart';
import 'package:tfg_library/widgets/management/user_list_header.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/better_divider.dart';

class UserList extends StatefulWidget {
  const UserList({
    super.key,
    required this.theme,
  });

  final String theme;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    Map<String, dynamic> workers = await firestoreManager.getWorkers();
    return {
      "workers": workers,
    };
  }

  void refresh() {
    setState(() {});
  }

  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPreferences(),
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
          var theme = widget.theme;
          var workers = data["workers"];
          workers = workers.entries.toList();
          return Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border:
                  Border.all(color: colors[theme]["mainTextColor"], width: 1),
            ),
            child: Column(
              children: [
                UserListHeader(theme: theme),
                BetterDivider(theme: theme),
                Wrap(
                  runSpacing: 10.0,
                  children: workers.map<Widget>((entry) {
                    return UserListElement(
                      theme: theme,
                      user: entry.value,
                      onDelete: refresh,
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
