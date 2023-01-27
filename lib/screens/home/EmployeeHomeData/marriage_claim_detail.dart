import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:welfare_claims_app/itemviews/noting_item.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/models/Note.dart';
import '../../../ImageViewer/ImageViewer.dart';
import '../../../Strings/Strings.dart';
import '../../../colors/app_colors.dart';
import '../../../constants/Constants.dart';
import '../../../models/NoteModel.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';
import 'package:intl/intl.dart';

class MarriageClaimDetail extends StatefulWidget {
  String calim_ID = "";

  MarriageClaimDetail(this.calim_ID);

  @override
  _MarriageClaimDetailState createState() => _MarriageClaimDetailState();
}

class _MarriageClaimDetailState extends State<MarriageClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  String serviceCertificate, affidavit, awards, nikahNama, accumulativeService;
  String created_at = "-",
      claim_stage = "-",
      claim_amount = "-",
      claim_dated = "-",
      claim_category = "-",
      daughter_name = "-",
      husband_name = "-",
      daughter_age = "-",
      bank_name = "-", account_title="-", account_number="-", user_image="-",
      user_name="-", user_cnic="-";
  bool isError = false;
  String errorMessage = "";
  List<Note> noteParahList = [];
  List<NoteModel> noteList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.arrow_back, color: AppTheme.colors.newWhite,
                          size: 20,),
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
                  margin: EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 50),
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
                                child: user_image != "null" &&
                                    user_image != "" &&
                                    user_image != "NULL" &&
                                    user_image != "-"
                                    ? FadeInImage(
                                  image: NetworkImage(
                                      constants.getImageBaseURL() +
                                          user_image),
                                  placeholder: AssetImage(
                                      "assets/images/no_image_placeholder.jpg"),
                                  fit: BoxFit.fill,
                                )
                                    : Image.asset(
                                  "assets/images/no_image_placeholder.jpg",
                                  height: 40.0,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),

                            SizedBox(width: 10,),

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        user_name,
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
                                        user_cnic,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors
                                                .colorDarkGray,
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
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10),
                            child: Text("Claim Information",
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
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
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

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Marriage Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_dated,
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
                                  Text("Claim Category",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_category,
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
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_amount,
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
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      claim_category != "Self" && claim_category != "-" ? Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10),
                            child: Text("Daughter Detail",
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
                      ) : Container(),

                      claim_category != "Self" && claim_category != "-" ? SizedBox(height: 10,) : Container(),

                      claim_category != "Self" && claim_category != "-" ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Daughter Name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(daughter_name,
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
                                  Text("Husband Name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(husband_name,
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
                      ) : Container(),

                      claim_category != "Self" && claim_category != "-" ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Daughter Age",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(daughter_age,
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
                          ],
                        ),
                      ) : Container(),

                      claim_category != "Self" && claim_category != "-" ? SizedBox(height: 20,) : Container(),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10),
                            child: Text("Bank Detail",
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
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Bank Name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(bank_name,
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
                                  Text("Account Title",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(account_title,
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
                            border: Border.all(width: 1,
                                color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Account Number",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(account_number,
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
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10),
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

                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ImageViewer(constants.getImageBaseURL()+serviceCertificate)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: serviceCertificate != null &&
                                              serviceCertificate != "" &&
                                              serviceCertificate != "NULL" &&
                                              serviceCertificate != "null" &&
                                              serviceCertificate != "N/A"
                                              ? FadeInImage(
                                            image: NetworkImage(
                                                constants.getImageBaseURL()+serviceCertificate),
                                            placeholder: AssetImage(
                                                "assets/images/no_image_placeholder.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          )
                                              : Image.asset(
                                            "assets/images/no_image_placeholder.jpg",
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
                                              color: AppTheme.colors.newBlack
                                                  .withAlpha(400),
                                            ),

                                            child: Center(
                                              child: Text("Service Certificate",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: AppTheme.colors
                                                        .newWhite,
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
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ImageViewer(constants.getImageBaseURL()+affidavit)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: affidavit != null &&
                                              affidavit != "" &&
                                              affidavit != "NULL" &&
                                              affidavit != "null" &&
                                              affidavit != "N/A"
                                              ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+affidavit),
                                            placeholder: AssetImage(
                                                "assets/images/no_image_placeholder.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          )
                                              : Image.asset(
                                            "assets/images/no_image_placeholder.jpg",
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
                                              color: AppTheme.colors.newBlack
                                                  .withAlpha(400),
                                            ),

                                            child: Center(
                                              child: Text("Affidavit",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: AppTheme.colors
                                                        .newWhite,
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

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ImageViewer(constants.getImageBaseURL()+awards)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: awards != null &&
                                              awards != "" &&
                                              awards != "NULL" &&
                                              awards != "null" &&
                                              awards != "N/A"
                                              ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+awards),
                                            placeholder: AssetImage(
                                                "assets/images/no_image_placeholder.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          )
                                              : Image.asset(
                                            "assets/images/no_image_placeholder.jpg",
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
                                              color: AppTheme.colors.newBlack
                                                  .withAlpha(400),
                                            ),

                                            child: Center(
                                              child: Text("Award",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors
                                                        .newWhite,
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
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ImageViewer(constants.getImageBaseURL()+nikahNama)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: nikahNama != null &&
                                              nikahNama != "" &&
                                              nikahNama != "NULL" &&
                                              nikahNama != "null" &&
                                              nikahNama != "N/A"
                                              ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+nikahNama),
                                            placeholder: AssetImage(
                                                "assets/images/no_image_placeholder.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          )
                                              : Image.asset(
                                            "assets/images/no_image_placeholder.jpg",
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
                                              color: AppTheme.colors.newBlack
                                                  .withAlpha(400),
                                            ),

                                            child: Center(
                                              child: Text("Nikah Nama",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors
                                                        .newWhite,
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

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ImageViewer(constants.getImageBaseURL()+accumulativeService)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: accumulativeService != null &&
                                              accumulativeService != "" &&
                                              accumulativeService != "NULL" &&
                                              accumulativeService != "null" &&
                                              accumulativeService != "N/A"
                                              ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+accumulativeService),
                                            placeholder: AssetImage(
                                                "assets/images/no_image_placeholder.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          )
                                              : Image.asset(
                                            "assets/images/no_image_placeholder.jpg",
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
                                              color: AppTheme.colors.newBlack
                                                  .withAlpha(400),
                                            ),

                                            child: Center(
                                              child: Text(
                                                "Accumulative Service",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors
                                                        .newWhite,
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

                      SizedBox(height: 20,),

                      noteList.isNotEmpty ? Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10),
                            child: Text("Notes",
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
                      ) : Container(),

                      SizedBox(height: 10,),

                      noteList.isNotEmpty ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        itemBuilder: (_, int index) =>
                            NotingItem(noteList[index], constants),
                        itemCount: noteList.length,
                      ) : Container()
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        GetMarriageClaimsDetail();
      }
    });
  }

  void GetMarriageClaimsDetail() async {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.claims +
        "marriage_detail/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken + "/" + widget.calim_ID;
    print(url);
    var response = await http.get(Uri.parse(url));
    uiUpdates.DismissProgresssDialog();
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
    if (responseCodeModel.status == true) {
      var bodyData = jsonDecode(response.body);
      String code = bodyData["Code"].toString();
      if (code == "1") {
        var body = bodyData["Data"];
        List<dynamic> noteListData = body["notings"];
        if (noteListData.isNotEmpty) {
          noteListData.forEach((element) {
            noteParahList.clear();
            List<dynamic> noteParaListData = element["note_paras"];
            if (noteParaListData.isNotEmpty) {
              noteParaListData.forEach((element1) {
                String para_no = element1["para_no"].toString();
                String remarks = element1["remarks"].toString();
                noteParahList.add(Note(para_no, remarks));
              });
            }
            String user_name_to = element["user_name_to"].toString();
            String role_name_to = element["role_name_to"].toString();
            String sector_name_to = element["sector_name_to"].toString();
            String user_name_by = element["user_name_by"].toString();
            String role_name_by = element["role_name_by"].toString();
            String sector_name_by = element["sector_name_by"].toString();
            String created_at = element["created_at"].toString();
            noteList.add(NoteModel(
                user_name_to,
                role_name_to,
                sector_name_to,
                user_name_by,
                role_name_by,
                sector_name_by,
                created_at,
                noteParahList));
          });
        }
        user_name= body["user_name"].toString();
        user_image= body["user_image"].toString();
        user_cnic= body["user_cnic"].toString();
        claim_stage = body["claim_stage"].toString();
        created_at = body["created_at"].toString();
        claim_dated = body["claim_dated"].toString();
        claim_category = body["claim_category"].toString();
        claim_amount = body["claim_amount"].toString();
        bank_name= body["emp_bank"].toString();
        account_number= body["emp_account"].toString();
        account_title= body["emp_title"].toString();
        serviceCertificate = body["claim_certificate"].toString();
        affidavit = body["claim_affidavit"].toString();
        awards = body["claim_award"].toString();
        nikahNama = body["claim_nikahnama"].toString();
        accumulativeService = body["claim_service"].toString();
        if (claim_category != "Self") {
          daughter_name = body["child_name"].toString();
          husband_name = body["claim_husband"].toString();
          daughter_age = GetDaughterAge(created_at, body["child_birthday"].toString()) ?? "-";
        }
        setState(() {
          isError = false;
        });
      } else {
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
        setState(() {
          isError = true;
          errorMessage = Strings.instance.notAvail;
        });
      }
    } else {
      var body = jsonDecode(response.body);
      String message = body["Message"].toString();
      if (message == constants.expireToken) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        uiUpdates.ShowToast(message);
      }
    }
  }

  String GetDaughterAge(String createdAt, String dob) {
    var createdDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(createdAt);
    var dobDate = new DateFormat("yyyy-MM-dd").parse(dob);
    var finalDOB = createdDate.year - dobDate.year;
    return finalDOB.toString();
  }
}