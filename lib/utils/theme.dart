import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentOrange,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      
      // Text theme with consistent sizing and weights
      textTheme: GoogleFonts.notoSansTextTheme().copyWith(
        displayLarge: TextStyle(
          fontSize: AppFontSize.h1,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        displayMedium: TextStyle(
          fontSize: AppFontSize.h2,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        displaySmall: TextStyle(
          fontSize: AppFontSize.h3,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        headlineSmall: TextStyle(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        titleLarge: TextStyle(
          fontSize: AppFontSize.lg,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleMedium: TextStyle(
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w500,
          color: AppColors.grey800,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSize.sm,
          fontWeight: FontWeight.w500,
          color: AppColors.grey700,
        ),
        bodySmall: TextStyle(
          fontSize: AppFontSize.xs,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
      ),
      
      // App Bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: const EdgeInsets.all(0),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: TextStyle(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: TextStyle(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: TextStyle(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.grey300,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.grey300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: AppColors.grey700,
          fontSize: AppFontSize.sm,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColors.grey500,
          fontSize: AppFontSize.sm,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: AppFontSize.xs,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.grey800,
        size: AppIconSize.md,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.circular),
        ),
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.primaryBlue,
        labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        showCheckmark: true,
      ),
    );
  }
}
