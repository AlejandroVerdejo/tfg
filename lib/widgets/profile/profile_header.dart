import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfg_library/firebase/firebase_manager.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/text/description_richtext.dart';
import 'package:tfg_library/widgets/text/header_text.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.theme,
    required this.user,
    required this.onUpdate,
  });

  final String theme;
  final Map<String, dynamic> user;
  final VoidCallback onUpdate;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

bool edit = false;
TextEditingController nameController = TextEditingController();
Uint8List? image;
Uint8List? imageAux;
FirestoreManager firestoreManager = FirestoreManager();
StorageManager storageManager = StorageManager();
bool nameUpdated = false;
bool pfpUpdated = false;

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  void initState() {
    super.initState();
    edit = false;
    image = widget.user["pfp"];
    imageAux = widget.user["pfp"];
    nameUpdated = false;
    pfpUpdated = false;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = await pickedFile.readAsBytes();
      // storageManager.setPFP(image!, "default");
      pfpUpdated = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var user = widget.user;
    return DecoratedBox(
      decoration:
          BoxDecoration(color: colors["light"]["headerBackgroundColor"]),
      child: Padding(
        padding: profileHeaderPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                !edit
                    ? IconButton(
                        onPressed: () {
                          edit = true;
                          nameController.text = user["username"];
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.edit,
                          color: colors["light"]["headerTextColor"],
                        ),
                      )
                    : const SizedBox.shrink(),
                edit
                    ? IconButton(
                        onPressed: () async {
                          edit = false;
                          if (pfpUpdated) {
                            imageAux = image;
                            await storageManager.setPFP(image!, user["email"]);
                          }
                          if (nameUpdated) {
                            user["username"] = nameController.text;
                            await firestoreManager.updateUsername(
                                user["email"], user["username"]);
                          }
                          pfpUpdated = false;
                          nameUpdated = false;
                          widget.onUpdate();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.save,
                          color: colors["light"]["headerTextColor"],
                        ),
                      )
                    : const SizedBox.shrink(),
                edit
                    ? IconButton(
                        onPressed: () {
                          edit = false;
                          image = imageAux;
                          nameUpdated = false;
                          pfpUpdated = false;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: colors["light"]["headerTextColor"],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            GestureDetector(
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: MemoryImage(
                    image!,
                  ),
                ),
              ),
              onTap: edit
                  ? () async {
                      _pickImage();
                    }
                  : null,
            ),
            edit
                ? TextSelectionTheme(
                    data: getStyle("loginFieldSelectionTheme", theme),
                    child: TextField(
                      style: getStyle("headerTextStyle", theme),
                      controller: nameController,
                      decoration: getTextFieldStyle(
                          "filterTextFieldStyle", theme, "", ""),
                      onChanged: (value) {
                        // setState(() {});
                        nameUpdated = true;
                      },
                    ),
                  )
                : HeaderText(text: user["username"]),
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
