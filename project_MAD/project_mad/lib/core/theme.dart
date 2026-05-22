import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppConstants.primaryPurple,
      scaffoldBackgroundColor: AppConstants.white,
      fontFamily: 'Inter', // Assuming Inter is available or using default
      colorScheme: ColorScheme.light(
        primary: AppConstants.primaryPurple,
        secondary: AppConstants.accentPurple,
        surface: AppConstants.white,
        background: AppConstants.white,
        error: Colors.redAccent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppConstants.black),
        titleTextStyle: TextStyle(
          color: AppConstants.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryPurple,
          foregroundColor: AppConstants.white,
          minimumSize: Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppConstants.primaryPurple, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppConstants.white,
      ),
    );
  }
}
