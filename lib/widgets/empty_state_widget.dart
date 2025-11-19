import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';

/// A reusable widget to display consistent empty states across the application
/// with an icon, message, and optional description
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String description;
  final double iconSize;
  final double messageFontSize;
  final VoidCallback onRetry;
  final String retryButtonText;

  EmptyStateWidget({
    Key key,
    this.icon,
    this.message,
    this.description,
    this.iconSize = 64,
    this.messageFontSize = 16,
    this.onRetry,
    this.retryButtonText = 'Retry',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with subtle background circle
            Container(
              width: iconSize + 32,
              height: iconSize + 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.colors.colorLightGray,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Primary message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: messageFontSize,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            
            // Optional description
            if (description != null && description.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ],
            
            // Optional retry button
            if (onRetry != null) ...[
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 18),
                label: Text(
                  retryButtonText,
                  style: TextStyle(
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.colors.newPrimary,
                  onPrimary: AppTheme.colors.newWhite,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Preset empty states for common scenarios
class EmptyStates {
  // No data available
  static Widget noData({String message}) => EmptyStateWidget(
    icon: Icons.inbox_outlined,
    message: message != null && message.isNotEmpty ? message : 'No Data Found',
    description: 'There are no records to display at the moment.',
  );

  // No results from search
  static Widget noSearchResults({String query}) => EmptyStateWidget(
    icon: Icons.search_off,
    message: 'No Results Found',
    description: query != null && query.isNotEmpty
        ? 'We couldn\'t find anything matching "$query"'
        : 'Try adjusting your search terms',
  );

  // No notifications
  static Widget noNotifications() => EmptyStateWidget(
    icon: Icons.notifications_none_outlined,
    message: 'No Notifications',
    description: 'You\'re all caught up! No new notifications.',
  );

  // No alerts
  static Widget noAlerts() => EmptyStateWidget(
    icon: Icons.notifications_off_outlined,
    message: 'No Alerts',
    description: 'There are no alerts at this time.',
  );

  // Error state with retry
  static Widget error({
    String message,
    VoidCallback onRetry,
  }) => EmptyStateWidget(
    icon: Icons.error_outline,
    message: message != null && message.isNotEmpty ? message : 'Something went wrong',
    description: 'We encountered an issue loading your data.',
    onRetry: onRetry,
  );

  // Network error
  static Widget networkError({VoidCallback onRetry}) => EmptyStateWidget(
    icon: Icons.wifi_off_outlined,
    message: 'No Internet Connection',
    description: 'Please check your connection and try again.',
    onRetry: onRetry,
  );

  // No claims
  static Widget noClaims({String type}) => EmptyStateWidget(
    icon: Icons.description_outlined,
    message: 'No ${type != null && type.isNotEmpty ? type : ''} Claims',
    description: 'You haven\'t submitted any claims yet.',
  );

  // No children
  static Widget noChildren() => EmptyStateWidget(
    icon: Icons.family_restroom_outlined,
    message: 'No Children Added',
    description: 'Add children information to manage their records.',
  );

  // No education records
  static Widget noEducation() => EmptyStateWidget(
    icon: Icons.school_outlined,
    message: 'No Education Records',
    description: 'Add education information to track academic details.',
  );
}

