import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static Color _iconColor = Colors.grey;

  static const Color _lightPrimaryColor = Colors.white;
  static const Color _lightPrimaryVariantColor = Color(0XFFF8F8F8);
  static const Color _lightSecondaryColor = Colors.blue;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Color(0XFF121212);

//  static const Color _darkPrimaryVariantColor = Color(0XFFF8F8F8);
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
          color: Colors.transparent,
          iconTheme: IconThemeData(color: _lightOnPrimaryColor),
          elevation: 0.0,
          textTheme: ThemeData.light().textTheme,
          actionsIconTheme: IconThemeData(color: _lightOnPrimaryColor)
      ),
      colorScheme: ColorScheme.light(
        primary: _lightPrimaryColor,
        primaryVariant: _lightPrimaryVariantColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor,
      ),
      iconTheme: IconThemeData(color: _iconColor),
      textTheme: TextTheme(
        headline1: GoogleFonts.comfortaa(
            fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headline2: GoogleFonts.comfortaa(
            fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        headline3:
            GoogleFonts.comfortaa(fontSize: 46, fontWeight: FontWeight.w400),
        headline4: GoogleFonts.comfortaa(
            fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headline5:
            GoogleFonts.comfortaa(fontSize: 23, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.comfortaa(
            fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.comfortaa(
            fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.comfortaa(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.poppins(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: _lightSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textTheme: ButtonTextTheme.primary)
  );

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0.0,
        textTheme: ThemeData.dark().textTheme,
        iconTheme: IconThemeData(color: _darkOnPrimaryColor),
        actionsIconTheme: IconThemeData(color: _darkOnPrimaryColor)
      ),
      colorScheme: ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        onPrimary: _darkOnPrimaryColor,
      ),
      iconTheme: IconThemeData(color: _iconColor),
      textTheme: TextTheme(
        headline1: GoogleFonts.comfortaa(
            fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headline2: GoogleFonts.comfortaa(
            fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        headline3:
            GoogleFonts.comfortaa(fontSize: 46, fontWeight: FontWeight.w400),
        headline4: GoogleFonts.comfortaa(
            fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headline5: GoogleFonts.comfortaa(fontSize: 23, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.comfortaa(
            fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.comfortaa(
            fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.comfortaa(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.poppins(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: _darkSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textTheme: ButtonTextTheme.primary));
}
