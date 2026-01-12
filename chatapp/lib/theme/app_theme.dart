import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF4A72FF);
  static const Color botPurple = Color(0xFF7C4DFF);
  static const Color deepPurple = Color(0xFF311B92);
  static const Color bubbleGrey = Color(0xFFE0E0E0);
  static const Color onlineGreen = Color(0xFF00E676);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
      useMaterial3: true,
    );
  }
}
