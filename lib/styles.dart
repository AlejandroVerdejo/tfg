import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool isAndroid = !kIsWeb && Platform.isAndroid ? true : false;

EdgeInsets bodyPadding = isAndroid
    ? const EdgeInsets.only(top: 15, left: 20, bottom: 5, right: 20)
    // : const EdgeInsets.only(top: 10, left: 60, bottom: 10, right: 60);
    : const EdgeInsets.only(top: 30, left: 50, bottom: 10, right: 50);
EdgeInsets expansionPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5)
    : const EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20);
EdgeInsets bookBodyPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 20, bottom: 30, right: 20)
    : const EdgeInsets.only(top: 10, left: 60, bottom: 60, right: 60);
EdgeInsets profileHeaderPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 20, bottom: 5, right: 20)
    : const EdgeInsets.only(top: 10, left: 60, bottom: 10, right: 60);
EdgeInsets imageBookListPadding = isAndroid
    ? const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 15)
    : const EdgeInsets.only(top: 30, left: 30, bottom: 30, right: 30);
EdgeInsets dialogPadding =
    const EdgeInsets.only(top: 20, left: 15, bottom: 20, right: 15);
EdgeInsets cardPadding =
    isAndroid ? const EdgeInsets.all(10) : const EdgeInsets.all(20);
EdgeInsets waitlistReminderPadding = isAndroid
    ? const EdgeInsets.only(left: 40, top: 30, right: 40, bottom: 30)
    : const EdgeInsets.only(left: 80, top: 30, right: 80, bottom: 30);
double elementImageSize = isAndroid ? 100 : 200;
double rentsElementWidth = isAndroid ? 125 : 250;
double rentsElementHeight = isAndroid ? 150 : 300;
double bookImageSize = isAndroid ? 200 : 400;
double verticalDividerHeight = isAndroid ? 160 : 320;
double dialogWidth = 600;
double gridAspectRatio = isAndroid ? 5 : 25;

const Map<String, dynamic> colors = {
  "light": {
    "mainBackgroundColor": Color.fromRGBO(230, 217, 224, 1),
    "secondaryBackgroundColor": Color.fromRGBO(193, 191, 193, 1),
    // "headerBackgroundColor": Color.fromRGBO(103,58,183, 1),
    // "headerBackgroundColor": Color.fromRGBO(136, 137, 204, 1),
    "headerBackgroundColor": Color.fromRGBO(187, 101, 136, 1),
    // "headerBorderColor": Color.fromRGBO(61, 62, 95, 1),
    "headerBorderColor": Color.fromRGBO(105, 41, 67, 1),
    // "mainTextColor": Color.fromRGBO(19, 25, 43, 1),
    "mainTextColor": Color.fromRGBO(73, 69, 79, 1),
    // "headerTextColor": Color.fromRGBO(214, 214, 224, 1),
    "headerTextColor": Color.fromRGBO(221, 219, 221, 1),
    // "barTextColor": Color.fromRGBO(214, 214, 224, 1),
    "barTextColor": Color.fromRGBO(242, 242, 243, 1),
    "linkTextColor": Color.fromRGBO(187, 101, 136, 1),
    // "chipBackgroundColor": Color.fromRGBO(231, 231, 238, 1),
    "chipBackgroundColor": Color.fromRGBO(187, 101, 136, 1),
    "dividerColor": Color.fromRGBO(50, 47, 54, 1),
    "hintTextColor": Color.fromRGBO(96, 93, 100, 1),
    "priorityColor": Color.fromRGBO(228, 168, 202, 1),
  },
  "dark": {
    "mainBackgroundColor": Color.fromRGBO(73, 69, 79, 1),
    "secondaryBackgroundColor": Color.fromRGBO(93, 89, 99, 1),
    "mainBackgroundColorTransparent": Color.fromRGBO(221, 219, 221, 0.02),
    // "headerBackgroundColor": Color.fromRGBO(103,58,183, 1),
    // "headerBackgroundColor": Color.fromRGBO(136, 137, 204, 1),
    "headerBackgroundColor": Color.fromRGBO(187, 101, 136, 1),
    // "headerBorderColor": Color.fromRGBO(61, 62, 95, 1),
    "headerBorderColor": Color.fromRGBO(105, 41, 67, 1),
    // "mainTextColor": Color.fromRGBO(19, 25, 43, 1),
    "mainTextColor": Color.fromRGBO(221, 219, 221, 1),
    // "headerTextColor": Color.fromRGBO(214, 214, 224, 1),
    "headerTextColor": Color.fromRGBO(242, 242, 243, 1),
    // "barTextColor": Color.fromRGBO(214, 214, 224, 1),
    "barTextColor": Color.fromRGBO(242, 242, 243, 1),
    "linkTextColor": Color.fromRGBO(187, 101, 136, 1),
    // "chipBackgroundColor": Color.fromRGBO(96, 93, 100, 1),
    "chipBackgroundColor": Color.fromRGBO(187, 101, 136, 1),
    "dividerColor": Color.fromRGBO(245, 245, 247, 1),
    "hintTextColor": Color.fromRGBO(230, 217, 224, 1),
    "priorityColor": Color.fromRGBO(193, 133, 167, 1),
  },
};

