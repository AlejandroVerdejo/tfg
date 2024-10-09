import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool isAndroid = !kIsWeb && Platform.isAndroid ? true : false;

EdgeInsets bodyPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 20, bottom: 5, right: 20)
    : const EdgeInsets.only(top: 10, left: 60, bottom: 10, right: 60);
EdgeInsets bookBodyPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 20, bottom: 30, right: 20)
    : const EdgeInsets.only(top: 10, left: 60, bottom: 60, right: 60);
EdgeInsets profileHeaderPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 20, bottom: 5, right: 20)
    : const EdgeInsets.only(top: 10, left: 60, bottom: 10, right: 60);
EdgeInsets imageBookListPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 15)
    : const EdgeInsets.only(top: 30, left: 30, bottom: 30, right: 30);
double elementImageSize = isAndroid ? 100 : 200;
double rentsElementWidth = isAndroid ? 125 : 250;
double rentsElementHeight = isAndroid ? 150 : 300;
double bookImageSize = isAndroid ? 200 : 400;
double verticalDividerHeight = isAndroid ? 160 : 320;

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

//* isAndroid ? Android : !Android

getStyle(String style, String theme) {
  Map<String, dynamic> styles = {
    "normalTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 14 : 20,
      color: colors[theme]["mainTextColor"],
    ),
    "normalTitleTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w700,
      fontSize: isAndroid ? 14 : 20,
      color: colors[theme]["mainTextColor"],
    ),
    "headerTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 40 : 50,
      color: colors[theme]["headerTextColor"],
    ),
    "barTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 14 : 20,
      color: colors[theme]["barTextColor"],
    ),
    "descriptionRichTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 12 : 16,
      color: colors[theme]["mainTextColor"],
    ),
    "loginTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 40 : 50,
      color: colors[theme]["mainTextColor"],
    ),
    "sideMenuTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w600,
      fontSize: isAndroid ? 12 : 16,
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
        fontSize: isAndroid ? 16 : 20,
      ),
    ),
    "filtersButtonStyle": OutlinedButton.styleFrom(
      fixedSize: isAndroid ? const Size(200, 30) : const Size(300, 50),
      foregroundColor: colors[theme]["mainTextColor"],
      backgroundColor: colors[theme]["chipBackgroundColor"],
      textStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: isAndroid ? 12 : 18,
      ),
    ),
    "loginTextButtonStyle": TextButton.styleFrom(
      foregroundColor: colors[theme]["linkTextColor"],
      textStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: isAndroid ? 14 : 16,
      ),
    ),
    "genreFilterChipStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 10 : 14,
      color: colors[theme]["mainTextColor"],
    ),
    "passedRentTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 12 : 16,
      color: Colors.red,
    ),
    "rentTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 12 : 16,
      color: colors[theme]["mainTextColor"],
    ),
  };

  return styles[style];
}
