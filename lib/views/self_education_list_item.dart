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
    // Use primary green for Under Matric levels
    if (lowerLevel.contains("matric") || lowerLevel.contains("primary") || lowerLevel.contains("middle") || 
        lowerLevel.contains("playgroup") || lowerLevel.contains("nursery") || lowerLevel.contains("kindergarten")) {
      return AppTheme.colors.newPrimary; // Green primary #2CC285
    } 
    // Use secondary color for Post Matric levels
    else if (lowerLevel.contains("intermediate") || lowerLevel.contains("fsc") || lowerLevel.contains("ics") ||
             lowerLevel.contains("bachelor") || lowerLevel.contains("bs") || lowerLevel.contains("ba") ||
             lowerLevel.contains("master") || lowerLevel.contains("ms") || lowerLevel.contains("ma") ||
             lowerLevel.contains("doctorate") || lowerLevel.contains("phd") || lowerLevel.contains("post doctoral")) {
      return AppTheme.colors.colorAccent; // Secondary #363636
    }
    // Default to primary green
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: levelColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Compact Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  levelColor,
                  levelColor.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.5),
                topRight: Radius.circular(10.5),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    levelIcon,
                    color: AppTheme.colors.newWhite,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        eduLevel.isNotEmpty ? eduLevel : "Education Record",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 15,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (eduDegree.isNotEmpty || eduClass.isNotEmpty)
                        SizedBox(height: 2),
                      if (eduDegree.isNotEmpty || eduClass.isNotEmpty)
                        Text(
                          "${eduDegree.isNotEmpty ? eduDegree : ""}${eduDegree.isNotEmpty && eduClass.isNotEmpty ? " - " : ""}${eduClass.isNotEmpty ? eduClass : ""}",
                          style: TextStyle(
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                            fontSize: 11,
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

          // Compact Content
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // School Name (Compact)
                if (schoolName.isNotEmpty && schoolName != "-" && schoolName != "null")
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 14,
                        color: levelColor,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          schoolName,
                          style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                if (schoolName.isNotEmpty && schoolName != "-" && schoolName != "null")
                  SizedBox(height: 8),

                // Compact Info Row
                Row(
                  children: [
                    // Nature
                    if (eduNature.isNotEmpty && eduNature != "-" && eduNature != "null")
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.category,
                              size: 12,
                              color: levelColor,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                eduNature,
                                style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 11,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (eduNature.isNotEmpty && eduNature != "-" && eduNature != "null" && eduLiving.isNotEmpty && eduLiving != "-" && eduLiving != "null")
                      SizedBox(width: 12),
                    // Living
                    if (eduLiving.isNotEmpty && eduLiving != "-" && eduLiving != "null")
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home,
                              size: 12,
                              color: levelColor,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                eduLiving,
                                style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 11,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 8),

                // Compact Date Range
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: levelColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "${_formatDate(eduStarted)} - ${_formatDate(eduEnded)}",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
