import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/loading_widget.dart';
import 'package:tfg_library/widgets/management/users/user_list_element.dart';

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
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          // Error
          return const LoadingErrorWidget();
        } else {
          // Ejecucion
          final data = snapshot.data!;
          var theme = widget.theme;
          var workers = data["workers"];
          workers = workers.entries.toList();
          return StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            children: workers.map<Widget>((entry) {
              return UserListElement(
                theme: theme,
                user: entry.value,
                onDelete: refresh,
              );
            }).toList(),
          );
        }
      },
    );
  }
}
