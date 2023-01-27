import 'package:flutter/material.dart';
import 'package:welfare_claims_app/ImageViewer/ImageViewer.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/HajjClaimModel.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class HajjClaimItem extends StatefulWidget {
  Constants constants;
  HajjClaimModel hajjClaimModel;

  HajjClaimItem(this.constants, this.hajjClaimModel);

  @override
  _HajjClaimItemState createState() => _HajjClaimItemState();
}

class _HajjClaimItemState extends State<HajjClaimItem> {
  @override
  Widget build(BuildContext context) {
    String reciptDocURL= widget.constants.getImageBaseURL()+widget.hajjClaimModel.claim_receipt;
    return Container(
      margin: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppTheme.colors.white,
          border: Border.all(color: AppTheme.colors.colorDarkGray, width: 1)
      ),

      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: UserSessions.instance.getUserImage != "null" && UserSessions.instance.getUserImage != "" && UserSessions.instance.getUserImage != "NULL" ? FadeInImage(
                      image: NetworkImage(widget.constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                      placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                      fit: BoxFit.fill,
                    ) : Image.asset("assets/images/no_image_placeholder.jpg",
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
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilgrim Company",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 2,),

                      Text(widget.hajjClaimModel.comp_name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilgrim Designation",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 2,),

                      Text(widget.hajjClaimModel.emp_about,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 20,),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Amount",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 2,),

                      Text(widget.hajjClaimModel.claim_amount+" PKR",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Submission Date",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 2,),

                      Text(widget.hajjClaimModel.created_at,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 20,),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ImageViewer(reciptDocURL)
                    ));
                  },
                  child: Container(
                    height: 170,
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: reciptDocURL != null && reciptDocURL != "" && reciptDocURL != "NULL" && reciptDocURL != "null" && reciptDocURL != "N/A"  ? FadeInImage(
                            image: NetworkImage(reciptDocURL),
                            placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ) : Image.asset("assets/images/no_image_placeholder.jpg",
                            height: 170.0,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newBlack.withAlpha(400),
                            ),

                            child: Center(
                              child: Text("Receipt",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.newWhite,
                                    fontSize: 10,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
