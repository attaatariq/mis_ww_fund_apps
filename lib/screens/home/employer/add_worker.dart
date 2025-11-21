import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/widgets/standard_header.dart';

class AddWorker extends StatefulWidget {
  @override
  _AddWorkerState createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Add Worker",
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.construction,
                      size: 80,
                      color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Coming Soon",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add Worker functionality will be available soon",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                        fontSize: 14,
                        fontFamily: "AppFont",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

