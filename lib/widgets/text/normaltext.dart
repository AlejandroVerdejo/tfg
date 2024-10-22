import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';

class NormalText extends StatefulWidget {
  const NormalText({
    super.key,
    required this.text,
    this.alignment,
    this.style,
  });

  final String text;
  final TextAlign? alignment;
  final TextStyle? style;

  @override
  State<NormalText> createState() => _NormalTextState();
}

class _NormalTextState extends State<NormalText> {
  // Metodo para obtener la preferencia del tema
  Future<String> _loadTheme() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene y devuelve el valor de la preferencia "theme"
    return prefs.getString("theme")!; // Valor predeterminado
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
              padding: const EdgeInsets.only(top: 1.5, bottom: 1.5),
              child: Text(
                widget.text,
                style:
                    widget.style ?? getStyle("normalTextStyle", snapshot.data!),
                softWrap: true,
                maxLines: null,
                textAlign: widget.alignment ?? TextAlign.start,
              ),
            );
          }
        });
  }
}
