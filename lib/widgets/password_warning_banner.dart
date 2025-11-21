import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/screens/general/change_password.dart';

class PasswordWarningBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onChangePassword;

  PasswordWarningBanner({
    this.onDismiss,
    this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9C4), // Light yellow background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFFFD54F).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: EdgeInsets.only(left: 16, right: 100, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline
                Text(
                  "HEY THERE, PASSWORD UPDATE REQUIRED FOR ENHANCED SECURITY.",
                  style: TextStyle(
                    color: Color(0xFF5D4037), // Dark brown
                    fontSize: 14,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8),
                // Body text
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Color(0xFF5D4037), // Dark brown
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: "Your current password falls short of security standards. To improve your account's security, update to a stronger password. ",
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: onChangePassword ?? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Change Password.",
                            style: TextStyle(
                              color: Color(0xFF4CAF50), // Green
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bear Image on the right
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Container(
              width: 90,
              alignment: Alignment.center,
              child: Image.asset(
                "archive/images/waving-bear.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image doesn't exist
                  return Icon(
                    Icons.warning_amber_rounded,
                    size: 60,
                    color: Color(0xFFFFD54F),
                  );
                },
              ),
            ),
          ),
          // Dismiss button (optional)
          if (onDismiss != null)
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: onDismiss,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

