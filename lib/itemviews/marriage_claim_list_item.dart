import 'package:flutter/material.dart';
import 'package:welfare_claims_app/models/MarriageClaimModel.dart';

import '../colors/app_colors.dart';
import '../screens/home/EmployeeHomeData/marriage_claim_detail.dart';

class MarriageClaimListItem extends StatefulWidget {
  MarriageClaimModel marriageClaimModel;

  MarriageClaimListItem(this.marriageClaimModel);

  @override
  _MarriageClaimListItemState createState() => _MarriageClaimListItemState();
}

class _MarriageClaimListItemState extends State<MarriageClaimListItem> {
  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Husband Name",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.marriageClaimModel.claim_husband,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.black,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Marriage Date",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.marriageClaimModel.claim_dated,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.black,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.marriageClaimModel.claim_category,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.black,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Claim Status",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.marriageClaimModel.claim_stage,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorPoor,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 10,),

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
