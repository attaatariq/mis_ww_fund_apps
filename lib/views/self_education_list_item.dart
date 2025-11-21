import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/SelfEducationModel.dart';

class SelfEducationListItem extends StatefulWidget {
  SelfEducationModel selfEducationModel;

  SelfEducationListItem(this.selfEducationModel);

  @override
  _SelfEducationListItemState createState() => _SelfEducationListItemState();
}

class _SelfEducationListItemState extends State<SelfEducationListItem> {
  String _formatDate(String date) {
    if (date == null || date.isEmpty || date == "-" || date == "null") {
      return "N/A";
    }
    try {
      // Try to parse and format the date
      if (date.contains("-")) {
        List<String> parts = date.split("-");
        if (parts.length >= 3) {
          return "${parts[2]}-${parts[1]}-${parts[0]}";
        }
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  Color _getEducationLevelColor(String level) {
    if (level == null || level.isEmpty) return AppTheme.colors.newPrimary;
    
    String lowerLevel = level.toLowerCase();
    if (lowerLevel.contains("matric") || lowerLevel.contains("primary") || lowerLevel.contains("middle")) {
      return Color(0xFF4CAF50); // Green for basic education
    } else if (lowerLevel.contains("intermediate") || lowerLevel.contains("fsc") || lowerLevel.contains("ics")) {
      return Color(0xFF2196F3); // Blue for intermediate
    } else if (lowerLevel.contains("bachelor") || lowerLevel.contains("bs") || lowerLevel.contains("ba")) {
      return Color(0xFF9C27B0); // Purple for bachelor
    } else if (lowerLevel.contains("master") || lowerLevel.contains("ms") || lowerLevel.contains("ma")) {
      return Color(0xFFF57C00); // Orange for masters
    } else if (lowerLevel.contains("doctorate") || lowerLevel.contains("phd")) {
      return Color(0xFFD32F2F); // Red for doctorate
    }
    return AppTheme.colors.newPrimary;
  }

  IconData _getEducationLevelIcon(String level) {
    if (level == null || level.isEmpty) return Icons.school;
    
    String lowerLevel = level.toLowerCase();
    if (lowerLevel.contains("matric") || lowerLevel.contains("primary") || lowerLevel.contains("middle")) {
      return Icons.school;
    } else if (lowerLevel.contains("intermediate") || lowerLevel.contains("fsc") || lowerLevel.contains("ics")) {
      return Icons.menu_book;
    } else if (lowerLevel.contains("bachelor") || lowerLevel.contains("bs") || lowerLevel.contains("ba")) {
      return Icons.workspace_premium;
    } else if (lowerLevel.contains("master") || lowerLevel.contains("ms") || lowerLevel.contains("ma")) {
      return Icons.emoji_events;
    } else if (lowerLevel.contains("doctorate") || lowerLevel.contains("phd")) {
      return Icons.verified;
    }
    return Icons.school;
  }

  @override
  Widget build(BuildContext context) {
    String eduLevel = widget.selfEducationModel.edu_level ?? "";
    String eduDegree = widget.selfEducationModel.edu_degree ?? "";
    String eduClass = widget.selfEducationModel.edu_class ?? "";
    String eduNature = widget.selfEducationModel.edu_nature ?? "";
    String schoolName = widget.selfEducationModel.school_name ?? "";
    String eduLiving = widget.selfEducationModel.edu_living ?? "";
    String eduStarted = widget.selfEducationModel.edu_started ?? "";
    String eduEnded = widget.selfEducationModel.edu_ended ?? "";

    Color levelColor = _getEducationLevelColor(eduLevel);
    IconData levelIcon = _getEducationLevelIcon(eduLevel);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: levelColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: levelColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  levelColor,
                  levelColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    levelIcon,
                    color: AppTheme.colors.newWhite,
                    size: 28,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eduLevel.isNotEmpty ? eduLevel : "Education Record",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (eduDegree.isNotEmpty || eduClass.isNotEmpty)
                        SizedBox(height: 4),
                      if (eduDegree.isNotEmpty || eduClass.isNotEmpty)
                        Text(
                          "${eduDegree.isNotEmpty ? eduDegree : ""}${eduDegree.isNotEmpty && eduClass.isNotEmpty ? " - " : ""}${eduClass.isNotEmpty ? eduClass : ""}",
                          style: TextStyle(
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                            fontSize: 13,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // School/Institution Information
                if (schoolName.isNotEmpty && schoolName != "-" && schoolName != "null")
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: levelColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance,
                          size: 18,
                          color: levelColor,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Institution",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 10,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                schoolName,
                                style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 13,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                if (schoolName.isNotEmpty && schoolName != "-" && schoolName != "null")
                  SizedBox(height: 12),

                // Education Details Grid
                Row(
                  children: [
                    // Education Nature
                    if (eduNature.isNotEmpty && eduNature != "-" && eduNature != "null")
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.category,
                          label: "Nature",
                          value: eduNature,
                          color: levelColor,
                        ),
                      ),
                    if (eduNature.isNotEmpty && eduNature != "-" && eduNature != "null" && eduLiving.isNotEmpty && eduLiving != "-" && eduLiving != "null")
                      SizedBox(width: 10),
                    // Living Status
                    if (eduLiving.isNotEmpty && eduLiving != "-" && eduLiving != "null")
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.home,
                          label: "Residency",
                          value: eduLiving,
                          color: levelColor,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 12),

                // Date Range
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.colorLightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: levelColor,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start Date",
                                    style: TextStyle(
                                      color: AppTheme.colors.colorDarkGray,
                                      fontSize: 10,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    _formatDate(eduStarted),
                                    style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "End Date",
                                    style: TextStyle(
                                      color: AppTheme.colors.colorDarkGray,
                                      fontSize: 10,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    _formatDate(eduEnded),
                                    style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    IconData icon,
    String label,
    String value,
    Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 9,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
