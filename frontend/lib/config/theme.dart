import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Raw color palette for the GIRAF design system.
///
/// Widgets should normally consume colors via `Theme.of(context).colorScheme`
/// or the semantic [GirafThemeExtension] accessed through [GirafThemeX].
/// Use these constants directly only when a token is genuinely unsemantic
/// (e.g. a decorative warm shadow).
class GirafColors {
  GirafColors._();

  // Brand
  static const Color primaryOrange = Color(0xFFF58220);
  static const Color orangeDeep = Color(0xFFD96A0A);
  static const Color peach = Color(0xFFFFE3C7);

  // Surfaces
  static const Color cream = Color(0xFFFFF6EC);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color brownDark = Color(0xFF5C2E00);
  static const Color brownMuted = Color(0xFF8A6A4F);

  // Status
  static const Color success = Color(0xFF4CAF7A);
  static const Color successLight = Color(0xFFE5F5E5);
  static const Color error = Color(0xFFE5484D);
  static const Color errorLight = Color(0xFFFFE3E4);

  // Informational accent used for non-primary affordances like grade chips
  // and selection highlights outside the main orange flow.
  static const Color actionBlue = Color(0xFF006EB8);

  // Outlines & dividers
  static const Color outline = Color(0xFFE6D2BC);
  static const Color outlineVariant = Color(0xFFF1E1CC);

  // Warm low-opacity shadow (~8% brownDark)
  static const Color shadow = Color(0x145C2E00);
}

/// Shape tokens.
class GirafRadii {
  GirafRadii._();

  static const double input = 14;
  static const double card = 24;
  static const double pill = 999;

  static final BorderRadius inputRadius = BorderRadius.circular(input);
  static final BorderRadius cardRadius = BorderRadius.circular(card);
  static final BorderRadius pillRadius = BorderRadius.circular(pill);
}

/// Spacing scale (4 / 8 / 12 / 16 / 24 / 32) and minimum tap target.
class GirafSpacing {
  GirafSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Minimum interactive height (buttons, list rows).
  static const double minTouchTarget = 56;
}

/// Fixed-pixel layout constants for the tablet-landscape target.
class GirafLayout {
  GirafLayout._();

  /// Max width for the main content area (day view, week overview).
  static const double maxContentWidth = 900.0;

  /// Max width for narrow screens (org/citizen pickers, login card).
  static const double maxNarrowWidth = 700.0;

  /// Height of the label strip at the bottom of activity tiles.
  static const double tileLabelHeight = 56.0;
}

/// Elevation tokens. Prefer attaching to a [BoxDecoration] rather than
/// [Material.elevation] so the warm shadow is preserved.
class GirafElevation {
  GirafElevation._();

  /// Soft warm shadow used on cards and activity tiles.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: GirafColors.shadow,
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  /// Slightly heavier shadow for the FAB.
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x1F5C2E00),
      offset: Offset(0, 6),
      blurRadius: 18,
    ),
  ];
}

/// Motion tokens.
class GirafMotion {
  GirafMotion._();

  static const Duration dayChip = Duration(milliseconds: 120);
  static const Duration activityTick = Duration(milliseconds: 180);
  static const Duration modalOpen = Duration(milliseconds: 220);
  static const Curve standard = Curves.easeOutCubic;
}

/// Responsive breakpoints (tablet-first).
class GirafBreakpoints {
  GirafBreakpoints._();

  /// Below this width we fall back to a single-column layout.
  static const double phoneMax = 768;

  /// Below this width we use a 3-column layout; above uses 4 columns.
  static const double tabletMax = 1024;

  /// Suggested number of columns for activity grids at a given width.
  static int weekViewColumns(double width) {
    if (width >= tabletMax) return 4;
    if (width >= phoneMax) return 3;
    return 1;
  }
}

