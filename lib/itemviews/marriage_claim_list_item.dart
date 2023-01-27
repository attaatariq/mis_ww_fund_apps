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
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colors.colorDarkGray),
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
              height: 40,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,
              child: Center(
                child: Text(
                  "Detail",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.colors.white,
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
