import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/profile/profileheader.dart';
import 'package:tfg_library/widgets/text/bartext.dart';
import 'package:tfg_library/widgets/text/normaltext.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: colors["barTextColor"],
        title: BarText(text: "Perfil"),
        backgroundColor: colors["headerBackgroundColor"],
      ),
      body: ListView(
        children: [
          ProfileHeader(user: user),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                NormalText(text: "Prestamos activos: (nº)"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("libro x "),
                    Text("libro x "),
                    Text("libro x "),
                    Text("libro x "),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
