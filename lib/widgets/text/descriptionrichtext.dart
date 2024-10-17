import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';

class DescriptionRichText extends StatefulWidget {
  const DescriptionRichText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<DescriptionRichText> createState() => _DescriptionRichTextState();
}

class _DescriptionRichTextState extends State<DescriptionRichText> {
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
              child: Text(getLang("error")),
            );
          } else {
            // Ejecucion
            return RichText(
                maxLines: 3,
                overflow: TextOverflow.fade,
                text: TextSpan(
                    text: widget.text,
                    style:
                        getStyle("descriptionRichTextStyle", snapshot.data!)));
          }
        });
  }
}
