import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/NotificationModel.dart';

class NotificationListItem extends StatefulWidget {
  NotificationModel notificationModel;

  NotificationListItem(this.notificationModel);

  @override
  _NotificationListItemState createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
  }

  @override
  Widget build(BuildContext context) {
    bool isRead = widget.notificationModel.isRead;
    String subject = widget.notificationModel.not_subject ?? "";
    String message = widget.notificationModel.not_message ?? "";
    String recipient = widget.notificationModel.not_recipient ?? "";
    String createdAt = widget.notificationModel.created_at ?? "";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRead
              ? Colors.grey.withOpacity(0.15)
              : AppTheme.colors.newPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isRead
                ? Colors.black.withOpacity(0.04)
                : AppTheme.colors.newPrimary.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread Indicator Dot
            if (!isRead)
              Container(
                margin: EdgeInsets.only(top: 4, right: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
            if (isRead) SizedBox(width: 2),
            
            // Notification Icon
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isRead
                    ? AppTheme.colors.colorLightGray
                    : AppTheme.colors.newPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: isRead
                    ? AppTheme.colors.colorDarkGray
                    : AppTheme.colors.newPrimary,
                size: 16,
              ),
            ),
            SizedBox(width: 10),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          subject.isNotEmpty ? subject : "No Subject",
                          style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread Badge
                      if (!isRead)
                        Container(
                          margin: EdgeInsets.only(left: 6),
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "New",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 9,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // Message
                  if (message.isNotEmpty && message != "null" && message != "-")
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  // Footer Row (Recipient & Date)
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Recipient Badge
                        if (recipient.isNotEmpty && recipient != "null" && recipient != "-")
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 10,
                                  color: AppTheme.colors.newPrimary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  recipient,
                                  style: TextStyle(
                                    color: AppTheme.colors.newPrimary,
                                    fontSize: 9,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (recipient.isEmpty || recipient == "null" || recipient == "-")
                          SizedBox.shrink(),
                        
                        // Date
                        if (createdAt.isNotEmpty && createdAt != "null" && createdAt != "-")
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 10,
                                color: AppTheme.colors.colorDarkGray,
                              ),
                              SizedBox(width: 4),
                              Text(
                                constants.GetFormatedDate(createdAt),
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 10,
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
            ),
          ],
        ),
      ),
    );
  }
}