/// Material [ColorScheme] built from the GIRAF palette. Declared explicitly
/// rather than via [ColorScheme.fromSeed] to control every pair.
const ColorScheme girafColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: GirafColors.primaryOrange,
  onPrimary: Colors.white,
  primaryContainer: GirafColors.peach,
  onPrimaryContainer: GirafColors.brownDark,
  secondary: GirafColors.brownDark,
  onSecondary: Colors.white,
  secondaryContainer: GirafColors.peach,
  onSecondaryContainer: GirafColors.brownDark,
  tertiary: GirafColors.orangeDeep,
  onTertiary: Colors.white,
  error: GirafColors.error,
  onError: Colors.white,
  surface: GirafColors.surface,
  onSurface: GirafColors.brownDark,
  surfaceContainerHighest: GirafColors.peach,
  onSurfaceVariant: GirafColors.brownMuted,
  outline: GirafColors.outline,
  outlineVariant: GirafColors.outlineVariant,
  shadow: GirafColors.shadow,
  scrim: Color(0x995C2E00),
  inverseSurface: GirafColors.brownDark,
  onInverseSurface: GirafColors.cream,
  inversePrimary: GirafColors.peach,
);

/// Typography — Nunito via google_fonts, wrapped around the GIRAF scale.
class GirafTypography {
  GirafTypography._();

  static const TextStyle _display = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    color: GirafColors.brownDark,
  );

  static const TextStyle _h2 = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: GirafColors.brownDark,
  );

  static const TextStyle _body = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    color: GirafColors.brownDark,
  );

  static const TextStyle _caption = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
    color: GirafColors.brownMuted,
  );

  static const TextStyle _button = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: Colors.white,
  );

  static TextTheme _scale(TextTheme base) => base.copyWith(
        displayLarge: _display,
        displayMedium: _display,
        displaySmall: _display,
        headlineLarge: _h2,
        headlineMedium: _h2,
        headlineSmall: _h2,
        titleLarge: _h2,
        titleMedium: _body,
        titleSmall: _body,
        bodyLarge: _body,
        bodyMedium: _body,
        bodySmall: _caption,
        labelLarge: _button,
        labelMedium: _caption,
        labelSmall: _caption,
      );

  /// Produces the app's text theme with Nunito applied to every style.
  static TextTheme nunitoTextTheme(TextTheme base) =>
      GoogleFonts.nunitoTextTheme(_scale(base));
}

/// Custom theme extension for GIRAF-specific semantic colors.
///
/// Access via [GirafThemeX.girafColors] on a [BuildContext].
@immutable
class GirafThemeExtension extends ThemeExtension<GirafThemeExtension> {
  /// Accent used for non-primary, informational affordances.
  final Color actionBlue;

  /// Background for pending / not-yet-started activities.
  final Color pendingBackground;

  /// Tick / badge color for completed activities.
  final Color completedIndicator;

  /// Background for completed activities.
  final Color completedBackground;

  /// Background for error / alert containers.
  final Color errorBackground;

  const GirafThemeExtension({
    required this.actionBlue,
    required this.pendingBackground,
    required this.completedIndicator,
    required this.completedBackground,
    required this.errorBackground,
  });

  @override
  GirafThemeExtension copyWith({
    Color? actionBlue,
    Color? pendingBackground,
    Color? completedIndicator,
    Color? completedBackground,
    Color? errorBackground,
  }) =>
      GirafThemeExtension(
        actionBlue: actionBlue ?? this.actionBlue,
        pendingBackground: pendingBackground ?? this.pendingBackground,
        completedIndicator: completedIndicator ?? this.completedIndicator,
        completedBackground: completedBackground ?? this.completedBackground,
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
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
    );
  }
}

/// Context extensions for convenient theme access.
extension GirafThemeX on BuildContext {
  /// The GIRAF semantic color set.
  GirafThemeExtension get girafColors =>
      Theme.of(this).extension<GirafThemeExtension>()!;

