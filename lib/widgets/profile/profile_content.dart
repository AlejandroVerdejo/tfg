import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/profile/profile_rents_list.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({
    super.key,
    required this.theme,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> user;

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
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
            return const Center(
              child: Text("Error"),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var theme = widget.theme;
            var rents = data["rents"];
            List activeRents = [];
            if (rents.length > 0) {
              activeRents = (rents as List<dynamic>)
                  .where((rent) => rent["active"] == true)
                  .toList();
            }
            return ProfileRentsList(
              activeRents: activeRents,
              theme: theme,
            );
          }
        });
  }
}
