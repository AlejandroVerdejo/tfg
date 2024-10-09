import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/tempdata.dart';
import 'package:tfg_library/widgets/helptooltip.dart';
import 'package:tfg_library/widgets/profile/profilerentslistelement.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class ProfileRentsList extends StatelessWidget {
  const ProfileRentsList({
    super.key,
    required this.activeRents,
    required this.data,
  });

  final List activeRents;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              activeRents.isNotEmpty && !isAndroid
                  ? HelpTooltip(
                      message: getLang("hScrollTooltip"),
                      theme: data["theme"],
                    )
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
                          return ProfileRentsListElement(
                            book: book,
                            rent: rent,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
