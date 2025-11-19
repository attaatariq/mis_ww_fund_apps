import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/FeeClaimModel.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/utils/claim_stages_helper.dart';

class FeeClaimListItem extends StatefulWidget {
  Constants constants;
  FeeClaimModel educationClaimModel;

  FeeClaimListItem(this.constants, this.educationClaimModel);

  @override
  _FeeClaimListItemState createState() => _FeeClaimListItemState();
}

class _FeeClaimListItemState extends State<FeeClaimListItem> {
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
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: UserSessions.instance.getUserImage != "null" && UserSessions.instance.getUserImage != "" && UserSessions.instance.getUserImage != "NULL" ? FadeInImage(
                    image: NetworkImage(widget.constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                    placeholder: AssetImage("archive/images/no_image.jpg"),
                    fit: BoxFit.fill,
                  ) : Image.asset("archive/images/no_image.jpg",
                    height: 40.0,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserSessions.instance.getUserName,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 13,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(
                          UserSessions.instance.getUserCNIC,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 10,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),

                    ClaimStagesHelper.buildListStatusBadge(
                      widget.educationClaimModel.claim_stage,
                      fontSize: 10,
                      showTooltip: true,
                    ),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 15,),

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
                      Text("Claim Type",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),

                      Text(widget.educationClaimModel.for_whom+" ("+widget.educationClaimModel.other_charges+")",
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
                      Text("Claim Peroid",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),

                      Text(widget.educationClaimModel.claim_started+" - "+ widget.educationClaimModel.claim_ended,
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

          SizedBox(height: 15,),

          Container(
            margin: EdgeInsets.only(right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Claim Amount",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold
                  ),),

                Text(widget.educationClaimModel.tuition_fee+" PKR - "+widget.educationClaimModel.claim_amount+" PKR",
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
        ],
      ),
    );
  }
}
