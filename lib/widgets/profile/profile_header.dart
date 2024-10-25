import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/description_richtext.dart';
import 'package:tfg_library/widgets/text/header_text.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.theme,
    required this.user,
  });

  final String theme;
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(color: colors["light"]["headerBackgroundColor"]),
      child: Padding(
        padding: profileHeaderPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                  radius: 70,
                  child: Text(
                    user["username"][0].toUpperCase(),
                    style: const TextStyle(fontSize: 70),
                  )),
            ),
            HeaderText(text: user["username"]),
            DescriptionRichText(
              theme: theme,
              text: user["email"],
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
