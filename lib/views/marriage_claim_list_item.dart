import 'package:flutter/material.dart';
import 'package:wwf_apps/models/MarriageClaimModel.dart';

import '../colors/app_colors.dart';
import '../screens/home/employee/marriage_claim_detail.dart';
import '../utils/claim_stages_helper.dart';
import '../constants/Constants.dart';

class MarriageClaimListItem extends StatefulWidget {
  MarriageClaimModel marriageClaimModel;
  Constants constants;

  MarriageClaimListItem(this.marriageClaimModel, {this.constants});

  @override
  _MarriageClaimListItemState createState() => _MarriageClaimListItemState();
}

class _MarriageClaimListItemState extends State<MarriageClaimListItem> {
  @override
  Widget build(BuildContext context) {
    // Get constants if not provided
    Constants constants = widget.constants ?? Constants();
    
    // Get user image from model or use default
    String userImage = widget.marriageClaimModel.user_image ?? "";
    String userName = widget.marriageClaimModel.user_name ?? "";
    String userCnic = widget.marriageClaimModel.user_cnic ?? "";
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row (if available)
          if (userName.isNotEmpty || userImage.isNotEmpty)
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: userImage != "null" && 
                           userImage != "" && 
                           userImage != "NULL" &&
                           userImage != "-" &&
                           userImage != "N/A" ? FadeInImage(
                      image: NetworkImage(constants.getImageBaseURL() + userImage),
                      placeholder: AssetImage("archive/images/no_image.jpg"),
                      fit: BoxFit.fill,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset("archive/images/no_image.jpg",
                          height: 40.0,
                          width: 40,
                          fit: BoxFit.fill,
                        );
                      },
                    ) : Image.asset("archive/images/no_image.jpg",
                      height: 40.0,
                      width: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName.isNotEmpty ? userName : "Marriage Claim",
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 13,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            if (userCnic.isNotEmpty)
                              Text(
                                userCnic,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 10,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(width: 8),

                      Flexible(
                        child: ClaimStagesHelper.buildListStatusBadge(
                          widget.marriageClaimModel.claim_stage,
                          fontSize: 10,
                          showTooltip: true,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

          // If no user info, show status badge separately
          if (userName.isEmpty && userImage.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClaimStagesHelper.buildListStatusBadge(
                  widget.marriageClaimModel.claim_stage,
                  fontSize: 10,
                  showTooltip: true,
                ),
              ],
            ),

          SizedBox(height: 15),

          // Claim Details Row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Husband Name",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),

                      Text(widget.marriageClaimModel.claim_husband,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Marriage Date",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),

                      Text(widget.marriageClaimModel.claim_dated,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          // Beneficiary Type
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Beneficiary Type",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold
                  ),),

                Text(widget.marriageClaimModel.beneficiary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold
                  ),),
              ],
            ),
          ),

          SizedBox(height: 15),

          // View Details Button
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MarriageClaimDetail(widget.marriageClaimModel.claim_id)
              ));
            },
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.colors.newPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "View Details",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.colors.white,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
