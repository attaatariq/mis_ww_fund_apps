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
    String childImage = widget.claimModel.child_image ?? "";
    String childName = widget.claimModel.child_name ?? "";
    String childCnic = widget.claimModel.child_cnic ?? "";
    String beneficiary = widget.claimModel.beneficiary ?? "";
    String startDate = widget.claimModel.start_date ?? "";
    String endDate = widget.claimModel.end_date ?? "";
    String claimAmount = widget.claimModel.claim_amount ?? "";
    String claimStage = widget.claimModel.claim_stage ?? "";
    String createdAt = widget.claimModel.created_at ?? "";
    
    bool isValidImage = childImage != "null" && 
                       childImage != "" && 
                       childImage != "NULL" &&
                       childImage != "-" &&
                       childImage != "N/A";
    
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
          // Child Info Row
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
                          image: NetworkImage(widget.constants.getImageBaseURL() + childImage),
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
                      childName.isNotEmpty ? childName : "Child",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 16,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (childCnic.isNotEmpty && childCnic != "-")
                      Text(
                        childCnic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
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
                  fontSize: 10,
                  showTooltip: true,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Claim Period & Amount Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Period",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "$startDate - $endDate",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 13,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Claim Amount",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "PKR ${claimAmount}",
                      style: TextStyle(
                        color: AppTheme.colors.newPrimary,
                        fontSize: 15,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Beneficiary & Created Date
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      beneficiary == "Child" ? Icons.child_care : Icons.person,
                      size: 12,
                      color: AppTheme.colors.newPrimary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      beneficiary.isNotEmpty ? beneficiary : "N/A",
                      style: TextStyle(
                        color: AppTheme.colors.newPrimary,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              Spacer(),
              
              if (createdAt.isNotEmpty && createdAt != "-")
                Text(
                  createdAt,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

