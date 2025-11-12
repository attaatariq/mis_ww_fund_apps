/// Application-wide spacing and dimension constants
/// Ensures consistency and makes it easy to maintain the design system
class AppDimensions {
  AppDimensions._();

  // ============================================================
  // SPACING SCALE - Based on 4px grid system
  // ============================================================
  
  /// 4px - Minimal spacing for tight layouts
  static const double spacing4 = 4.0;
  
  /// 8px - Small spacing between related elements
  static const double spacing8 = 8.0;
  
  /// 12px - Medium-small spacing, good for list item gaps
  static const double spacing12 = 12.0;
  
  /// 16px - Standard spacing for most UI elements
  static const double spacing16 = 16.0;
  
  /// 20px - Medium spacing between sections
  static const double spacing20 = 20.0;
  
  /// 24px - Large spacing between major sections
  static const double spacing24 = 24.0;
  
  /// 32px - Extra large spacing for distinct separation
  static const double spacing32 = 32.0;
  
  /// 40px - Maximum spacing for major sections
  static const double spacing40 = 40.0;

  // ============================================================
  // PADDING - Common padding values
  // ============================================================
  
  /// Standard horizontal padding for screens
  static const double screenHorizontalPadding = 16.0;
  
  /// Standard vertical padding for screens
  static const double screenVerticalPadding = 16.0;
  
  /// Card/Container padding
  static const double cardPadding = 16.0;
  
  /// List item horizontal padding
  static const double listItemHorizontalPadding = 16.0;
  
  /// List item vertical padding
  static const double listItemVerticalPadding = 12.0;
  
  /// Bottom padding for lists (to clear FAB/bottom nav)
  static const double listBottomPadding = 80.0;

  // ============================================================
  // MARGINS - Common margin values
  // ============================================================
  
  /// Standard margin between cards
  static const double cardMargin = 12.0;
  
  /// Horizontal margin for cards
  static const double cardHorizontalMargin = 16.0;

  // ============================================================
  // BORDER RADIUS - Rounded corners
  // ============================================================
  
  /// Small border radius - for buttons and small elements
  static const double radiusSmall = 4.0;
  
  /// Medium border radius - for cards and inputs
  static const double radiusMedium = 8.0;
  
  /// Large border radius - for prominent cards
  static const double radiusLarge = 12.0;
  
  /// Extra large border radius - for special elements
  static const double radiusXLarge = 16.0;
  
  /// Circular radius for pills and badges
  static const double radiusCircular = 50.0;

  // ============================================================
  // ELEVATION - Shadow depths
  // ============================================================
  
  /// No elevation
  static const double elevationNone = 0.0;
  
  /// Minimal elevation - subtle shadow
  static const double elevationLow = 2.0;
  
  /// Standard elevation - for cards and buttons
  static const double elevationMedium = 4.0;
  
  /// High elevation - for dialogs and modals
  static const double elevationHigh = 8.0;
  
  /// Maximum elevation - for important overlays
  static const double elevationVeryHigh = 16.0;

  // ============================================================
  // ICON SIZES
  // ============================================================
  
  /// Extra small icon - 16px
  static const double iconXSmall = 16.0;
  
  /// Small icon - 20px
  static const double iconSmall = 20.0;
  
  /// Medium icon - 24px (standard)
  static const double iconMedium = 24.0;
  
  /// Large icon - 32px
  static const double iconLarge = 32.0;
  
  /// Extra large icon - 40px
  static const double iconXLarge = 40.0;
  
  /// Empty state icon - 64px
  static const double iconEmptyState = 64.0;

  // ============================================================
  // BUTTON DIMENSIONS
  // ============================================================
  
  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48.0;
  
  /// Standard button height
  static const double buttonHeight = 48.0;
  
  /// Small button height
  static const double buttonHeightSmall = 40.0;
  
  /// Large button height
  static const double buttonHeightLarge = 56.0;
  
  /// Button horizontal padding
  static const double buttonPaddingHorizontal = 24.0;
  
  /// Button vertical padding
  static const double buttonPaddingVertical = 12.0;

  // ============================================================
  // INPUT FIELD DIMENSIONS
  // ============================================================
  
  /// Standard input field height
  static const double inputHeight = 56.0;
  
  /// Small input field height
  static const double inputHeightSmall = 48.0;
  
  /// Input field content padding (vertical)
  static const double inputPaddingVertical = 16.0;
  
  /// Input field content padding (horizontal)
  static const double inputPaddingHorizontal = 16.0;

  // ============================================================
  // APP BAR & HEADER DIMENSIONS
  // ============================================================
  
  /// Standard app bar height
  static const double appBarHeight = 56.0;
  
  /// Large app bar height (with subtitle)
  static const double appBarHeightLarge = 72.0;

  // ============================================================
  // DIVIDER THICKNESS
  // ============================================================
  
  /// Thin divider
  static const double dividerThin = 0.5;
  
  /// Standard divider
  static const double dividerStandard = 1.0;
  
  /// Thick divider
  static const double dividerThick = 2.0;

  // ============================================================
  // COMMON EDGE INSETS
  // ============================================================
  
  /// Screen padding (all sides)
  static const EdgeInsets screenPadding = EdgeInsets.all(spacing16);
  
  /// Screen horizontal padding only
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: spacing16);
  
  /// Screen vertical padding only
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: spacing16);
  
  /// Card padding (all sides)
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);
  
  /// Card margin
  static const EdgeInsets cardMarginAll = EdgeInsets.only(
    top: cardMargin,
    left: cardHorizontalMargin,
    right: cardHorizontalMargin,
  );
  
  /// Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: buttonPaddingHorizontal,
    vertical: buttonPaddingVertical,
  );

  /// Input content padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: inputPaddingHorizontal,
    vertical: inputPaddingVertical,
  );

  /// List bottom padding (to clear FAB)
  static const EdgeInsets listBottomPaddingOnly = EdgeInsets.only(bottom: listBottomPadding);
}

