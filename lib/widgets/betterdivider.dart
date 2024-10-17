import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/styles.dart';

class BetterDivider extends StatefulWidget {
  const BetterDivider({
    super.key,
  });

  @override
  State<BetterDivider> createState() => _BetterDividerState();
}

class _BetterDividerState extends State<BetterDivider> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    return {"theme": theme};
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
            return Divider(
              color: colors[data["theme"]]["dividerColor"],
            );
          }
        });
  }
}
