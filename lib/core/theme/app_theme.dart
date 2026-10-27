import 'package:flutter/material.dart';

/// Design tokens from the Med Reminder Figma accessibility system.
class AppTheme {
  static const Color background = Color(0xFFF3F8F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF10201F);
  static const Color secondary = Color(0xFF3E5254);
  static const Color border = Color(0xFF9FB3B4);
  static const Color primary = Color(0xFF0A6B66);
  static const Color primaryDark = Color(0xFF07514D);
  static const Color primaryContainer = Color(0xFFDDF3F1);
  static const Color surfaceVariant = primaryContainer;
  static const Color warnBackground = Color(0xFFFFF1D6);
  static const Color warnInk = Color(0xFF7A4300);
  static const Color okBackground = Color(0xFFDDF5E6);
  static const Color statusTaken = Color(0xFF0E6035);
  static const Color dangerBackground = Color(0xFFFDE7E5);
  static const Color statusMissed = Color(0xFFA8201A);
  static const Color statusSkipped = Color(0xFF3E5254);
  static const Color statusLowStock = warnInk;
  static const Color dark = Color(0xFF0E2A2B);
  static const Color darkSurface = Color(0xFF17403F);
  static const Color accent = Color(0xFF7FF0E3);

  static const String fontHeading = 'Kanit';
  static const String fontBody = 'Sarabun';

  static const double cardRadius = 22;
  static const double pillRadius = 999;
  static const double minTouchTarget = 64;

  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: ink.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static final ThemeData lightTheme = _buildTheme();

  static ThemeData _buildTheme() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: white,
          primaryContainer: primaryContainer,
          onPrimaryContainer: primaryDark,
          secondary: secondary,
          onSecondary: white,
          surface: surface,
          onSurface: ink,
          surfaceContainerHighest: background,
          outline: border,
          error: statusMissed,
          onError: white,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: fontBody,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontHeading,
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        iconTheme: IconThemeData(color: primaryDark, size: 24),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontHeading,
          fontSize: 88,
          height: 96 / 88,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontHeading,
          fontSize: 30,
          height: 40 / 30,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontHeading,
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontFamily: fontHeading,
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontBody,
          fontSize: 18,
          height: 28 / 18,
          color: ink,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontBody,
          fontSize: 18,
          height: 28 / 18,
          color: secondary,
        ),
        labelLarge: TextStyle(
          fontFamily: fontBody,
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        labelMedium: TextStyle(
          fontFamily: fontBody,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: border, width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontFamily: fontHeading,
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: const TextStyle(
          fontFamily: fontBody,
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        hintStyle: const TextStyle(
          fontFamily: fontBody,
          fontSize: 18,
          height: 28 / 18,
          color: secondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: statusMissed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: statusMissed, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 92,
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: fontBody,
            fontSize: 16,
            height: 22 / 16,
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? primaryDark
                : secondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? primaryDark
                : secondary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
