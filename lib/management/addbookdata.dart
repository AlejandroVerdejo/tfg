import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/renttext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentBookBookData extends StatefulWidget {
  const RentBookBookData({
    super.key,
    this.bookkey,
  });

  final String? bookkey;

  @override
  State<RentBookBookData> createState() => _RentBookBookDataState();
}

TextEditingController titleController = TextEditingController();

class _RentBookBookDataState extends State<RentBookBookData> {
  Future<Map<String, dynamic>> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme")!;
    // Map<String, dynamic> book =
    //     await firestoreManager.getUnMergedBook(widget.bookkey);
    return {
      "theme": theme,
      // "book": book,
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
            var theme = data["theme"];
            // var book = data["book"];
            return Container(
              width: rentsElementWidth,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 350,
                    child: TextSelectionTheme(
                      data: getStyle("loginFieldSelectionTheme", theme),
                      child: TextField(
                        style: getStyle("normalTextStyle", theme),
                        controller: titleController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    getStyle("loginFieldBorderSide", theme)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    getStyle("loginFieldBorderSide", theme)),
                            border: const OutlineInputBorder(),
                            labelText: getLang("title"),
                            labelStyle: getStyle("normalTextStyle", theme),
                            floatingLabelStyle:
                                getStyle("normalTextStyle", theme),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
