import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/renttext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentBookUserData extends StatefulWidget {
  const RentBookUserData({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<RentBookUserData> createState() => _RentBookUserDataState();
}

class _RentBookUserDataState extends State<RentBookUserData> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    Map<String, dynamic> user = await firestoreManager.getUser(widget.email);
    int activeRents = await firestoreManager.getUserActiveRents(widget.email);
    return {
      "theme": theme,
      "user": user,
      "activeRents": activeRents,
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
              child: Text(snapshot.error.toString()),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            var user = data["user"];
            var activeRents = data["activeRents"];
            return Container(
              width: rentsElementWidth,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  RentText(
                    text: user["username"],
                    alignment: TextAlign.center,
                  ),
                  RentText(
                    text: "${getLang("userActiveRents")}: ${activeRents.toString()}",
                    alignment: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        });
  }
}
