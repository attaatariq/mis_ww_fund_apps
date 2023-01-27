import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/ImageViewer/ImageViewer.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class FeeClaimDetail extends StatefulWidget {
  String calim_ID = "";

  FeeClaimDetail(this.calim_ID);

  @override
  _FeeClaimDetailState createState() => _FeeClaimDetailState();
}

class _FeeClaimDetailState extends State<FeeClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  String applicationFormDoc="", resultCardDoc="", feeVoucherDoc="";
  String for_whom= "-", claim_started= "-", claim_ended= "-", tuition_fee= "-", registration_fee= "-", prospectus_fee= "-", security_fee= "-",
      library_fee= "-", exams_fee= "-", computer_fee= "-", sports_fee= "-", washing_fee= "-", development= "-", fee_arrears= "-", adjustment= "-",
      reimbursment= "-", tax_amount= "-", late_fee_fine= "-", other_fine= "-", other_charges= "-", remarks_1= "-", created_at= "-", claim_stage= "-", claim_amount= "-";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetFeeClaimsDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Detail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 50),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.white,
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
                                  image: NetworkImage(constants.getImageBaseURL()+UserSessions.instance.getUserImage),
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
                                        claim_stage,
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
                      ),

                      SizedBox(height: 10,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Claim Progress",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.colorLightGray,
                          border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Submitted Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(created_at,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Stage",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_stage,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("About",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Duration",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_started+" - "+claim_ended,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Type",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(for_whom,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Claim Amount ("+claim_amount+" PKR)",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Tuition Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(tuition_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Registration Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(registration_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Prospectus Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(prospectus_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Security Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(security_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Libarary Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(library_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Examination Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(exams_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Computer Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(computer_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Sports Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(sports_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Washing Charges",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(washing_fee+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Development Charges",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(development+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Fee Arrears",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(fee_arrears+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Adjustment Charges",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(adjustment+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Reimbursement",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(reimbursment+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Tax on Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(tax_amount+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Late Fee Fine",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(late_fee_fine+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Other Fine",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(other_fine+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Other Charges",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(other_charges+" PKR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Test Remarks",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(remarks_1,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Documents",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(constants.getImageBaseURL()+applicationFormDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: applicationFormDoc != null && applicationFormDoc != "" && applicationFormDoc != "NULL" && applicationFormDoc != "null" && applicationFormDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(constants.getImageBaseURL()+applicationFormDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
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
                                          child: Text("Application Form",
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

                          SizedBox(width: 5,),

                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(constants.getImageBaseURL()+resultCardDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: resultCardDoc != null && resultCardDoc != "" && resultCardDoc != "NULL" && resultCardDoc != "null" && resultCardDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(constants.getImageBaseURL()+resultCardDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
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
                                          child: Text("Result Card",
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
                          )
                        ],
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(constants.getImageBaseURL()+feeVoucherDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: feeVoucherDoc != null && feeVoucherDoc != "" && feeVoucherDoc != "NULL" && feeVoucherDoc != "null" && feeVoucherDoc != "N/A"  ? FadeInImage(
                                        image: NetworkImage(constants.getImageBaseURL()+feeVoucherDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
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
                                          child: Text("Fee Voucher",
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

                          SizedBox(width: 5,),

                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 100,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void GetFeeClaimsDetail() async{
    //uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.claims +
        "fee_claim_info/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken+ "/" +widget.calim_ID;
    var response = await http.get(Uri.parse(url));
    print(url);
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"][0];
        for_whom= data["for_whom"].toString();
        claim_started= data["claim_started"].toString();
        claim_ended= data["claim_ended"].toString();
        tuition_fee= data["tuition_fee"].toString();
        registration_fee= data["registration_fee"].toString();
        prospectus_fee= data["prospectus_fee"].toString();
        security_fee= data["security_fee"].toString();
        library_fee= data["library_fee"].toString();
        exams_fee= data["exams_fee"].toString();
        computer_fee= data["computer_fee"].toString();
        sports_fee= data["sports_fee"].toString();
        washing_fee= data["washing_fee"].toString();
        development= data["development"].toString();
        fee_arrears= data["fee_arrears"].toString();
        adjustment= data["adjustment"].toString();
        reimbursment= data["reimbursment"].toString();
        tax_amount= data["tax_amount"].toString();
        late_fee_fine= data["late_fee_fine"].toString();
        other_fine= data["other_fine"].toString();
        other_charges= data["other_charges"].toString();
        remarks_1= data["remarks_1"].toString();
        created_at= data["created_at"].toString();
        claim_stage= data["claim_stage"].toString();
        claim_amount= data["claim_amount"].toString();
        applicationFormDoc= data["appeal_form"].toString();
        resultCardDoc= data["result_card"].toString();
        feeVoucherDoc= data["fee_voucher"].toString();

        uiUpdates.DismissProgresssDialog();
        setState(() {
        });
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}
