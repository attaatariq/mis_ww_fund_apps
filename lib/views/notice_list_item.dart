import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/NoticeModel.dart';

class NoticeListItem extends StatefulWidget {
  NoticeModel noticeModel;
  bool isNews;

  NoticeListItem(this.noticeModel, {this.isNews = false});

  @override
  _NoticeListItemState createState() => _NoticeListItemState();
}

class _NoticeListItemState extends State<NoticeListItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
  }

  @override
  Widget build(BuildContext context) {
    String heading = widget.noticeModel.alert_heading ?? "";
    String subject = widget.noticeModel.alert_subject ?? "";
    String message = widget.noticeModel.alert_message ?? "";
    String recipient = widget.noticeModel.alert_recipient ?? "";
    String createdAt = widget.noticeModel.created_at ?? "";

    Color primaryColor = widget.isNews 
        ? Color(0xFF2196F3) // Blue for News
        : Color(0xFFFF9800); // Orange for Notices

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.5),
                topRight: Radius.circular(14.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.isNews ? Icons.newspaper : Icons.announcement,
                    color: AppTheme.colors.newWhite,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading Badge
                      if (heading.isNotEmpty && heading != "null" && heading != "-")
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newWhite.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            heading,
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 10,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (heading.isNotEmpty && heading != "null" && heading != "-")
                        SizedBox(height: 8),
                      // Subject
                      Text(
                        subject.isNotEmpty ? subject : "No Subject",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 17,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
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

          // Content Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipient Badge
                if (recipient.isNotEmpty && recipient != "null" && recipient != "-")
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                      SizedBox(width: 6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          recipient,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (recipient.isNotEmpty && recipient != "null" && recipient != "-")
                  SizedBox(height: 12),

                // Message
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 14,
                      color: AppTheme.colors.colorDarkGray,
                    ),
                    SizedBox(width: 6),
                    Text(
                      widget.isNews ? "News" : "Notice",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.colorLightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message.isNotEmpty ? message : "No message",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                // Date
                if (createdAt.isNotEmpty && createdAt != "null" && createdAt != "-")
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppTheme.colors.colorDarkGray,
                        ),
                        SizedBox(width: 4),
                        Text(
                          constants.GetFormatedDate(createdAt),
                          style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 11,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal,
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
}

