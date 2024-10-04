import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const bodyPadding = EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10);

double elementImageSize = !kIsWeb && Platform.isAndroid ? 100 : 200;
double bookImageSize = !kIsWeb && Platform.isAndroid ? 200 : 400;

const Map<String, dynamic> colors = {
  "light": {
    "mainBackgroundColor": Color.fromRGBO(242, 242, 243, 1),
    // "headerBackgroundColor": Color.fromRGBO(103,58,183, 1),
    // "headerBackgroundColor": Color.fromRGBO(136, 137, 204, 1),
    "headerBackgroundColor": Color.fromRGBO(187, 101, 136, 1),
    // "headerBorderColor": Color.fromRGBO(61, 62, 95, 1),
    "headerBorderColor": Color.fromRGBO(105, 41, 67, 1),
    // "mainTextColor": Color.fromRGBO(19, 25, 43, 1),
    "mainTextColor": Color.fromRGBO(73, 69, 79, 1),
    // "headerTextColor": Color.fromRGBO(214, 214, 224, 1),
    "headerTextColor": Color.fromRGBO(242, 242, 243, 1),
    // "barTextColor": Color.fromRGBO(214, 214, 224, 1),
    "barTextColor": Color.fromRGBO(242, 242, 243, 1),
    "linkTextColor": Color.fromRGBO(136, 137, 204, 1),
    "chipBackgroundColor": Color.fromRGBO(231, 231, 238, 1),
    "dividerColor": Color.fromRGBO(50, 47, 54, 1),
  },
  "dark": {
    "mainBackgroundColor": Color.fromRGBO(73, 69, 79, 1),
    // "headerBackgroundColor": Color.fromRGBO(103,58,183, 1),
    // "headerBackgroundColor": Color.fromRGBO(136, 137, 204, 1),
    "headerBackgroundColor": Color.fromRGBO(187, 101, 136, 1),
    // "headerBorderColor": Color.fromRGBO(61, 62, 95, 1),
    "headerBorderColor": Color.fromRGBO(105, 41, 67, 1),
    // "mainTextColor": Color.fromRGBO(19, 25, 43, 1),
    "mainTextColor": Color.fromRGBO(242, 242, 243, 1),
    // "headerTextColor": Color.fromRGBO(214, 214, 224, 1),
    "headerTextColor": Color.fromRGBO(242, 242, 243, 1),
    // "barTextColor": Color.fromRGBO(214, 214, 224, 1),
    "barTextColor": Color.fromRGBO(242, 242, 243, 1),
    "linkTextColor": Color.fromRGBO(136, 137, 204, 1),
    "chipBackgroundColor": Color.fromRGBO(96, 93, 100, 1),
    "dividerColor": Color.fromRGBO(245, 245, 247, 1),
  },
};

//* !kIsWeb && Platform.isAndroid ? Android : !Android

getStyle(String style, String theme) {
  Map<String, dynamic> styles = {
    "normalTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: !kIsWeb && Platform.isAndroid ? 16 : 20,
      color: colors[theme]["mainTextColor"],
    ),
    "headerTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: !kIsWeb && Platform.isAndroid ? 40 : 50,
      color: colors[theme]["headerTextColor"],
    ),
    "barTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: !kIsWeb && Platform.isAndroid ? 16 : 20,
      color: colors[theme]["barTextColor"],
    ),
    "descriptionRichTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: !kIsWeb && Platform.isAndroid ? 14 : 16,
      color: colors[theme]["mainTextColor"],
    ),
    "loginTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: !kIsWeb && Platform.isAndroid ? 40 : 50,
      color: colors[theme]["mainTextColor"],
    ),
    "sideMenuTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w600,
      fontSize: !kIsWeb && Platform.isAndroid ? 14 : 16,
      color: colors[theme]["mainTextColor"],
    ),
    "loginFieldBorderSide": BorderSide(
      color: colors[theme]["mainTextColor"],
    ),
    "loginFieldSelectionTheme": TextSelectionThemeData(
      selectionColor: colors[theme]["headerBackgroundColor"],
      cursorColor: colors[theme]["headerBackgroundColor"],
      selectionHandleColor: colors[theme]["headerBackgroundColor"],
    ),
    "loginButtonStyle": OutlinedButton.styleFrom(
      side: BorderSide(color: colors[theme]["mainTextColor"]),
      fixedSize: const Size(300, 50),
      foregroundColor: colors[theme]["mainTextColor"],
      textStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: !kIsWeb && Platform.isAndroid ? 16 : 20,
      ),
    ),
    "loginTextButtonStyle": TextButton.styleFrom(
      foregroundColor: colors[theme]["linkTextColor"],
      textStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: !kIsWeb && Platform.isAndroid ? 14 : 16,
      ),
    ),
    "genreFilterChipStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: !kIsWeb && Platform.isAndroid ? 14 : 16,
      color: colors[theme]["mainTextColor"],
    ),
  };

  return styles[style];
}
