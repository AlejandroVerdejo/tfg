import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/helptooltip.dart';
import 'package:tfg_library/widgets/profile/profileheader.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';
import 'package:tfg_library/widgets/text/rentdatetext.dart';
import 'package:tfg_library/widgets/text/renttext.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Metodo para obtener la preferencia del tema
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
    var user = widget.user;
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
          return const Center(
            child: Text("Error"),
          );
        } else {
          final data = snapshot.data!;
          var activeRents;
          if (user["rents"].length > 0) {
            // var activeRents = user["rents"].where((rent) => rent["active"]).toList();
            activeRents = (user["rents"] as List<Map<String, dynamic>>)
                .where((rent) => rent["active"] == true)
                .toList();
          }
          // var rentsId = user["rents"] as List<String>;
          return Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.5),
                  child: Container(
                    color: colors[data["theme"]]["headerBorderColor"],
                    height: 1.5,
                  )),
              foregroundColor: colors[data["theme"]]["barTextColor"],
              title: BarText(text: "${getLang("profile")}"),
              backgroundColor: colors[data["theme"]]["headerBackgroundColor"],
            ),
            backgroundColor: colors[data["theme"]]["mainBackgroundColor"],
            body: ListView(
              shrinkWrap: true,
              children: [
                ProfileHeader(user: user),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: NormalText(
                                text:
                                    "${getLang("profile_activeRents")}: ${activeRents.length}"),
                          ),
                          activeRents.length > 0 && !isAndroid
                              ? HelpTooltip(message: "${getLang("hScrollTooltip")}", theme: data["theme"],)
                              : const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      activeRents.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Wrap(
                                    // crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 10,
                                    children: activeRents.map<Widget>((rent) {
                                      var book = books[rent["book"]];
                                      return Container(
                                        width: rentsElementWidth,
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: rentsElementHeight,
                                              child: Image.asset(
                                                "assets/images/books/${book["image_asset"]}",
                                                width: elementImageSize,
                                              ),
                                            ),
                                            const BetterDivider(),
                                            RentText(
                                              text: book["title"],
                                              alignment: TextAlign.center,
                                            ),
                                            RentDateText(
                                              text: rent["date"],
                                              alignment: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