getStyle(String style, String theme) {
  Map<String, dynamic> styles = {
    "normalTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 14 : 20,
      color: colors[theme]["mainTextColor"],
    ),
    "labelTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 11 : 16,
      color: colors[theme]["mainTextColor"],
    ),
    "cardTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 10 : 20,
      color: colors[theme]["mainTextColor"],
    ),
    "titleTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.bold,
      fontSize: isAndroid ? 14 : 20,
      color: colors[theme]["mainTextColor"],
    ),
    "selectedTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 14 : 20,
      color: colors[theme]["linkTextColor"],
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
      side: const BorderSide(color: Colors.transparent),
      backgroundColor: colors[theme]["headerBackgroundColor"],
      // fixedSize: const Size(double.maxFinite, 50),
      // maximumSize: Size(600, 60),
      // minimumSize: Size(100, 60),
      fixedSize: const Size(600, 60),
      foregroundColor: colors[theme]["headerTextColor"],
      textStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: isAndroid ? 16 : 20,
      ),
    ),
    "filtersButtonStyle": OutlinedButton.styleFrom(
      fixedSize: isAndroid ? const Size(200, 30) : const Size(300, 50),
      // foregroundColor: colors[theme]["mainTextColor"],
      foregroundColor: colors[theme]["headerTextColor"],
      // backgroundColor: colors[theme]["chipBackgroundColor"],
      side: const BorderSide(color: Colors.transparent),
      backgroundColor: colors[theme]["headerBackgroundColor"],
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
      // color: colors[theme]["mainTextColor"],
      color: colors[theme]["headerTextColor"],
    ),
    "passedRentTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 12 : 16,
      color: colors[theme]["headerBackgroundColor"],
    ),
    "rentTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: isAndroid ? 12 : 16,
      color: colors[theme]["mainTextColor"],
    ),
    "datePickerStyle": ThemeData(
        primaryColor: colors[theme]["mainBackgroundColor"],
        colorScheme: ColorScheme(
            primary: colors[theme]["linkTextColor"],
            onPrimary: colors[theme]["mainTextColor"],
            secondary: colors[theme]["mainTextColor"],
            onSecondary: colors[theme]["mainTextColor"],
            surface: colors[theme]["mainBackgroundColor"],
            onSurface: colors[theme]["mainTextColor"],
            error: colors[theme]["headerBackgroundColor"],
            onError: Colors.white,
            brightness: Brightness.light),
        dialogBackgroundColor: colors[theme]["headerBackgroundColor"]),
  };

  return styles[style];
}

getTextFieldStyle(
    String style, String theme, String labelText, String hintText) {
  Map<String, dynamic> styles = {
    "defaultTextFieldStyle": InputDecoration(
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
          borderSide: getStyle("loginFieldBorderSide", theme)),
      focusedBorder: OutlineInputBorder(
          borderSide: getStyle("loginFieldBorderSide", theme)),
      errorStyle:
          TextStyle(color: colors[theme]["headerBackgroundColor"]),
      errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: colors[theme]["headerBackgroundColor"])),
      border: const OutlineInputBorder(),
      labelText: labelText,
      labelStyle: getStyle("normalTextStyle", theme),
      floatingLabelStyle: getStyle("normalTextStyle", theme),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    "filterTextFieldStyle": InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.nunito(color: colors[theme]["hintTextColor"]),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colors[theme]["mainTextColor"],
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colors[theme]["mainTextColor"],
        ),
      ),
      hoverColor: colors[theme]["mainTextColor"],
    ),
  };

  return styles[style];
}

getTextFieldWButtonStyle(String style, String theme, String labelText,
    String hintText, IconData icon, Function()? function) {
  Map<String, dynamic> styles = {
    "defaultTextFieldStyle": InputDecoration(
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
          borderSide: getStyle("loginFieldBorderSide", theme)),
      focusedBorder: OutlineInputBorder(
          borderSide: getStyle("loginFieldBorderSide", theme)),
      errorStyle:
          TextStyle(color: colors[theme]["headerBackgroundColor"]),
      errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: colors[theme]["headerBackgroundColor"])),
      border: const OutlineInputBorder(),
      labelText: labelText,
      labelStyle: getStyle("normalTextStyle", theme),
      floatingLabelStyle: getStyle("normalTextStyle", theme),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: IconButton(
        onPressed: function,
        icon: Icon(
          icon,
          color: colors[theme]["mainTextColor"],
        ),
      ),
    ),
  };

  return styles[style];
}
