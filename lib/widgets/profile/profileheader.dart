import 'package:flutter/material.dart';
import 'package:tfg_library/conf.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/headertext.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            color: colors[settings["theme"]]["headerBackgroundColor"]),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                          radius: 70,
                          child: Text(
                            user["username"][0].toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 70),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                HeaderText(text: user["username"])
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
