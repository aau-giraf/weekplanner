import 'package:flutter/material.dart';

/// Internal color palette used only by [girafTheme] and [GirafThemeExtension].
///
/// In widgets, use [Theme.of] via the [GirafThemeX] extension instead.
class GirafColors {
  static const Color orange = Color(0xFFFF8C00);
  static const Color lighterOrange = Color(0xFFFFD494);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF006EB8);
  static const Color lightBlue = Color(0xFFE0F4FF);
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE5F5E5);
  static const Color lightRed = Color(0xFFFFE5E5);
}

/// Standard shape radii for the GIRAF design system.
class GirafShape {
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
}

/// Custom theme extension for GIRAF-specific semantic colors.
///
/// Access via [GirafThemeX.girafColors] on a [BuildContext].
@immutable
class GirafThemeExtension extends ThemeExtension<GirafThemeExtension> {
  /// The blue used for primary action buttons and interactive elements.
  final Color actionBlue;

  /// Background color for activities with a pending/in-progress status.
  final Color pendingBackground;

  /// Indicator color shown when an activity is completed.
  final Color completedIndicator;

  /// Background color for completed activities.
  final Color completedBackground;

  /// A lighter shade of the primary orange, used for subtle accents.
  final Color accentLight;

  /// Background color for error/alert containers.
  final Color errorBackground;

  const GirafThemeExtension({
    required this.actionBlue,
    required this.pendingBackground,
    required this.completedIndicator,
    required this.completedBackground,
    required this.accentLight,
    required this.errorBackground,
  });

  @override
  GirafThemeExtension copyWith({
    Color? actionBlue,
    Color? pendingBackground,
    Color? completedIndicator,
    Color? completedBackground,
    Color? accentLight,
    Color? errorBackground,
  }) =>
      GirafThemeExtension(
        actionBlue: actionBlue ?? this.actionBlue,
        pendingBackground: pendingBackground ?? this.pendingBackground,
        completedIndicator: completedIndicator ?? this.completedIndicator,
        completedBackground: completedBackground ?? this.completedBackground,
        accentLight: accentLight ?? this.accentLight,
        errorBackground: errorBackground ?? this.errorBackground,
      );

  @override
  GirafThemeExtension lerp(GirafThemeExtension? other, double t) {
    if (other is! GirafThemeExtension) return this;
    return GirafThemeExtension(
      actionBlue: Color.lerp(actionBlue, other.actionBlue, t)!,
      pendingBackground:
          Color.lerp(pendingBackground, other.pendingBackground, t)!,
      completedIndicator:
          Color.lerp(completedIndicator, other.completedIndicator, t)!,
      completedBackground:
          Color.lerp(completedBackground, other.completedBackground, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
    );
  }
}

/// Convenience extension for accessing theme colors from a [BuildContext].
extension GirafThemeX on BuildContext {
  /// Returns the GIRAF-specific theme extension colors.
  GirafThemeExtension get girafColors =>
      Theme.of(this).extension<GirafThemeExtension>()!;

  /// Returns the Material [ColorScheme] for the current theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

final ThemeData girafTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: GirafColors.orange,
  ),
  extensions: const [
    GirafThemeExtension(
      actionBlue: GirafColors.blue,
      pendingBackground: GirafColors.lightBlue,
      completedIndicator: GirafColors.green,
      completedBackground: GirafColors.lightGreen,
      accentLight: GirafColors.lighterOrange,
      errorBackground: GirafColors.lightRed,
    ),
  ],
  appBarTheme: const AppBarTheme(
    backgroundColor: GirafColors.orange,
    foregroundColor: GirafColors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: GirafColors.orange,
      foregroundColor: GirafColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(GirafShape.radiusLarge),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GirafShape.radiusSmall),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GirafShape.radiusSmall),
      borderSide: const BorderSide(color: GirafColors.orange, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  useMaterial3: true,
);
