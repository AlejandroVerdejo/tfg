import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/catalog/booklist.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({
    super.key,
    required this.wishlist,
  });

  final List<String> wishlist;

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  Future<Map<String, dynamic>> _loadPreferences() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene  el valor de la preferencia
    String theme = prefs.getString("theme") ?? "light"; // Valor predeterminado
    // Devuelve un mapa con las preferencias
    return {"theme": theme};
  }

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
            return Center(
              child: Text(getLang("error")),
            );
          } else {
            // Ejecucion
            final data = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.5),
                    child: Container(
                      color: colors[data["theme"]]["headerBorderColor"],
                      height: 1.5,
                    )),
                foregroundColor: colors[data["theme"]]["barTextColor"],
                title: BarText(
                  text: getLang("wishlist"),
                ),
                backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
              ),
              backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
              body: Padding(
                padding: bodyPadding,
                child: BookList(
                  wishList: widget.wishlist,
                ),
              ),
            );
          }
        });
  }
}
