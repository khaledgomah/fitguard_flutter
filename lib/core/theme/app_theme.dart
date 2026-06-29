import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _seed = Color(0xFF006C49);

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
          surface: const Color(0xFFF4FBF4),
        ).copyWith(
          primary: const Color(0xFF006C49),
          primaryContainer: const Color(0xFF10B981),
          secondary: const Color(0xFF712AE2),
          secondaryContainer: const Color(0xFF8A4CFC),
          tertiary: const Color(0xFFA43A3A),
          surface: const Color(0xFFF4FBF4),
          surfaceContainer: const Color(0xFFE8F0E9),
          surfaceContainerHighest: const Color(0xFFDDE4DD),
          surfaceContainerHigh: const Color(0xFFE3EAE3),
          surfaceContainerLow: const Color(0xFFEEF6EE),
          surfaceContainerLowest: Colors.white,
          outline: const Color(0xFF6C7A71),
          outlineVariant: const Color(0xFFBBCABF),
          error: const Color(0xFFBA1A1A),
          errorContainer: const Color(0xFFFFDAD6),
        );

    final textTheme = GoogleFonts.interTextTheme(Typography.blackMountainView)
        .copyWith(
          displayLarge: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 48,
            fontWeight: FontWeight.w700,
            height: 56 / 48,
            letterSpacing: -0.96,
          ),
          displayMedium: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 44 / 36,
            letterSpacing: -0.72,
          ),
          headlineSmall: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 28 / 20,
          ),
          titleLarge: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 32 / 24,
          ),
          bodyLarge: const TextStyle(fontSize: 18, height: 28 / 18),
          bodyMedium: const TextStyle(fontSize: 16, height: 24 / 16),
          labelLarge: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            height: 16 / 12,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        disabledColor: scheme.surfaceContainer,
        selectedColor: scheme.primaryContainer,
        secondarySelectedColor: scheme.primaryContainer,
        labelStyle: textTheme.labelLarge?.copyWith(color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      extensions: const [
        AppThemeTokens(
          containerMaxWidth: 1440,
          sidebarWidth: 260,
          headerHeight: 64,
          gutter: 24,
        ),
      ],
    );
  }
}

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.containerMaxWidth,
    required this.sidebarWidth,
    required this.headerHeight,
    required this.gutter,
  });

  final double containerMaxWidth;
  final double sidebarWidth;
  final double headerHeight;
  final double gutter;

  @override
  AppThemeTokens copyWith({
    double? containerMaxWidth,
    double? sidebarWidth,
    double? headerHeight,
    double? gutter,
  }) {
    return AppThemeTokens(
      containerMaxWidth: containerMaxWidth ?? this.containerMaxWidth,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      headerHeight: headerHeight ?? this.headerHeight,
      gutter: gutter ?? this.gutter,
    );
  }

  @override
  AppThemeTokens lerp(
    covariant ThemeExtension<AppThemeTokens>? other,
    double t,
  ) {
    if (other is! AppThemeTokens) return this;
    return AppThemeTokens(
      containerMaxWidth: lerpDouble(
        containerMaxWidth,
        other.containerMaxWidth,
        t,
      )!,
      sidebarWidth: lerpDouble(sidebarWidth, other.sidebarWidth, t)!,
      headerHeight: lerpDouble(headerHeight, other.headerHeight, t)!,
      gutter: lerpDouble(gutter, other.gutter, t)!,
    );
  }
}
