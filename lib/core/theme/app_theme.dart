import 'package:flutter/material.dart';

abstract final class AppColors {
  static const actionBlue = Color(0xFF006DAA);
  static const focusBlue = Color(0xFF0088D1);
  static const atmosphere = Color(0xFF102A43);
  static const canvas = Color(0xFFF4F7FA);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF17212B);
  static const mutedInk = Color(0xFF5D6B78);
  static const hairline = Color(0xFFDDE5EC);
  static const warning = Color(0xFF9A5B00);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.actionBlue,
      brightness: Brightness.light,
      surface: AppColors.card,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: AppColors.actionBlue,
        onPrimary: Colors.white,
        surface: AppColors.card,
        onSurface: AppColors.ink,
        outline: AppColors.hairline,
      ),
      scaffoldBackgroundColor: AppColors.canvas,
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.5,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: AppColors.ink,
          height: 1.45,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.mutedInk,
          height: 1.45,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: AppColors.hairline),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(999)),
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(999)),
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(999)),
          borderSide: BorderSide(color: AppColors.focusBlue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: Color(0xFFDDEFFC),
        height: 72,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: Color(0xFFDDEFFC),
        minWidth: 80,
        minExtendedWidth: 200,
      ),
    );
  }
}
