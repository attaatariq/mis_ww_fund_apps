import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ComplaintModel.dart';

class ComplaintItem extends StatefulWidget {
  ComplaintModel complaintModel;

  ComplaintItem(this.complaintModel);

  @override
  _ComplaintItemState createState() => _ComplaintItemState();
}

class _ComplaintItemState extends State<ComplaintItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
  }

  @override
  Widget build(BuildContext context) {
    bool hasResponse = widget.complaintModel.hasResponse;
    String type = widget.complaintModel.type ?? "";
    String subject = widget.complaintModel.subject ?? "";
    String message = widget.complaintModel.message ?? "";
    String createdAt = widget.complaintModel.createdAt ?? "";
    
    bool isValidResponderImage = widget.complaintModel.responderImage != null &&
                                 widget.complaintModel.responderImage.isNotEmpty &&
                                 widget.complaintModel.responderImage != "null" &&
                                 widget.complaintModel.responderImage != "-" &&
                                 widget.complaintModel.responderImage != "N/A";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasResponse
              ? AppTheme.colors.newPrimary.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: hasResponse ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: hasResponse
                ? AppTheme.colors.newPrimary.withOpacity(0.1)
                : Colors.black.withOpacity(0.06),
            blurRadius: hasResponse ? 12 : 8,
            offset: Offset(0, hasResponse ? 4 : 2),
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
              color: hasResponse
                  ? AppTheme.colors.newPrimary.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasResponse
                        ? AppTheme.colors.newPrimary.withOpacity(0.1)
                        : AppTheme.colors.colorDarkGray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasResponse ? Icons.check_circle_outline : Icons.pending_outlined,
                    color: hasResponse
                        ? AppTheme.colors.newPrimary
                        : AppTheme.colors.colorDarkGray,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject
                      Text(
                        subject.isNotEmpty ? subject : "No Subject",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 16,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      // Type and Date Row
                      Row(
                        children: [
                          if (type.isNotEmpty && type != "null" && type != "-")
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.colors.newPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: AppTheme.colors.newPrimary,
                                  fontSize: 10,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (type.isNotEmpty && type != "null" && type != "-" && createdAt.isNotEmpty)
                            SizedBox(width: 8),
                          if (createdAt.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
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
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasResponse
                        ? Color(0xFF4CAF50).withOpacity(0.1)
                        : Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hasResponse ? "Responded" : "Pending",
                    style: TextStyle(
                      color: hasResponse ? Color(0xFF4CAF50) : Color(0xFFFF9800),
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Message Section
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.message_outlined,
                      size: 14,
                      color: AppTheme.colors.colorDarkGray,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Complaint",
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
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),

          // Response Section or Pending Message
          if (!hasResponse)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFFFF9800).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 16,
                      color: Color(0xFFFF9800),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        Strings.instance.awaitResponse,
                        style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // Response Section
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.colors.newPrimary,
                    AppTheme.colors.newPrimary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.colors.newPrimary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Responder Info
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.colors.newWhite.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: isValidResponderImage
                              ? FadeInImage(
                                  image: NetworkImage(constants.getImageBaseURL() + widget.complaintModel.responderImage),
                                  placeholder: AssetImage("archive/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "archive/images/no_image.jpg",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "archive/images/no_image.jpg",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.complaintModel.responderName.isNotEmpty &&
                                      widget.complaintModel.responderName != "null"
                                  ? widget.complaintModel.responderName
                                  : "Admin",
                              style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 14,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            if (widget.complaintModel.responderRoleName.isNotEmpty &&
                                widget.complaintModel.responderRoleName != "null")
                              Text(
                                "${widget.complaintModel.responderRoleName}${widget.complaintModel.responderSectorName.isNotEmpty && widget.complaintModel.responderSectorName != "null" ? " • ${widget.complaintModel.responderSectorName}" : ""}",
                                style: TextStyle(
                                  color: AppTheme.colors.newWhite.withOpacity(0.9),
                                  fontSize: 11,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(
                    color: AppTheme.colors.newWhite.withOpacity(0.3),
                    height: 1,
                  ),
                  SizedBox(height: 12),
                  // Response Text
                  Text(
                    widget.complaintModel.complaintResponse,
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  if (widget.complaintModel.respondedAt.isNotEmpty &&
                      widget.complaintModel.respondedAt != "null")
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppTheme.colors.newWhite.withOpacity(0.8),
                          ),
                          SizedBox(width: 4),
                          Text(
                            constants.GetFormatedDate(widget.complaintModel.respondedAt),
                            style: TextStyle(
                              color: AppTheme.colors.newWhite.withOpacity(0.8),
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
