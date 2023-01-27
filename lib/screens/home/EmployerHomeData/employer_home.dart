import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/AddContactPerson.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/AddDEO.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/contribution.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

import 'drawer/drawer_view.dart';

class EmployerHome extends StatefulWidget {
  @override
  _EmployerHomeState createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {

  Constants constants;
  UIUpdates uiUpdates;
  String companyName="Unknown", companyAddress="Unknown", companyLogo="null";
  String totalEmployee="0", totalDisable="0", totalAvailingBenefits="0", totalClaim="0", totalReimbursed="0", totalInprogress="0", totalAmountReimbursed="0",
      annexureAAmount="0", annexure3AAmount="0", totalAnnexesAmount="0", estateClaimCount="0", estateClaimAmount="0", hajjClaims="0", hajjClaimAmount="0",
      deathClaimsTotalAmount="0", deathClaimsDeliveredAmount="0", deathClaimsInprogressAmount="0", marriageClaimsTotalAmount="0", marriageClaimDeliveredAmount="0",
      marriageClaimsInprogressAmount="0", totalEducationClaims="0", educationClaimsTotalAmount="0", feeClaims="0", schoolBasics="0", feeClaimAmount="0", schoolBasicsAmount="0",
      transportClaimsAmount="0", residenceClaimAmount="0", note1="Not Available", note2= "Not Available", complaints="0", feedback="0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    ///check new updated version
    constants.CheckForNewUpdate(context);
    GetDashBoardData();
    GetTokenAndSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.colors.newPrimary,
        brightness: Brightness.dark,
        title: Text("Home",
            style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal
            )),

