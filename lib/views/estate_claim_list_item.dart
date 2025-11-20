import 'package:flutter/material.dart';
import 'package:wwf_apps/models/EstateClaimModel.dart';

import '../colors/app_colors.dart';
import '../screens/home/employee/estate_claim_detail.dart';
import '../constants/Constants.dart';

class EstateClaimListItem extends StatefulWidget {
  EstateClaimModel estateClaimModel;
  Constants constants;

  EstateClaimListItem(this.estateClaimModel, {this.constants});

  @override
  _EstateClaimListItemState createState() => _EstateClaimListItemState();
}

class _EstateClaimListItemState extends State<EstateClaimListItem> {
  @override
  Widget build(BuildContext context) {
    // Get constants if not provided
    Constants constants = widget.constants ?? Constants();
    
    // Get user image from model or use default
    String userImage = widget.estateClaimModel.user_image ?? "";
    String userName = widget.estateClaimModel.user_name ?? "";
    String userCnic = widget.estateClaimModel.user_cnic ?? "";
    String schemeName = widget.estateClaimModel.scheme_name ?? widget.estateClaimModel.claim_scheme ?? "";
    
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
                              userName.isNotEmpty ? userName : "Estate Claim",
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
                    ],
                  ),
                )
              ],
            ),

          // If no user info, show scheme name
          if (userName.isEmpty && userImage.isEmpty && schemeName.isNotEmpty)
            Text(
              schemeName,
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
                      Row(
                        children: [
                          Icon(
                            Icons.home_work,
                            size: 12,
                            color: AppTheme.colors.colorDarkGray,
                          ),
                          SizedBox(width: 4),
                          Text("Scheme",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.colorDarkGray,
                                fontSize: 10,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(schemeName.isNotEmpty ? schemeName : widget.estateClaimModel.claim_scheme,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 11,
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
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppTheme.colors.colorDarkGray,
                          ),
                          SizedBox(width: 4),
                          Text("Allotment Date",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.colorDarkGray,
                                fontSize: 10,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(widget.estateClaimModel.claim_dated,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 11,
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

          // Claim Amount
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.colors.newPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.colors.newPrimary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 16,
                  color: AppTheme.colors.newPrimary,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Claim Amount",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),),
                    SizedBox(height: 2),
                    Text(widget.estateClaimModel.claim_amount + " PKR",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newPrimary,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          // View Details Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => EstateClaimDetail(widget.estateClaimModel.claim_id)
                ));
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.colors.newPrimary,
                      AppTheme.colors.newPrimary.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.colors.newPrimary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
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
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppTheme.colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

