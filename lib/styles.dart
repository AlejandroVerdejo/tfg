import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  },
};

Map<String, dynamic> styles = {
  "light": {
    "normalTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: colors["light"]["mainTextColor"],
    ),
    "headerTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 50,
      color: colors["light"]["headerTextColor"],
    ),
    "barTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: colors["light"]["barTextColor"],
    ),
    "descriptionRichTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: colors["light"]["mainTextColor"],
    ),
    "loginTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 50,
      color: colors["light"]["mainTextColor"],
    ),
    "sideMenuTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: colors["light"]["mainTextColor"],
    ),
  },
  "dark": {
    "normalTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: colors["dark"]["mainTextColor"],
    ),
    "headerTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 50,
      color: colors["dark"]["headerTextColor"],
    ),
    "barTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: colors["dark"]["barTextColor"],
    ),
    "descriptionRichTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: colors["dark"]["mainTextColor"],
    ),
    "loginTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      fontSize: 50,
      color: colors["dark"]["mainTextColor"],
    ),
    "sideMenuTextStyle": GoogleFonts.nunito(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: colors["dark"]["mainTextColor"],
    ),
  },
};
