import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';

class SinopsisBookText extends StatefulWidget {
  const SinopsisBookText({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  State<SinopsisBookText> createState() => _SinopsisBookTextState();
}

class _SinopsisBookTextState extends State<SinopsisBookText> {
  // Metodo para obtener la preferencia del tema
  Future<String> _loadTheme() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene y devuelve el valor de la preferencia "theme"
    return prefs.getString("theme") ?? "light"; // Valor predeterminado
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Carga
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Error
          return Center(
            child: Text(getLang("state")),
          );
        } else {
          // Ejecucion
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: getStyle("normalTitleTextStyle", snapshot.data!),
                ),
                const Opacity(
                  opacity: 0.5,
                  child: BetterDivider(),
                ),
                RichText(
                  text: TextSpan(
                    text: widget.text,
                    style: getStyle("normalTextStyle", snapshot.data!),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
