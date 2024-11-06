import 'package:flutter/material.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/widgets/profile/profile_content.dart';
import 'package:tfg_library/widgets/profile/profile_header.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.theme,
    required this.user,
    required this.onUpdate,
  });

  final String theme;
  final Map<String, dynamic> user;
  final VoidCallback onUpdate;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirestoreManager firestoreManager = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var user = widget.user;
    return ListView(
      shrinkWrap: true,
      children: [
        ProfileHeader(
          theme: theme,
          user: user,
          onUpdate: widget.onUpdate,
        ),
        ProfileContent(theme: theme, user: user)
      ],
    );
  }
}
