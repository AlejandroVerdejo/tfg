import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';

class RentText extends StatefulWidget {
  const RentText({
    super.key,
    required this.text,
    this.alignment,
  });

  final String text;
  final TextAlign? alignment;

  @override
  State<RentText> createState() => _RentTextState();
}

class _RentTextState extends State<RentText> {
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
                style: getStyle("rentTextStyle", snapshot.data!),
                softWrap: true,
                maxLines: null,
                textAlign: widget.alignment ?? TextAlign.start,
              ),
            );
          }
        });
  }
}