  /// The Material [ColorScheme] for the active theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

/// Composed [ThemeData] for the weekplanner app.
class GirafTheme {
  GirafTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: girafColorScheme,
      scaffoldBackgroundColor: GirafColors.cream,
      textTheme: GirafTypography.nunitoTextTheme(ThemeData.light().textTheme),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: InkSparkle.splashFactory,
      extensions: const [
        GirafThemeExtension(
          actionBlue: GirafColors.actionBlue,
          pendingBackground: GirafColors.peach,
          completedIndicator: GirafColors.success,
          completedBackground: GirafColors.successLight,
          errorBackground: GirafColors.errorLight,
        ),
      ],
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: GirafColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 26),
      ),
      cardTheme: CardThemeData(
        color: GirafColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: GirafRadii.cardRadius),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GirafColors.primaryOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: GirafColors.peach,
          disabledForegroundColor: GirafColors.brownMuted,
          minimumSize: const Size.fromHeight(GirafSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: GirafSpacing.xl),
          shape: RoundedRectangleBorder(borderRadius: GirafRadii.pillRadius),
          textStyle: GirafTypography._button,
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return GirafColors.orangeDeep.withValues(alpha: 0.9);
            }
            return null;
          }),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GirafColors.primaryOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: GirafColors.peach,
          disabledForegroundColor: GirafColors.brownMuted,
          minimumSize: const Size.fromHeight(GirafSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: GirafSpacing.xl),
          shape: RoundedRectangleBorder(borderRadius: GirafRadii.pillRadius),
          textStyle: GirafTypography._button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: GirafColors.orangeDeep,
          textStyle: GirafTypography._button
              .copyWith(color: GirafColors.orangeDeep),
          minimumSize: const Size(0, GirafSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: GirafRadii.pillRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GirafColors.brownDark,
          side: const BorderSide(color: GirafColors.brownDark, width: 2),
          minimumSize: const Size.fromHeight(GirafSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: GirafRadii.pillRadius),
          textStyle:
              GirafTypography._button.copyWith(color: GirafColors.brownDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GirafColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GirafSpacing.lg,
          vertical: GirafSpacing.lg,
        ),
        hintStyle: GirafTypography._body
            .copyWith(color: GirafColors.brownMuted),
        labelStyle: GirafTypography._body
            .copyWith(color: GirafColors.brownMuted),
        floatingLabelStyle:
            GirafTypography._caption.copyWith(color: GirafColors.orangeDeep),
        prefixIconColor: GirafColors.brownDark,
        suffixIconColor: GirafColors.brownMuted,
        border: OutlineInputBorder(
          borderRadius: GirafRadii.inputRadius,
          borderSide: const BorderSide(color: GirafColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: GirafRadii.inputRadius,
          borderSide: const BorderSide(color: GirafColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GirafRadii.inputRadius,
          borderSide:
              const BorderSide(color: GirafColors.primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: GirafRadii.inputRadius,
          borderSide: const BorderSide(color: GirafColors.error, width: 2),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: GirafColors.brownDark,
        foregroundColor: Colors.white,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        sizeConstraints: BoxConstraints.tightFor(width: 64, height: 64),
        iconSize: 28,
        shape: CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: GirafColors.surface,
        selectedColor: GirafColors.primaryOrange,
        secondarySelectedColor: GirafColors.peach,
        disabledColor: GirafColors.peach.withValues(alpha: 0.5),
        labelStyle: GirafTypography._body,
        secondaryLabelStyle:
            GirafTypography._body.copyWith(color: GirafColors.brownDark),
        padding: const EdgeInsets.symmetric(
          horizontal: GirafSpacing.md,
          vertical: GirafSpacing.sm,
        ),
        shape: RoundedRectangleBorder(borderRadius: GirafRadii.pillRadius),
        side: BorderSide.none,
        showCheckmark: false,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GirafColors.primaryOrange;
          }
          return GirafColors.peach;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GirafColors.primaryOrange;
          }
          return GirafColors.surface;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: GirafColors.brownMuted, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      dividerTheme: const DividerThemeData(
        color: GirafColors.outlineVariant,
        thickness: 1,
        space: GirafSpacing.lg,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: GirafColors.brownDark,
        contentTextStyle:
            GirafTypography._body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: GirafRadii.inputRadius),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Top-level theme instance consumed by `MaterialApp.router(theme: girafTheme)`.
final ThemeData girafTheme = GirafTheme.light();
