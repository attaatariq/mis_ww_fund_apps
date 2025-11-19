import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/views/noting_item.dart';
import 'package:http/http.dart' as http;
import '../../../viewer/ImageViewer.dart';
import '../../../Strings/Strings.dart';
import '../../../colors/app_colors.dart';
import '../../../constants/Constants.dart';
import '../../../models/Note.dart';
import '../../../models/NoteModel.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../network/api_service.dart';
import '../../../utils/claim_stages_helper.dart';

class DeathClaimDetail extends StatefulWidget {
  String calim_ID = "";

  DeathClaimDetail(this.calim_ID);

  @override
  _DeathClaimDetailState createState() => _DeathClaimDetailState();
}

class _DeathClaimDetailState extends State<DeathClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  String eobiPension, affidavitNotClaimed, affidavitNotMarried, awards, deathCertificate, pensionBook, condonation;
  String created_at = "-",
      claim_stage = "-",
      claim_amount = "-",
      claim_dated = "-",
      eobiNo = "-",
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
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
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
                                child: user_image != "null" && user_image != "" && user_image != "NULL" && user_image != null ? FadeInImage(
                                  image: NetworkImage(constants.getImageBaseURL()+user_image),
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

                      // Detailed Status Card with dynamic color and info
                      ClaimStagesHelper.buildDetailStatusCard(claim_stage),
                      SizedBox(height: 16),

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
                                  Text("Claim Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_amount + " PKR",
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
                                  Text("Death Date",
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
                                  Text("EOBI",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(eobiNo,
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
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
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
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
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

                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+eobiPension)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: eobiPension != null && eobiPension != "" && eobiPension != "NULL" && eobiPension != "null" && eobiPension != "N/A" ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+eobiPension),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("EOBI Pension",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+affidavitNotClaimed)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: affidavitNotClaimed != null && affidavitNotClaimed != "" && affidavitNotClaimed != "NULL" && affidavitNotClaimed != "null" && affidavitNotClaimed != "N/A" ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+affidavitNotClaimed),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("Affidavit Not Claimed",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+affidavitNotMarried)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: affidavitNotMarried != null && affidavitNotMarried != "" && affidavitNotMarried != "NULL" && affidavitNotMarried != "null" && affidavitNotMarried != "N/A" ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+affidavitNotMarried),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("Affidavit Not Married",
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
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+awards)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: awards != null && awards != "" && awards != "NULL" && awards != "null" && awards != "N/A" ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+awards),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("Award",
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

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+deathCertificate)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: deathCertificate != null && deathCertificate != "" && deathCertificate != "NULL" && deathCertificate != "null" && deathCertificate != "N/A" ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+deathCertificate),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("Death Certificate",
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
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+pensionBook)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: pensionBook != null && pensionBook != "" && pensionBook != "NULL" && pensionBook != "null" && pensionBook != "N/A" ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+pensionBook),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("Pension Book",
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

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ImageViewer(constants.getImageBaseURL()+condonation)
                                    ));
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: condonation != null && condonation != "" && condonation != "NULL" && condonation != "null" && condonation != "N/A"  ? FadeInImage(
                                            image: NetworkImage(constants.getImageBaseURL()+condonation),
                                            placeholder: AssetImage("archive/images/no_image.jpg"),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ) : Image.asset("archive/images/no_image.jpg",
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
                                              child: Text("Condonation",
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
        GetDeathClaimsDetail();
      }
    });
  }

  void GetDeathClaimsDetail() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.buildApiUrl(
        constants.claims + "deceased_detail/", 
        UserSessions.instance.getUserID, 
        additionalPath: widget.calim_ID);
    var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders());
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
        eobiNo = body["emp_eobino"].toString();
        claim_amount = body["claim_amount"].toString();
        bank_name= body["emp_bank"].toString();
        account_number= body["emp_account"].toString();
        account_title= body["emp_title"].toString();
        eobiPension = body["emp_eobi_card"].toString();
        affidavitNotClaimed = body["claim_affidavit_1"].toString();
        affidavitNotMarried = body["claim_affidavit_2"].toString();
        awards = body["claim_award"].toString();
        deathCertificate = body["claim_certificate"].toString();
        pensionBook = body["claim_book"].toString();
        condonation = body["claim_condonation"].toString();
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
}
