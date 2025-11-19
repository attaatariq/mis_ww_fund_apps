import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/ClaimStageModel.dart';

class ClaimStagesHelper {
  // Get color based on API color value
  static Color getColorFromAPIColor(String apiColor) {
    if (apiColor == null || apiColor.isEmpty) {
      return Color(0xFF6B7280); // Gray default
    }

    switch (apiColor.toLowerCase()) {
      case 'primary':
      case 'success':
        return Color(0xFF10B981); // Green for approved/granted
      case 'danger':
      case 'error':
        return Color(0xFFEF4444); // Red for rejected
      case 'warning':
        return Color(0xFFF59E0B); // Amber for suspended
      case 'info':
        return Color(0xFF3B82F6); // Blue for initiated
      case 'dark':
        return Color(0xFF1F2937); // Dark for under review
      default:
        return Color(0xFF6B7280); // Gray default
    }
  }

  // Get icon based on state
  static IconData getIconFromState(String state) {
    if (state == null || state.isEmpty) {
      return Icons.help_outline;
    }

    String lowerState = state.toLowerCase();

    if (lowerState.contains('approved') || lowerState.contains('granted')) {
      return Icons.check_circle;
    }
    if (lowerState.contains('rejected')) {
      return Icons.cancel;
    }
    if (lowerState.contains('suspended')) {
      return Icons.pause_circle;
    }
    if (lowerState.contains('initiated')) {
      return Icons.play_circle_outline;
    }
    if (lowerState.contains('review') || lowerState.contains('audit')) {
      return Icons.rate_review;
    }

    return Icons.info_outline;
  }

  // Build status badge for list items (shows state value with title as tooltip)
  static Widget buildListStatusBadge(
    String stageKey, {
    double fontSize = 10,
    bool showTooltip = true,
  }) {
    final stageData = ClaimStagesData.instance.getStage(stageKey);
    final color = getColorFromAPIColor(stageData.color);

    Widget badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        stageData.state, // Show state value on listing screens
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "AppFont",
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (showTooltip && stageData.title.isNotEmpty) {
      return Tooltip(
        message: stageData.title,
        child: badge,
      );
    }

    return badge;
  }

  // Build detailed status card for detail views (shows stage and title)
  static Widget buildDetailStatusCard(String stageKey) {
    final stageData = ClaimStagesData.instance.getStage(stageKey);
    final color = getColorFromAPIColor(stageData.color);
    final icon = getIconFromState(stageData.state);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Status",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      stageData.stage,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stageData.state,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (stageData.title.isNotEmpty) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: color,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stageData.title,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Build compact status indicator for headers
  static Widget buildCompactStatusIndicator(String stageKey, {double size = 12}) {
    final stageData = ClaimStagesData.instance.getStage(stageKey);
    final color = getColorFromAPIColor(stageData.color);

    return Tooltip(
      message: "${stageData.state}: ${stageData.title}",
      child: Container(
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
      ),
    );
  }

  // Get text color that contrasts with background
  static Color getContrastTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

