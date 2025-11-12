import 'package:flutter/material.dart';
import 'package:welfare_claims_app/models/DeathClaimModel.dart';

import '../colors/app_colors.dart';
import '../screens/home/EmployeeHomeData/death_claim_detail.dart';
import '../utils/claim_stages_helper.dart';

class DeathClaimListItem extends StatefulWidget {
  DeathClaimModel deathClaimModel;

  DeathClaimListItem(this.deathClaimModel);

  @override
  _DeathClaimListItemState createState() => _DeathClaimListItemState();
}

class _DeathClaimListItemState extends State<DeathClaimListItem> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Beneficiary",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.deathClaimModel.bene_name+" ("+widget.deathClaimModel.bene_relation+")",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      "Death Date",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.deathClaimModel.claim_dated,
                      maxLines: 2,
                      textAlign: TextAlign.center,
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
                      "Claim Amount",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      widget.deathClaimModel.claim_amount+" PKR",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 4),
                    ClaimStagesHelper.buildListStatusBadge(
                      widget.deathClaimModel.claim_stage,
                      fontSize: 10,
                      showTooltip: true,
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
                  builder: (context) => DeathClaimDetail(widget.deathClaimModel.claim_id)
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
