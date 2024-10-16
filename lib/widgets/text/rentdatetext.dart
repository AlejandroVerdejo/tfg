import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';

class RentDateText extends StatefulWidget {
  const RentDateText({
    super.key,
    required this.text,
    this.alignment,
  });

  final String text;
  final TextAlign? alignment;

  @override
  State<RentDateText> createState() => _RentDateTextState();
}

class _RentDateTextState extends State<RentDateText> {
  // Metodo para obtener la preferencia del tema
  Future<String> _loadTheme() async {
    // Carga las preferencias
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtiene y devuelve el valor de la preferencia "theme"
    return prefs.getString("theme") ?? "dark"; // Valor predeterminado
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
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('dd/MM/yyyy').format(now);
            // String formattedTime = DateFormat('HH:mm').format(now);
            DateFormat format = DateFormat('dd/MM/yyyy');
            DateTime actualDate = format.parse(formattedDate);
            DateTime rentDate = format.parse(widget.text);
            bool passed = rentDate.isBefore(actualDate) ? true : false;
            return Padding(
              padding: const EdgeInsets.only(top: 1.5, bottom: 1.5),
              child: Text(
                "${widget.text}\n(${rentDate.difference(actualDate).inDays} ${getLang("rentDifDays")})",
                style: passed
                    ? getStyle("passedRentTextStyle", snapshot.data!)
                    : getStyle("rentTextStyle", snapshot.data!),
                softWrap: true,
                maxLines: null,
                textAlign: widget.alignment ?? TextAlign.start,
              ),
            );
          }
        });
  }
}
