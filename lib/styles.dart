import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Map<String, dynamic> colors = {
  "mainBackgroundColor": Color.fromRGBO(242, 242, 243, 1),
  // "headerBackgroundColor": Color.fromRGBO(103,58,183, 1),
  "headerBackgroundColor": Color.fromRGBO(136, 137, 204, 1),
  // "mainTextColor": Color.fromRGBO(19, 25, 43, 1),
  "mainTextColor": Color.fromRGBO(73, 69, 79, 1),
  // "headerTextColor": Color.fromRGBO(214, 214, 224, 1),
  "headerTextColor": Color.fromRGBO(242, 242, 243, 1),
  // "barTextColor": Color.fromRGBO(214, 214, 224, 1),
  "barTextColor": Color.fromRGBO(242, 242, 243, 1),
};

Map<String, dynamic> styles = {
  "normalTextStyle": GoogleFonts.nunito(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: colors["mainTextColor"],
  ),
  "headerTextStyle": GoogleFonts.nunito(
    fontWeight: FontWeight.w500,
    fontSize: 50,
    color: colors["headerTextColor"],
  ),
  "barTextStyle": GoogleFonts.nunito(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: colors["barTextColor"],
  ),
  "descriptionRichTextStyle": GoogleFonts.nunito(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: colors["mainTextColor"],
  ),
  "loginTextStyle": GoogleFonts.nunito(
    fontWeight: FontWeight.w500,
    fontSize: 50,
    color: colors["mainTextColor"],
  ),
  "sideMenuTextStyle": GoogleFonts.nunito(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: colors["mainTextColor"],
  ),
};
