import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';

/// Centralized Form Theme
/// Provides consistent styling for all form elements across the app
class FormTheme {
  // Color Scheme
  static const Color primaryColor = Color(0xFF2CC285); // Primary green
  static const Color secondaryColor = Color(0xFF363636); // Dark gray
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color errorColor = Color(0xFFEA4235); // Red
  static const Color borderColor = Color(0xFFE0E0E0); // Light gray border
  static const Color hintColor = Color(0xFF939598); // Gray hint text
  static const Color disabledColor = Color(0xFFF5F5F5); // Disabled background

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;

  // Border Radius
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;

  // Input Field Styles
  static InputDecoration inputDecoration({
    String hint,
    String label,
    IconData prefixIcon,
    Widget suffixIcon,
    bool hasError = false,
    bool isFocused = false,
    bool isEnabled = true,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: hintColor,
        fontSize: 14,
        fontFamily: "AppFont",
        fontWeight: FontWeight.normal,
      ),
      labelText: label,
      labelStyle: TextStyle(
        color: isFocused ? primaryColor : hintColor,
        fontSize: 14,
        fontFamily: "AppFont",
        fontWeight: FontWeight.normal,
      ),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                prefixIcon,
                color: hasError
                    ? errorColor
                    : isFocused
                        ? primaryColor
                        : hintColor,
                size: 20,
              ),
            )
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isEnabled ? backgroundColor : disabledColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: prefixIcon != null ? 12 : 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: BorderSide(
          color: hasError ? errorColor : borderColor,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: BorderSide(
          color: hasError ? errorColor : borderColor,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: BorderSide(
          color: hasError ? errorColor : primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: BorderSide(
          color: errorColor,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      ),
    );
  }

  // Text Styles
  static TextStyle labelStyle = TextStyle(
    color: secondaryColor,
    fontSize: 13,
    fontFamily: "AppFont",
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle inputTextStyle = TextStyle(
    color: secondaryColor,
    fontSize: 14,
    fontFamily: "AppFont",
    fontWeight: FontWeight.normal,
  );

  static TextStyle errorTextStyle = TextStyle(
    color: errorColor,
    fontSize: 12,
    fontFamily: "AppFont",
    fontWeight: FontWeight.normal,
  );

  static TextStyle buttonTextStyle = TextStyle(
    color: backgroundColor,
    fontSize: 15,
    fontFamily: "AppFont",
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  // Box Decoration for Form Containers
  static BoxDecoration containerDecoration({
    bool hasError = false,
    bool isFocused = false,
    bool isEnabled = true,
  }) {
    return BoxDecoration(
      color: isEnabled ? backgroundColor : disabledColor,
      borderRadius: BorderRadius.circular(borderRadiusM),
      border: Border.all(
        color: hasError
            ? errorColor
            : isFocused
                ? primaryColor
                : borderColor,
        width: hasError || isFocused ? 2 : 1.5,
      ),
      boxShadow: isFocused && !hasError
          ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ]
          : [],
    );
  }

  // Button Styles
  static BoxDecoration primaryButtonDecoration({bool isEnabled = true}) {
    return BoxDecoration(
      color: isEnabled ? primaryColor : disabledColor,
      borderRadius: BorderRadius.circular(borderRadiusM),
      boxShadow: isEnabled
          ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ]
          : [],
    );
  }

  static BoxDecoration secondaryButtonDecoration({bool isEnabled = true}) {
    return BoxDecoration(
      color: isEnabled ? backgroundColor : disabledColor,
      borderRadius: BorderRadius.circular(borderRadiusM),
      border: Border.all(
        color: isEnabled ? primaryColor : borderColor,
        width: 1.5,
      ),
    );
  }
}

