import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/styles.dart';

class NormalText extends StatefulWidget {
  const NormalText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<NormalText> createState() => _NormalTextState();
}

class _NormalTextState extends State<NormalText> {
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
            return const Center(
              child: Text("Error"),
            );
          } else {
            // Ejecucion
            return Text(
              widget.text,
              style: getStyle("normalTextStyle", snapshot.data!),
              softWrap: true,
              maxLines: null,
            );
          }
        });
  }
}
