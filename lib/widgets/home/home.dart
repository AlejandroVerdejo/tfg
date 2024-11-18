import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/error_widget.dart';
import 'package:tfg_library/widgets/home/popular_list.dart';
import 'package:tfg_library/widgets/home/wait_list_reminder.dart';
import 'package:tfg_library/widgets/home_button.dart';
import 'package:tfg_library/widgets/loading_widget.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.theme,
    required this.user,
    required this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> user;
  final Function(String) onScreenChange;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<Map<String, dynamic>> _loadData() async {
    if (widget.user["level"] == 2) {
      List<String> popularBooks = await firestoreManager.getPopularity();
      bool waitListAviability = await firestoreManager
          .checkUserWaitListAviability(widget.user["email"]);
      return {
        "popularBooks": popularBooks,
        "waitListAviability": waitListAviability,
      };
    } else {
      return {};
    }
  }

  void refreshTheme() {
    theme = theme == "dark" ? "light" : "dark";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    theme = widget.theme;
    _futureData = _loadData();
  }

  FirestoreManager firestoreManager = FirestoreManager();
  String theme = "";
  Future<Map>? _futureData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Carga
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          // Error
          return const LoadingErrorWidget();
        } else {
          // Ejecucion
          var level = widget.user["level"];
          final data = snapshot.data!;
          var popularBooks = [""];
          var waitListAviability = false;
          if (level == 2) {
            popularBooks = data["popularBooks"];
            waitListAviability = data["waitListAviability"];
          }
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: bodyPadding,
                child: level == 2
                    ? Column(
                        children: [
                          waitListAviability
                              // ? Recordatorio de libro disponible
                              ? WaitListReminder(theme: theme, widget: widget)
                              : const SizedBox.shrink(),
                          // ? Libros mas populares
                          PopularList(theme: theme, popularBooks: popularBooks),
                          const SizedBox(height: 30),
                          Center(
                            child: Wrap(
                              spacing: 50,
                              runSpacing: 30,
                              alignment: WrapAlignment.start,
                              children: [
                                // ? Ir al catalogo
                                HomeButton(
                                  theme: theme,
                                  text: getLang("catalogHomeShortcut"),
                                  icon: Icons.book,
                                  onClick: () {
                                    widget.onScreenChange("catalog");
                                  },
                                ),
                                // ? Ir a la lista de deseados
                                HomeButton(
                                  theme: theme,
                                  text: getLang("wishlistHomeShortcut"),
                                  icon: Icons.bookmarks,
                                  onClick: () {
                                    widget.onScreenChange("wishlist");
                                  },
                                ),
                                // ? Ir a la lista de recordatorios
                                HomeButton(
                                  theme: theme,
                                  text: getLang("waitlistHomeShortcut"),
                                  icon: Icons.timer,
                                  onClick: () {
                                    widget.onScreenChange("waitlist");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Wrap(
                          spacing: 50,
                          runSpacing: 30,
                          alignment: WrapAlignment.start,
                          children: [
                            // ? Añadir libro
                            HomeButton(
                              theme: theme,
                              text: getLang("addBook"),
                              icon: Icons.book,
                              onClick: () {
                                widget.onScreenChange("addBook");
                              },
                            ),
                            // ? Nuevo prestamo
                            HomeButton(
                              theme: theme,
                              text: getLang("rentBook"),
                              icon: Icons.menu_book,
                              onClick: () {
                                widget.onScreenChange("rentBook");
                              },
                            ),
                            // ? Devolver libro
                            HomeButton(
                              theme: theme,
                              text: getLang("returnBook"),
                              icon: Icons.library_books,
                              onClick: () {
                                widget.onScreenChange("returnBook");
                              },
                            ),
                            // ? Etiquetas
                            HomeButton(
                              theme: theme,
                              text: "Gestionar etiquetas",
                              icon: Icons.label,
                              onClick: () {
                                widget.onScreenChange("tags");
                              },
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}
