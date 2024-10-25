import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/profile/profile_header.dart';
import 'package:tfg_library/widgets/profile/profile_rents_list.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.theme,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> books = await firestoreManager.getMergedBooks();
    List<dynamic> rents =
        await firestoreManager.getUserRents(widget.user["email"]);
    // Devuelve un mapa con los datos
    return {
      "books": books,
      "rents": rents,
    };
  }

  FirestoreManager firestoreManager = FirestoreManager();

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
          return Center(
            // child: Text(getLang("error")),
            child: Text(snapshot.error.toString()),
          );
        } else {
          final data = snapshot.data!;
          var theme = widget.theme;
          var user = widget.user;
          var rents = data["rents"];
          List activeRents = [];
          if (rents.length > 0) {
            activeRents = (rents as List<dynamic>)
                .where((rent) => rent["active"] == true)
                .toList();
          }
          return ListView(
            shrinkWrap: true,
            children: [
              ProfileHeader(
                theme: theme,
                user: user,
              ),
              ProfileRentsList(
                activeRents: activeRents,
                theme: theme,
              )
            ],
          );
        }
      },
    );
  }
}
