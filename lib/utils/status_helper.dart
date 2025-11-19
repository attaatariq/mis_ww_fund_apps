import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';

class StatusHelper {
  // Status color coding based on claim stage
  static Color getStatusColor(String status) {
    if (status == null || status.isEmpty || status == "-") {
      return Colors.grey;
    }

    final normalizedStatus = status.toLowerCase().trim();

    // Completed/Approved stages
    if (normalizedStatus.contains("stage-9") ||
        normalizedStatus.contains("completed") ||
        normalizedStatus.contains("approved") ||
        normalizedStatus.contains("paid") ||
        normalizedStatus.contains("disbursed")) {
      return Color(0xFF10B981); // Green for success
    }

    // Rejected/Cancelled/Suspended stages
    if (normalizedStatus.contains("reject") ||
        normalizedStatus.contains("cancel") ||
        normalizedStatus.contains("suspend") ||
        normalizedStatus.contains("declined")) {
      return Color(0xFFEF4444); // Red for rejection
    }

    // Pending/Initiated stages
    if (normalizedStatus.contains("initiated") ||
        normalizedStatus.contains("stage-1") ||
        normalizedStatus.contains("pending")) {
      return Color(0xFFF59E0B); // Amber for pending
    }

    // In Progress stages (Stage-2 to Stage-8)
    if (normalizedStatus.contains("stage-")) {
      try {
        final stageNumber = int.parse(
            normalizedStatus.replaceAll("stage-", "").trim());
        if (stageNumber >= 2 && stageNumber <= 8) {
          return Color(0xFF3B82F6); // Blue for in progress
        }
      } catch (e) {
        // If parsing fails, return default
      }
    }

    // Default color for unknown statuses
    return AppTheme.colors.colorExelent;
  }

  // Get status icon based on stage
  static IconData getStatusIcon(String status) {
    if (status == null || status.isEmpty || status == "-") {
      return Icons.help_outline;
    }

    final normalizedStatus = status.toLowerCase().trim();

    // Completed/Approved
    if (normalizedStatus.contains("stage-9") ||
        normalizedStatus.contains("completed") ||
        normalizedStatus.contains("approved") ||
        normalizedStatus.contains("paid") ||
        normalizedStatus.contains("disbursed")) {
      return Icons.check_circle;
    }

    // Rejected/Cancelled/Suspended
    if (normalizedStatus.contains("reject") ||
        normalizedStatus.contains("cancel") ||
        normalizedStatus.contains("suspend") ||
        normalizedStatus.contains("declined")) {
      return Icons.cancel;
    }

    // Pending/Initiated
    if (normalizedStatus.contains("initiated") ||
        normalizedStatus.contains("stage-1") ||
        normalizedStatus.contains("pending")) {
      return Icons.schedule;
    }

    // In Progress
    if (normalizedStatus.contains("stage-")) {
      return Icons.autorenew;
    }

    return Icons.info_outline;
  }

  // Get readable status text
  static String getStatusText(String status) {
    if (status == null || status.isEmpty || status == "-") {
      return "Unknown";
    }

    final normalizedStatus = status.toLowerCase().trim();

    if (normalizedStatus.contains("stage-9")) return "Completed";
    if (normalizedStatus.contains("stage-8")) return "Final Review";
    if (normalizedStatus.contains("stage-7")) return "Approval Pending";
    if (normalizedStatus.contains("stage-6")) return "Processing";
    if (normalizedStatus.contains("stage-5")) return "Under Verification";
    if (normalizedStatus.contains("stage-4")) return "Documentation";
    if (normalizedStatus.contains("stage-3")) return "Review";
    if (normalizedStatus.contains("stage-2")) return "Submitted";
    if (normalizedStatus.contains("stage-1") || normalizedStatus.contains("initiated")) {
      return "Initiated";
    }
    if (normalizedStatus.contains("suspend")) return "Suspended";
    if (normalizedStatus.contains("reject")) return "Rejected";
    if (normalizedStatus.contains("cancel")) return "Cancelled";

    // Return original if no match
    return status;
  }

  // Status badge widget
  static Widget buildStatusBadge(String status, {double fontSize = 11}) {
    final color = getStatusColor(status);
    final icon = getStatusIcon(status);
    final text = getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: fontSize + 2,
            color: color,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Compact status badge without icon
  static Widget buildCompactStatusBadge(String status, {double fontSize = 10}) {
    final color = getStatusColor(status);
    final text = getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "AppFont",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Status indicator dot
  static Widget buildStatusDot(String status, {double size = 12}) {
    final color = getStatusColor(status);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

// Touch target helper
class TouchTargetHelper {
  // Minimum touch target size per Material Design guidelines
  static const double minTouchTarget = 48.0;

  // Wrap widget to ensure minimum touch target
  static Widget ensureMinTouchTarget({
    Widget child,
    VoidCallback onTap,
    double minSize = minTouchTarget,
  }) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: child,
      ),
    );
  }

  // Create tappable container with minimum size
  static Widget buildTappableContainer({
    Widget child,
    VoidCallback onTap,
    EdgeInsets padding,
    Color color,
    BorderRadius borderRadius,
    double minHeight = minTouchTarget,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

// Contrast ratio helper for WCAG AA compliance
class ContrastHelper {
  // Calculate relative luminance
  static double _luminance(Color color) {
    final r = _linearize(color.red / 255.0);
    final g = _linearize(color.green / 255.0);
    final b = _linearize(color.blue / 255.0);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double channel) {
    if (channel <= 0.03928) {
      return channel / 12.92;
    }
    return Math.pow((channel + 0.055) / 1.055, 2.4);
  }

  // Calculate contrast ratio between two colors
  static double contrastRatio(Color color1, Color color2) {
    final lum1 = _luminance(color1);
    final lum2 = _luminance(color2);
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  // Check if contrast ratio meets WCAG AA standard
  // AA requires 4.5:1 for normal text, 3:1 for large text
  static bool meetsWCAG_AA(Color foreground, Color background,
      {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  // Check if contrast ratio meets WCAG AAA standard
  // AAA requires 7:1 for normal text, 4.5:1 for large text
  static bool meetsWCAG_AAA(Color foreground, Color background,
      {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return isLargeText ? ratio >= 4.5 : ratio >= 7.0;
  }

  // Get accessible text color for given background
  static Color getAccessibleTextColor(Color background) {
    final whiteContrast = contrastRatio(Colors.white, background);
    final blackContrast = contrastRatio(Colors.black, background);
    return whiteContrast > blackContrast ? Colors.white : Colors.black;
  }
}

class Math {
  static double pow(double base, double exponent) {
    return _pow(base, exponent);
  }

  static double _pow(double base, double exponent) {
    if (exponent == 0) return 1;
    if (exponent == 1) return base;
    if (exponent < 0) return 1 / _pow(base, -exponent);

    double result = 1;
    double currentBase = base;
    int exp = exponent.toInt();
    double fracPart = exponent - exp;

    // Handle integer part
    while (exp > 0) {
      if (exp % 2 == 1) {
        result *= currentBase;
      }
      currentBase *= currentBase;
      exp = exp ~/ 2;
    }

    // Handle fractional part (approximation)
    if (fracPart > 0) {
      result *= (1 + fracPart * (base - 1));
    }

    return result;
  }
}