        iconTheme: IconThemeData(color: AppTheme.colors.newWhite),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: (){
                constants.LogoutUser(context);
              },
              child: Icon(
                Icons.power_settings_new,
                color: AppTheme.colors.newWhite,
              ),
            ),
          ),
        ],
      ),

      drawer: Container(
          width: MediaQuery.of(context).size.width * 0.78,
        child: Drawer(
            child: EmployerDrawerView()
        ),
      ),

      body: Container(
        child: Column(
          children: [
            Material(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              elevation: 10,
              shadowColor: AppTheme.colors.colorLightGray,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.colors.newPrimary,
                        AppTheme.colors.colorD4,
                      ],
                    )
                ),

                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: companyLogo != "null" && companyLogo != "" && companyLogo != "NULL" && companyLogo != "N/A" ? FadeInImage(
                                  image: NetworkImage(constants.getImageBaseURL()+companyLogo),
                                  placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                  fit: BoxFit.fill,
                                ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                  height: 40.0,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: AppTheme.colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
                                child: Text(companyName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newPrimary,
                                      fontSize: 14,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25),
                              child: Text(companyAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.white,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(0), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    AppTheme.colors.newPrimary,
                                    AppTheme.colors.colorD4,
                                  ],
                                )
                            ),

                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/employee.png",
                                          height: 30.0,
                                          width: 30,
                                          color: AppTheme.colors.white,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                                          child: Text("EMPLOYEES",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.white,
                                                fontSize: 12,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 5,),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                                          child: Text(totalEmployee,
                                            style: TextStyle(
                                                color: AppTheme.colors.white,
                                                fontSize: 22,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newWhite.withAlpha(800),
                                      //borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.colors.newPrimary,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(totalDisable,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppTheme.colors.white,
                                                          fontSize: 8,
                                                          fontFamily: "AppFont",
                                                          fontWeight: FontWeight.normal
                                                      ),
                                              ),
                                                )),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 10.0),
                                                child: Text("Disable",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.colors.white,
                                                      fontSize: 10,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 5,),

                                          Row(
                                            children: [
                                              Container(
                                                width: 45,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.colors.newPrimary,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(totalAvailingBenefits,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppTheme.colors.white,
                                                          fontSize: 8,
                                                          fontFamily: "AppFont",
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  )),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 10.0),
                                                child: Text("Availing",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.colors.white,
                                                      fontSize: 10,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(20), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppTheme.colors.newPrimary,
                                      AppTheme.colors.colorD4,
                                    ],
                                  )
                              ),

                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/images/money.png",
                                            height: 25.0,
                                            width: 25,
                                            color: AppTheme.colors.white,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                                            child: Text("TOTAL CLAIMS",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.white,
                                                  fontSize: 12,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 5,),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                                            child: Text(totalClaim,
                                              style: TextStyle(
                                                  color: AppTheme.colors.white,
                                                  fontSize: 22,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: AppTheme.colors.newWhite.withAlpha(800),
                                        //borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.colors.newPrimary,
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Text(totalReimbursed,
                                                        maxLines: 1,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme.colors.white,
                                                            fontSize: 8,
                                                            fontFamily: "AppFont",
                                                            fontWeight: FontWeight.normal
                                                        ),
                                                      ),
                                                    )),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text("Reimbursed",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppTheme.colors.white,
                                                        fontSize: 10,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 5,),

                                            Row(
                                              children: [
                                                Container(
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.colors.newPrimary,
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Text(totalInprogress,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme.colors.white,
                                                            fontSize: 8,
                                                            fontFamily: "AppFont",
                                                            fontWeight: FontWeight.normal
                                                        ),
                                                      ),
                                                    )),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text("In Progress",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppTheme.colors.white,
                                                        fontSize: 10,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newWhite,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(constants.ConvertMappedNumber(totalAmountReimbursed)+" PKR",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 22,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    width: 100,
                                    height: 2,
                                    color: AppTheme.colors.colorDarkGray,
                                  ),

                                  SizedBox(height: 8,),

                                  Text("Reimbursed Amount",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.colorDarkGray,
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
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD10,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Image.asset("assets/images/contibute_icon.png",
                                  height: 30.0,
                                  width: 30,
                                  color: AppTheme.colors.white,
                                ),

                                SizedBox(height: 10,),

                                Text("Total Contribution",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),

                                SizedBox(height: 8,),

                                Text(constants.ConvertMappedNumber(totalAnnexesAmount)+" PKR",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 18,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 45,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.colorD11
                                    //border: Border.all(color: AppTheme.colors.newWhite, width: 2),
                                  ),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(constants.ConvertMappedNumber(annexureAAmount)+" PKR",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      Text("Annexure-III",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
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
                                  margin: EdgeInsets.only(left: 5),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: AppTheme.colors.colorD11
                                    //border: Border.all(color: AppTheme.colors.newWhite, width: 2),
                                  ),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(constants.ConvertMappedNumber(annexure3AAmount)+" PKR",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      Text("Annexure-III (A)",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
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
                        ],
                      ),
                        ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorD20,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.colors.colorD10,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5))
                              ),
                              height: 40,
                              child: Center(
                                child: Text("Notice Board",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Column(
                              children: [
                                Image.asset("assets/images/pin.png",
                                  height: 25.0,
                                  width: 25,
                                  color: AppTheme.colors.newWhite,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                                  child: Text(
                                    note1 != "" && note1 != "null" && note1 != "N/A" && note1 != "NULL" ? note1 : "Not Available",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Column(
                              children: [
                                Image.asset("assets/images/pin.png",
                                  height: 25.0,
                                  width: 25,
                                  color: AppTheme.colors.newWhite,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 20),
                                  child: Text(
                                    note2 != "" && note2 != "null" && note2 != "N/A" && note2 != "NULL" ? note2 : "Not Available",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorD13,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Estate Claim",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      Text("Delivered",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
                                            fontSize: 10,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(constants.ConvertMappedNumber(estateClaimAmount)+" PKR",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.colors.newWhite,
                                              fontSize: 12,
                                              fontFamily: "AppFont",
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: 1,
                              height: 50,
                              color: AppTheme.colors.newWhite,
                            ),

                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Hajj Claim",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.colors.newWhite,
                                              fontSize: 12,
                                              fontFamily: "AppFont",
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        Text("Delivered",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.colors.newWhite,
                                              fontSize: 10,
                                              fontFamily: "AppFont",
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(constants.ConvertMappedNumber(hajjClaimAmount)+" PKR",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 12,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                          decoration: BoxDecoration(
                              color: AppTheme.colors.colorD14,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.newWhite,
                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Center(
                                  child: Image.asset("assets/images/death.png",
                                    height: 15.0,
                                    width: 15,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Text("Death Claim",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(constants.ConvertMappedNumber(deathClaimsTotalAmount)+" PKR",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 18,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: AppTheme.colors.colorD18,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, top: 7, bottom: 7),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Delivered",
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newWhite,
                                                  fontSize: 12,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: Text(constants.ConvertMappedNumber(deathClaimsDeliveredAmount)+" PKR",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: AppTheme.colors.colorD18,
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5, top: 7, bottom: 7),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("In Progress",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: Text(constants.ConvertMappedNumber(deathClaimsInprogressAmount)+" PKR",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.colors.newWhite,
                                                      fontSize: 12,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                          decoration: BoxDecoration(
                              color: AppTheme.colors.colorD15,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.newWhite,
                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Center(
                                  child: Image.asset("assets/images/merriage.png",
                                    height: 15.0,
                                    width: 15,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Text("Marriage Claims",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(constants.ConvertMappedNumber(marriageClaimsTotalAmount)+" PKR",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 18,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.colors.colorD19,
                                      ),
                                      margin: EdgeInsets.only(right: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, top: 7, bottom: 7),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Delivered",
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newWhite,
                                                  fontSize: 12,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: Text(constants.ConvertMappedNumber(marriageClaimDeliveredAmount)+" PKR",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.colors.colorD19,
                                      ),
                                      margin: EdgeInsets.only(left: 5),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0, top: 7, bottom: 7),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("In Progress",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: Text(constants.ConvertMappedNumber(marriageClaimsInprogressAmount)+" PKR",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.colors.newWhite,
                                                      fontSize: 12,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Container(
                          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                          decoration: BoxDecoration(
                              color: AppTheme.colors.colorD17,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text("Education Claim",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.colorD22,
                                ),

                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(constants.ConvertMappedNumber(educationClaimsTotalAmount)+" PKR",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 18,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            width: 100,
                                            height: 2,
                                            color: AppTheme.colors.newWhite,
                                          ),

                                          SizedBox(height: 8,),

                                          Text("Total Amount",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 12,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.colors.colorD21,
                                      ),

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(totalEducationClaims,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 18,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),

                                          Text("Count",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
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

                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Fee Claims",
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newWhite,
                                                  fontSize: 12,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                            Text("("+feeClaims+")",
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newWhite,
                                                  fontSize: 10,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Text(constants.ConvertMappedNumber(feeClaimAmount)+" PKR",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 1,
                                    height: 50,
                                    color: AppTheme.colors.newWhite,
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("School Basics",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                              Text("("+schoolBasics+")",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 10,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: Text(constants.ConvertMappedNumber(schoolBasicsAmount)+" PKR",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.colors.newWhite,
                                                      fontSize: 12,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                height: 1,
                                width: double.infinity,
                                color: AppTheme.colors.newWhite,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Transport",
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newWhite,
                                                  fontSize: 12,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                            Text("(0)",
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newWhite,
                                                  fontSize: 10,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Text(constants.ConvertMappedNumber(transportClaimsAmount)+" PKR",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 1,
                                    height: 50,
                                    color: AppTheme.colors.newWhite,
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Residence",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 12,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                              Text("(0)",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.colors.newWhite,
                                                    fontSize: 10,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: Text(constants.ConvertMappedNumber(residenceClaimAmount)+" PKR",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.colors.newWhite,
                                                      fontSize: 12,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 60),
                      child: Container(
                          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                        ),
                          child: Center(
                            child: Text("Total complaints submitted are "+ complaints +" and "+ feedback +" feedback sent.",
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void OpenContributionSelection() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Contribution()
    ));
  }

  GetDashBoardData() async{
    var url = constants.getApiBaseURL()+constants.homescreen+"/"+constants.homeCompanies+"/"+UserSessions.instance.getRefID+"/"
        +UserSessions.instance.getUserID+"/"+UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var noteObject= data["notice"];
        var countObject= data["counts"];
        var amountObject= data["amount"];
        var feedsObject= data["feeds"];
        var information= data["extra"]["company"];
        companyName= information["comp_name"].toString();
        companyAddress= information["comp_address"].toString();
        companyLogo= information["comp_logo"].toString();
        totalEmployee= countObject["workers"].toString();
        totalDisable= countObject["special"].toString();
        totalAvailingBenefits= countObject["availing"].toString();
        totalClaim= countObject["overall"].toString();
        totalReimbursed= countObject["completed"].toString();
        totalInprogress= countObject["pending"].toString();
        totalAmountReimbursed= amountObject["benefits"].toString();
        annexureAAmount= amountObject["annexure_1"].toString();
        annexure3AAmount= amountObject["annexure_2"].toString();
        totalAnnexesAmount= amountObject["contribution"].toString();
        estateClaimCount= countObject["estate"].toString();
        estateClaimAmount= amountObject["estate"].toString();
        hajjClaims= countObject["hajj"].toString();
        hajjClaimAmount= amountObject["hajj"].toString();
        deathClaimsTotalAmount= amountObject["death"].toString();
        deathClaimsDeliveredAmount= amountObject["dth_done"].toString();
        deathClaimsInprogressAmount= amountObject["dth_remaining"].toString();
        marriageClaimsTotalAmount= amountObject["merriage"].toString();
        marriageClaimDeliveredAmount= amountObject["mrg_done"].toString();
        marriageClaimsInprogressAmount= amountObject["mrg_remaining"].toString();
        totalEducationClaims= countObject["education"].toString();
        educationClaimsTotalAmount= amountObject["education"].toString();
        feeClaims= countObject["edu_fee"].toString();
        schoolBasics= "0";
        feeClaimAmount= amountObject["edu_fee"].toString();
        schoolBasicsAmount= amountObject["school_basics"].toString();
        transportClaimsAmount= amountObject["transport"].toString();
        residenceClaimAmount= "0";
        complaints= feedsObject["complaints"].toString();
        feedback= feedsObject["feedbacks"].toString();
        note1= noteObject["notice_1"].toString();
        note2= noteObject["notice_2"].toString();
        setState(() {});
      }
    } else {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void GetTokenAndSave() async{
    ///get fcm token
    FirebaseMessaging _firebaseMessaging = await FirebaseMessaging.instance;
    if (Platform.isAndroid) {
      GetToken();
    }else if (Platform.isIOS) {
      GetToken();
    }
  }

  void GetToken() async{
    await FirebaseMessaging.instance.getToken().then((token) => {
      print(token),
      SaveNotificationToken(token)
    });
  }

  void SaveNotificationToken(String notificationToken) async{
    var url = constants.getApiBaseURL()+constants.authentication+"gadget";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['user_token'] = UserSessions.instance.getToken;
    request.fields['gadget_id'] = notificationToken;
    var response = await request.send();
    try {
      final resp = await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          print("Success Token");
        } else {
          print("Failed Token");
        }
      } else {
        var body = jsonDecode(resp.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    }catch(e){
      uiUpdates.ShowToast(e);
    }
  }
}
