import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';
import 'package:tfg_library/styles.dart';
import 'package:tfg_library/widgets/betterdivider.dart';
import 'package:tfg_library/widgets/text/bartext.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.theme,
    required this.user,
    required this.onRefresh,
    required this.onLogOut,
    required this.onScreenChange,
  });

  final String theme;
  final Map<String, dynamic> user;
  final VoidCallback onRefresh;
  final VoidCallback onLogOut;
  final Function(String) onScreenChange;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    var theme = widget.theme;
    var user = widget.user;
    return Drawer(
      backgroundColor: colors[theme]["mainBackgroundColor"],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colors[theme]["headerBackgroundColor"],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    user["username"][0].toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 10),
                BarText(text: user["username"]),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              getLang("profile"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () {
              widget.onScreenChange("profile");
              Navigator.of(context).pop();
            },
          ),
          user["level"] == 0
              ? ListTile(
                  leading: Icon(
                    Icons.people,
                    color: colors[theme]["mainTextColor"],
                  ),
                  title: Text(
                    getLang("users"),
                    style: getStyle("sideMenuTextStyle", theme),
                  ),
                  onTap: () {
                    widget.onScreenChange("users");
                    Navigator.of(context).pop();
                  },
                )
              : const SizedBox.shrink(),
          ListTile(
            leading: Icon(
              Icons.book,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              getLang("catalog"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () {
              widget.onScreenChange("catalog");
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bookmarks,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              getLang("wishlist"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () {
              widget.onScreenChange("wishlist");
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.timer,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              getLang("waitlist"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () {
              widget.onScreenChange("waitlist");
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              getLang("settings"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () {
              widget.onScreenChange("settings");
            },
          ),
          BetterDivider(theme: theme),
          ListTile(
            leading: Icon(
              theme == "light" ? Icons.sunny : Icons.nightlight,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              theme == "light" ? getLang("lightTheme") : getLang("darkTheme"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () async {
              widget.onRefresh();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: colors[theme]["mainTextColor"],
            ),
            title: Text(
              getLang("logout"),
              style: getStyle("sideMenuTextStyle", theme),
            ),
            onTap: () {
              widget.onLogOut();
            },
          ),
        ],
      ),
    );
  }
}
