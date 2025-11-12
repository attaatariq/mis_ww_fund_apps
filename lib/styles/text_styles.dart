import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';

/// Centralized text styles for consistent typography across the application
/// Provides a comprehensive set of pre-defined text styles following Material Design guidelines
class AppTextStyles {
  AppTextStyles._();

  // Font family constant
  static const String _fontFamily = "AppFont";

  // ============================================================
  // DISPLAY STYLES - For prominent headings and hero text
  // ============================================================
  
  static TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppTheme.colors.newBlack,
    height: 1.2,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppTheme.colors.newBlack,
    height: 1.3,
  );

  static TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppTheme.colors.newBlack,
    height: 1.3,
  );

  // ============================================================
  // HEADING STYLES - For section headers and titles
  // ============================================================
  
  static TextStyle headingLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppTheme.colors.newBlack,
    height: 1.4,
  );

  static TextStyle headingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppTheme.colors.newBlack,
    height: 1.4,
  );

  static TextStyle headingSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppTheme.colors.newBlack,
    height: 1.4,
  );

  // ============================================================
  // BODY STYLES - For main content and descriptions
  // ============================================================
  
  static TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    color: AppTheme.colors.newBlack,
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    color: AppTheme.colors.newBlack,
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    color: AppTheme.colors.newBlack,
    height: 1.4,
  );

  // ============================================================
  // LABEL STYLES - For form labels and captions
  // ============================================================
  
  static TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: AppTheme.colors.colorDarkGray,
    height: 1.4,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: AppTheme.colors.colorDarkGray,
    height: 1.4,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: AppTheme.colors.colorDarkGray,
    height: 1.3,
  );

  // ============================================================
  // BUTTON STYLES - For button text
  // ============================================================
  
  static TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.newWhite,
    height: 1.2,
  );

  static TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.newWhite,
    height: 1.2,
  );

  // ============================================================
  // SPECIAL STYLES - For specific use cases
  // ============================================================
  
  // Card/List item value text
  static TextStyle cardValue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    color: AppTheme.colors.newBlack,
    height: 1.3,
  );

  // Card/List item label text
  static TextStyle cardLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: AppTheme.colors.colorDarkGray,
    height: 1.3,
  );

  // Empty state message
  static TextStyle emptyState = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppTheme.colors.colorDarkGray,
    height: 1.4,
  );

  // Error message
  static TextStyle error = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    color: AppTheme.colors.colorPoor,
    height: 1.4,
  );

  // Success message
  static TextStyle success = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    color: AppTheme.colors.colorExelent,
    height: 1.4,
  );

  // ============================================================
  // HELPER METHODS - For creating custom variants
  // ============================================================
  
  /// Create a white variant of any text style
  static TextStyle white(TextStyle style) {
    return style.copyWith(color: AppTheme.colors.newWhite);
  }

  /// Create a primary color variant of any text style
  static TextStyle primary(TextStyle style) {
    return style.copyWith(color: AppTheme.colors.newPrimary);
  }

  /// Create a gray variant of any text style
  static TextStyle gray(TextStyle style) {
    return style.copyWith(color: AppTheme.colors.colorDarkGray);
  }

  /// Create a bold variant of any text style
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Create a semi-bold variant of any text style
  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  /// Create an underlined variant of any text style
  static TextStyle underline(TextStyle style) {
    return style.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: style.color,
    );
  }

  /// Create a variant with custom opacity
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }
}

/// Status-specific text styles for claims and other statuses
class StatusTextStyles {
  StatusTextStyles._();

  static TextStyle pending = TextStyle(
    fontFamily: "AppFont",
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.colorBad,
  );

  static TextStyle approved = TextStyle(
    fontFamily: "AppFont",
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.colorExelent,
  );

  static TextStyle rejected = TextStyle(
    fontFamily: "AppFont",
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.colorPoor,
  );

  static TextStyle processing = TextStyle(
    fontFamily: "AppFont",
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.colorGood,
  );

  static TextStyle initiated = TextStyle(
    fontFamily: "AppFont",
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppTheme.colors.colorD13,
  );
}

