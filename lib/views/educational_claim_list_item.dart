import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/EducationalClaimModel.dart';
import 'package:wwf_apps/utils/claim_stages_helper.dart';

class EducationalClaimListItem extends StatefulWidget {
  Constants constants;
  EducationalClaimModel claimModel;

  EducationalClaimListItem(this.constants, this.claimModel);

  @override
  _EducationalClaimListItemState createState() => _EducationalClaimListItemState();
}

class _EducationalClaimListItemState extends State<EducationalClaimListItem> {
  @override
  Widget build(BuildContext context) {
    // Determine which image and name to display
    String displayImage = "";
    String displayName = "";
    String displayCnic = "";
    String displayGender = "";
    
    if (widget.claimModel.beneficiary == "Child" && 
        widget.claimModel.child_name != null && 
        widget.claimModel.child_name.isNotEmpty) {
      // Show child information
      displayImage = widget.claimModel.child_image ?? "";
      displayName = widget.claimModel.child_name ?? "";
      displayCnic = widget.claimModel.child_cnic ?? "";
      displayGender = widget.claimModel.child_gender ?? "";
    } else {
      // Show user information
      displayImage = widget.claimModel.user_image ?? "";
      displayName = widget.claimModel.user_name ?? "";
      displayCnic = widget.claimModel.user_cnic ?? "";
      displayGender = widget.claimModel.user_gender ?? "";
    }
    
    String beneficiary = widget.claimModel.beneficiary ?? "";
    String startDate = widget.claimModel.start_date ?? "";
    String endDate = widget.claimModel.end_date ?? "";
    String claimAmount = widget.claimModel.claim_amount ?? "";
    String claimStage = widget.claimModel.claim_stage ?? "";
    String createdAt = widget.claimModel.created_at ?? "";
    
    bool isValidImage = displayImage != "null" && 
                       displayImage != "" && 
                       displayImage != "NULL" &&
                       displayImage != "-" &&
                       displayImage != "N/A";
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User/Child Info Row
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.colors.newPrimary.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.colors.newPrimary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: isValidImage
                      ? FadeInImage(
                          image: NetworkImage(widget.constants.getImageBaseURL() + displayImage),
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName.isNotEmpty ? displayName : "N/A",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 15,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        if (displayGender.isNotEmpty && displayGender != "-")
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: displayGender.toLowerCase() == "male" 
                                  ? Colors.blue.withOpacity(0.1) 
                                  : Colors.pink.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              displayGender,
                              style: TextStyle(
                                color: displayGender.toLowerCase() == "male" 
                                    ? Colors.blue 
                                    : Colors.pink,
                                fontSize: 9,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    if (displayCnic.isNotEmpty && displayCnic != "-")
                      Text(
                        displayCnic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
              
              SizedBox(width: 8),
              
              Flexible(
                child: ClaimStagesHelper.buildListStatusBadge(
                  claimStage,
                  fontSize: 9,
                  showTooltip: true,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 14),
          
          // Beneficiary Badge & Claim Period
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: beneficiary == "Child" 
                        ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
                        : [AppTheme.colors.newPrimary, AppTheme.colors.newPrimary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: (beneficiary == "Child" ? Color(0xFF6366F1) : AppTheme.colors.newPrimary).withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      beneficiary == "Child" ? Icons.child_care : Icons.person,
                      size: 14,
                      color: AppTheme.colors.newWhite,
                    ),
                    SizedBox(width: 4),
                    Text(
                      beneficiary.isNotEmpty ? beneficiary : "N/A",
                      style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Spacer(),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Claim Period",
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "$startDate - $endDate",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 11,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 12),
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          SizedBox(height: 12),
          
          // Claim Amount & Created Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Claim Amount",
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "PKR ${claimAmount}",
                    style: TextStyle(
                      color: AppTheme.colors.colorExelent,
                      fontSize: 16,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              if (createdAt.isNotEmpty && createdAt != "-")
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.colorDarkGray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                      SizedBox(width: 4),
                      Text(
                        createdAt,
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 11,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
