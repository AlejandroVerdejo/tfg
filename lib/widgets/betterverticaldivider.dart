import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/styles.dart';

class BetterVerticalDivider extends StatefulWidget {
  const BetterVerticalDivider({
    super.key,
  });

  @override
  State<BetterVerticalDivider> createState() => _BetterVerticalDividerState();
}

class _BetterVerticalDividerState extends State<BetterVerticalDivider> {
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
            return Opacity(
              opacity: 0.5,
              child: Container(
                width: 2,
                height: verticalDividerHeight,
                color: colors[data["theme"]]["dividerColor"],
              ),
            );
          }
        });
  }
}
