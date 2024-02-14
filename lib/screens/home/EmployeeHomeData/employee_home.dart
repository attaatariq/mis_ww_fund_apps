import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/InformationSelection.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/death_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/drawer/drawer_view.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/marriage_claim.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EmployeeHome extends StatefulWidget {
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  Constants constants;
  UIUpdates uiUpdates;
  String totalClaim="0", reimbursed_claims= "0", inprogress_claims= "0", benefits_amount= "0",
      notice_1= "Not Available", notice_2= "Not Available", estate_claim_delivered= "0", hajj_claim_delivered= "0",
      total_death_amount= "0", death_amount_delivered = "0", death_amount_inprogress= "0", total_marriage_amount= "0",
      marriage_amount_delivered= "0", marriage_amount_inprogress= "0", education_claims_count= "0", total_edu_claim_amount= "0",
      fee_claims= "0", school_basics= "0", transport_amount= "0", residence_amount= "0", complaints= "0", feedbacks= "0",
      total_school_basics ="0", total_transport_claim= "0", total_residence_claim= "0", total_fee_claims= "0";

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
            child: EmployeeDrawerView()
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
                    color: AppTheme.colors.newPrimary,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                ),

                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logo.png",
                          height: 40.0,
                          width: 40,
                          color: AppTheme.colors.newWhite,
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newWhite,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
                            child: Text(UserSessions.instance.getUserName,
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
                          child: Text(UserSessions.instance.getUserEmail,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Text(UserSessions.instance.getUserCNIC,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
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
                                                  child: Text(reimbursed_claims,
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
                                                  child: Text(inprogress_claims,
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
                                    Text(constants.ConvertMappedNumber(benefits_amount) + " PKR",
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

                                    Text("Total Benefits Received",
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
                                    child: Text(notice_1,
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
                                    child: Text(notice_2,
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
                                            child: Text(constants.ConvertMappedNumber(estate_claim_delivered)+" PKR",
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
                                              child: Text(constants.ConvertMappedNumber(hajj_claim_delivered)+" PKR",
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
                                  child: Text(constants.ConvertMappedNumber(total_death_amount) +" PKR",
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
                                                child: Text(constants.ConvertMappedNumber(death_amount_delivered)+" PKR",
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
                                                  child: Text(constants.ConvertMappedNumber(death_amount_inprogress)+" PKR",
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
                                  child: Text(constants.ConvertMappedNumber(total_marriage_amount)+" PKR",
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
                                                child: Text(constants.ConvertMappedNumber(marriage_amount_delivered)+" PKR",
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
                                                  child: Text(constants.ConvertMappedNumber(marriage_amount_inprogress)+" PKR",
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
                                            Text(constants.ConvertMappedNumber(total_edu_claim_amount)+" PKR",
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(education_claims_count,
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

                                              Text("("+total_fee_claims+")",
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
                                                child: Text(constants.ConvertMappedNumber(fee_claims)+" PKR",
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

                                                Text("("+total_school_basics+")",
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
                                                  child: Text(constants.ConvertMappedNumber(school_basics)+" PKR",
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

                                              Text("("+total_transport_claim+")",
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
                                                child: Text(constants.ConvertMappedNumber(transport_amount)+" PKR",
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

                                                Text("("+total_residence_claim+")",
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
                                                  child: Text(constants.ConvertMappedNumber(residence_amount)+" PKR",
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
                            child: Text("Total complaints submitted are "+complaints+" and "+feedbacks+" feedback sent.",
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

  GetDashBoardData() async{
    //uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.homescreen+"/"+constants.homeEmployees+"/"+UserSessions.instance.getUserID+"/"
        +UserSessions.instance.getToken+"/"+UserSessions.instance.getUserID;
    var response = await http.get(Uri.parse(url));
    print('url:$url :response:${response.body}:${response.statusCode}');
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
        totalClaim= countObject["overall"].toString();
        reimbursed_claims= countObject["completed"].toString();
        inprogress_claims= countObject["pending"].toString();
        benefits_amount= amountObject["benefits"].toString();
        notice_1= noteObject["notice_1"].toString();
        notice_2= noteObject["notice_2"].toString();
        estate_claim_delivered= amountObject["estate"].toString();
        hajj_claim_delivered= amountObject["hajj"].toString();
        total_death_amount= amountObject["death"].toString();
        death_amount_delivered= amountObject["dth_done"].toString();
        death_amount_inprogress= amountObject["dth_remaining"].toString();
        total_marriage_amount= amountObject["merriage"].toString();
        marriage_amount_delivered= amountObject["mrg_done"].toString();
        marriage_amount_inprogress= amountObject["mrg_remaining"].toString();
        education_claims_count= countObject["education"].toString();
        total_edu_claim_amount= amountObject["education"].toString();
        fee_claims= amountObject["edu_fee"].toString();
        school_basics= amountObject["school_basics"].toString();
        transport_amount= amountObject["transport"].toString();
        residence_amount= "0";
        complaints= feedsObject["complaints"].toString();
        feedbacks= feedsObject["feedbacks"].toString();
        total_school_basics= "0";
        total_transport_claim= "0";
        total_residence_claim= "0";
        total_fee_claims= countObject["edu_fee"].toString();
        setState(() {});
      }
    } else {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        ///check new updated version
        constants.CheckForNewUpdate(context);
        GetTokenAndSave();
        if(constants.CheckDataNullSafety(UserSessions.instance.getRefID)) {
          GetDashBoardData();
        }
      }
    });
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
    print('its calling');
    var url = constants.getApiBaseURL()+constants.authentication+"gadget";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['user_token'] = UserSessions.instance.getToken;
    request.fields['gadget_id'] = notificationToken;
    var response = await request.send();
    try {
      final resp = await http.Response.fromStream(response);
      print('$url :response:${resp.statusCode}:${resp.body}');
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
        if(!(body["Message"].toString().contains('Your request has same device ID'))){
          String message = body["Message"].toString();
          uiUpdates.ShowToast(message);
        }
      }
    }catch(e){
      print('here');
      uiUpdates.ShowToast(e);
    }
  }
}
