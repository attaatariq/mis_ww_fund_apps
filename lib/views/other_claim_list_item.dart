import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/FeeClaimModel.dart';
import 'package:wwf_apps/models/OtherClaimModel.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

class OtherClaimListItem extends StatefulWidget {
  Constants constants;
  OtherClaimModel otherClaimModel;

  OtherClaimListItem(this.constants, this.otherClaimModel);

  @override
  _OtherClaimListItemState createState() => _OtherClaimListItemState();
}

class _OtherClaimListItemState extends State<OtherClaimListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: AppTheme.colors.newWhite,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppTheme.colors.colorDarkGray, width: 1)
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

                    Container(
                      height: 28,
                      width: 70,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppTheme.colors.colorExelent
                      ),

                      child: Center(
                        child: Text(
                          widget.otherClaimModel.claim_stage,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 10,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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

                      Text(widget.otherClaimModel.for_whom+" ("+widget.otherClaimModel.claim_excluded+")",
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

                      Text(widget.otherClaimModel.claim_biannual +" "+widget.otherClaimModel.claim_year,
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

                Text(widget.otherClaimModel.claim_payment+" PKR - "+widget.otherClaimModel.claim_amount+" PKR",
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
