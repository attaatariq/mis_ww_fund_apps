import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';

/// A standardized, professional header widget for all screens
/// Based on the improved "My Children" screen design
class StandardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBackPressed;
  final Widget actionButton;
  final IconData actionIcon;
  final VoidCallback onActionPressed;
  final String actionLabel;
  final bool showBackButton;
  final Color backgroundColor;

  StandardHeader({
    Key key,
    @required this.title,
    this.subtitle,
    this.onBackPressed,
    this.actionButton,
    this.actionIcon,
    this.onActionPressed,
    this.actionLabel,
    this.showBackButton = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundColor != null
              ? [
                  backgroundColor,
                  backgroundColor.withOpacity(0.8),
                ]
              : [
                  AppTheme.colors.newPrimary,
                  AppTheme.colors.newPrimary.withOpacity(0.8),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Back Button
              if (showBackButton)
                InkWell(
                  onTap: onBackPressed != null ? onBackPressed : () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppTheme.colors.newWhite,
                      size: 24,
                    ),
                  ),
                ),
              if (showBackButton) SizedBox(width: 12),
              
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppTheme.colors.newWhite.withOpacity(0.9),
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Action Button
              if (actionButton != null || actionIcon != null || actionLabel != null)
                SizedBox(width: 8),
              if (actionButton != null)
                actionButton
              else if (actionIcon != null || actionLabel != null)
                InkWell(
                  onTap: onActionPressed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: actionLabel != null ? 12 : 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.newWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: actionIcon != null && actionLabel != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                actionIcon,
                                color: AppTheme.colors.newWhite,
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                actionLabel,
                                style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 13,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Icon(
                            actionIcon != null ? actionIcon : Icons.add,
                            color: AppTheme.colors.newWhite,
                            size: 24,
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

