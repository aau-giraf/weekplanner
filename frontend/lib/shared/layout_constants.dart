/// Layout constants for the GIRAF tablet landscape design.
///
/// All Flutter apps in the GIRAF platform target iPad/iPhone in landscape
/// orientation (1024×768 baseline). These constants ensure consistent
/// content widths and sizing across screens.
class GirafLayout {
  /// Maximum width for the main content area (day view, week overview).
  static const double maxContentWidth = 900.0;

  /// Maximum width for narrow screens (org/citizen pickers).
  static const double maxNarrowWidth = 700.0;

  /// Height of the label strip at the bottom of activity tiles.
  static const double tileLabelHeight = 48.0;

  /// Size of each day selector button (Mon–Sun).
  static const double daySelectorSize = 72.0;
}
