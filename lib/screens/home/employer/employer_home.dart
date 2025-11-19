import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/home/employer/create_person.dart';
import 'package:wwf_apps/screens/home/employer/stenotypist.dart';
import 'package:wwf_apps/screens/home/employer/contribution.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppTheme.colors.newPrimary,
          ),
        ),
        title: Text("Dashboard",
            style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.5
            )),

        iconTheme: IconThemeData(color: AppTheme.colors.newWhite),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  constants.LogoutUser(context);
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppTheme.colors.newWhite.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.power_settings_new,
                    color: AppTheme.colors.newWhite,
                    size: 16,
                  ),
                ),
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.colors.newPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.colors.newPrimary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.colors.newWhite.withOpacity(0.2),
                          border: Border.all(
                            color: AppTheme.colors.newWhite.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: companyLogo != "null" && 
                                 companyLogo != "" && 
                                 companyLogo != "NULL" && 
                                 companyLogo != "N/A" && 
                                 companyLogo != "null" 
                            ? FadeInImage(
                                image: NetworkImage(constants.getImageBaseURL() + companyLogo),
                                placeholder: AssetImage("archive/images/no_image.jpg"),
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "archive/images/no_image.jpg",
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                "archive/images/no_image.jpg",
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newWhite,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          companyName != "Unknown" ? companyName : "Company Name",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.colors.newPrimary,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              companyAddress != "Unknown" ? companyAddress : "Address Not Available",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.colors.newWhite.withOpacity(0.9),
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.colors.newPrimary,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.colors.newPrimary.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newWhite.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "archive/images/user.png",
                                        height: 24,
                                        width: 24,
                                        color: AppTheme.colors.newWhite,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Total Employees",
                                    style: TextStyle(
                                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    totalEmployee,
                                    style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 28,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newWhite.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildEmployeeStatItem(
                                          label: "Disabled",
                                          value: totalDisable,
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: AppTheme.colors.newWhite.withOpacity(0.3),
                                        ),
                                        SizedBox(height: 12),
                                        _buildEmployeeStatItem(
                                          label: "Availing Benefits",
                                          value: totalAvailingBenefits,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.colors.newPrimary,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.colors.newPrimary.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newWhite.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "archive/images/money.png",
                                        height: 24,
                                        width: 24,
                                        color: AppTheme.colors.newWhite,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Total Claims",
                                    style: TextStyle(
                                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    totalClaim,
                                    style: TextStyle(
                                      color: AppTheme.colors.newWhite,
                                      fontSize: 28,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newWhite.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildEmployeeStatItem(
                                          label: "Reimbursed",
                                          value: totalReimbursed,
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: AppTheme.colors.newWhite.withOpacity(0.3),
                                        ),
                                        SizedBox(height: 12),
                                        _buildEmployeeStatItem(
                                          label: "In Progress",
                                          value: totalInprogress,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: AppTheme.colors.newPrimary,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Reimbursed Amount",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 14,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            totalAmountReimbursed == "0" || totalAmountReimbursed.isEmpty
                                ? "0 PKR"
                                : constants.ConvertMappedNumber(totalAmountReimbursed) + " PKR",
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 28,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD10,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "archive/images/contibute.png",
                                height: 28,
                                width: 28,
                                color: AppTheme.colors.newWhite,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Total Contribution",
                                style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 15,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            totalAnnexesAmount == "0" || totalAnnexesAmount.isEmpty
                                ? "0 PKR"
                                : constants.ConvertMappedNumber(totalAnnexesAmount) + " PKR",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 24,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.colorD11,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        annexureAAmount == "0" || annexureAAmount.isEmpty
                                            ? "0 PKR"
                                            : constants.ConvertMappedNumber(annexureAAmount) + " PKR",
                                        style: TextStyle(
                                          color: AppTheme.colors.newWhite,
                                          fontSize: 13,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Annexure-III",
                                        style: TextStyle(
                                          color: AppTheme.colors.newWhite.withOpacity(0.9),
                                          fontSize: 11,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.colorD11,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        annexure3AAmount == "0" || annexure3AAmount.isEmpty
                                            ? "0 PKR"
                                            : constants.ConvertMappedNumber(annexure3AAmount) + " PKR",
                                        style: TextStyle(
                                          color: AppTheme.colors.newWhite,
                                          fontSize: 13,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Annexure-III (A)",
                                        style: TextStyle(
                                          color: AppTheme.colors.newWhite.withOpacity(0.9),
                                          fontSize: 11,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD20,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.colors.colorD10,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: AppTheme.colors.newWhite,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Notice Board",
                                  style: TextStyle(
                                    color: AppTheme.colors.newWhite,
                                    fontSize: 15,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildNoticeItem(note1),
                                SizedBox(height: 20),
                                _buildNoticeItem(note2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD13,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colors.colorD13.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildClaimCard(
                              title: "Estate Claim",
                              subtitle: "Delivered",
                              amount: estateClaimAmount,
                              icon: Icons.home_work,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 70,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            color: AppTheme.colors.newWhite.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildClaimCard(
                              title: "Hajj Claim",
                              subtitle: "Delivered",
                              amount: hajjClaimAmount,
                              icon: Icons.mosque,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD14,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colors.colorD14.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newWhite.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Image.asset(
                                "archive/images/death.png",
                                height: 28,
                                width: 28,
                                color: AppTheme.colors.newWhite,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Death Claim",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 16,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            deathClaimsTotalAmount == "0" || deathClaimsTotalAmount.isEmpty
                                ? "0 PKR"
                                : constants.ConvertMappedNumber(deathClaimsTotalAmount) + " PKR",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 24,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatusCard(
                                  label: "Delivered",
                                  amount: deathClaimsDeliveredAmount,
                                  color: AppTheme.colors.colorD18,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildStatusCard(
                                  label: "In Progress",
                                  amount: deathClaimsInprogressAmount,
                                  color: AppTheme.colors.colorD18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD15,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colors.colorD15.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newWhite.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Image.asset(
                                "archive/images/merriage.png",
                                height: 28,
                                width: 28,
                                color: AppTheme.colors.newWhite,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Marriage Claims",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 16,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            marriageClaimsTotalAmount == "0" || marriageClaimsTotalAmount.isEmpty
                                ? "0 PKR"
                                : constants.ConvertMappedNumber(marriageClaimsTotalAmount) + " PKR",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 24,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatusCard(
                                  label: "Delivered",
                                  amount: marriageClaimDeliveredAmount,
                                  color: AppTheme.colors.colorD19,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildStatusCard(
                                  label: "In Progress",
                                  amount: marriageClaimsInprogressAmount,
                                  color: AppTheme.colors.colorD19,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorD17,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colors.colorD17.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school,
                                color: AppTheme.colors.newWhite,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Education Claim",
                                style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 18,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        educationClaimsTotalAmount == "0" || educationClaimsTotalAmount.isEmpty
                                            ? "0 PKR"
                                            : constants.ConvertMappedNumber(educationClaimsTotalAmount) + " PKR",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.colors.newPrimary,
                                          fontSize: 18,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        width: 100,
                                        height: 2,
                                        color: AppTheme.colors.newPrimary,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Total Amount",
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
                                Container(
                                  width: 1,
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  color: AppTheme.colors.colorLightGray,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.colorLightGray,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        totalEducationClaims,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.colors.newPrimary,
                                          fontSize: 18,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "Count",
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
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildEducationSubCard(
                                  title: "Fee Claims",
                                  count: feeClaims,
                                  amount: feeClaimAmount,
                                  icon: Icons.receipt,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildEducationSubCard(
                                  title: "School Basics",
                                  count: schoolBasics,
                                  amount: schoolBasicsAmount,
                                  icon: Icons.book,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildEducationSubCard(
                                  title: "Transport",
                                  count: "0",
                                  amount: transportClaimsAmount,
                                  icon: Icons.directions_bus,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildEducationSubCard(
                                  title: "Residence",
                                  count: "0",
                                  amount: residenceClaimAmount,
                                  icon: Icons.home,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newPrimary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colors.newPrimary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: _buildFeedbackStat(
                              icon: Icons.report_problem,
                              label: "Complaints",
                              value: complaints,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppTheme.colors.newWhite.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildFeedbackStat(
                              icon: Icons.feedback,
                              label: "Feedback",
                              value: feedback,
                            ),
                          ),
                        ],
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

  // Helper function to safely parse JSON values
  String _safeParseValue(dynamic value, {String defaultValue = "0"}) {
    if (value == null) return defaultValue;
    String strValue = value.toString().trim();
    if (strValue.isEmpty || 
        strValue.toLowerCase() == "null" || 
        strValue == "N/A" ||
        strValue == "undefined") {
      return defaultValue;
    }
    return strValue;
  }

  // Helper function to format count values (shows "0" for zero, handles null)
  String _formatCount(dynamic value) {
    String parsed = _safeParseValue(value, defaultValue: "0");
    try {
      int count = int.parse(parsed);
      return count.toString();
    } catch (e) {
      return "0";
    }
  }

  // Helper function to format amount values (shows "0" for zero, handles null)
  String _formatAmount(dynamic value) {
    String parsed = _safeParseValue(value, defaultValue: "0");
    try {
      double amount = double.parse(parsed);
      if (amount == 0) return "0";
      return parsed;
    } catch (e) {
      return "0";
    }
  }

  // Helper function to format notice text (shows "Not Available" for null/empty)
  String _formatNotice(dynamic value) {
    if (value == null) return "Not Available";
    String strValue = value.toString().trim();
    if (strValue.isEmpty || 
        strValue.toLowerCase() == "null" || 
        strValue == "N/A" ||
        strValue == "undefined" ||
        strValue == "NULL") {
      return "Not Available";
    }
    return strValue;
  }

  // Helper function to format company information
  String _formatCompanyInfo(dynamic value, {String defaultValue = "Unknown"}) {
    if (value == null) return defaultValue;
    String strValue = value.toString().trim();
    if (strValue.isEmpty || 
        strValue.toLowerCase() == "null" || 
        strValue == "N/A" ||
        strValue == "undefined" ||
        strValue == "NULL") {
      return defaultValue;
    }
    return strValue;
  }

  GetDashBoardData() async{
    var url = constants.getApiBaseURL()+constants.homescreen+"/"+constants.homeCompanies+"/"+UserSessions.instance.getUserID+"/"
        +UserSessions.instance.getRefID;
    var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var noteObject= data["notice"] ?? {};
        var countObject= data["counts"] ?? {};
        var amountObject= data["amount"] ?? {};
        var feedsObject= data["feeds"] ?? {};
        var information= data["extra"] != null && data["extra"]["company"] != null 
            ? data["extra"]["company"] 
            : {};
        
        // Parse company information with null safety
        companyName= _formatCompanyInfo(information["comp_name"], defaultValue: "Unknown");
        companyAddress= _formatCompanyInfo(information["comp_address"], defaultValue: "Unknown");
        companyLogo= _formatCompanyInfo(information["comp_logo"], defaultValue: "null");
        
        // Parse counts with null safety
        totalEmployee= _formatCount(countObject["workers"]);
        totalDisable= _formatCount(countObject["special"]);
        totalAvailingBenefits= _formatCount(countObject["availing"]);
        totalClaim= _formatCount(countObject["overall"]);
        totalReimbursed= _formatCount(countObject["completed"]);
        totalInprogress= _formatCount(countObject["pending"]);
        estateClaimCount= _formatCount(countObject["estate"]);
        hajjClaims= _formatCount(countObject["hajj"]);
        totalEducationClaims= _formatCount(countObject["education"]);
        feeClaims= _formatCount(countObject["edu_fee"]);
        
        // Parse amounts with null safety
        totalAmountReimbursed= _formatAmount(amountObject["benefits"]);
        annexureAAmount= _formatAmount(amountObject["annexure_1"]);
        annexure3AAmount= _formatAmount(amountObject["annexure_2"]);
        totalAnnexesAmount= _formatAmount(amountObject["contribution"]);
        estateClaimAmount= _formatAmount(amountObject["estate"]);
        hajjClaimAmount= _formatAmount(amountObject["hajj"]);
        deathClaimsTotalAmount= _formatAmount(amountObject["death"]);
        deathClaimsDeliveredAmount= _formatAmount(amountObject["dth_done"]);
        deathClaimsInprogressAmount= _formatAmount(amountObject["dth_remaining"]);
        marriageClaimsTotalAmount= _formatAmount(amountObject["merriage"]);
        marriageClaimDeliveredAmount= _formatAmount(amountObject["mrg_done"]);
        marriageClaimsInprogressAmount= _formatAmount(amountObject["mrg_remaining"]);
        educationClaimsTotalAmount= _formatAmount(amountObject["education"]);
        feeClaimAmount= _formatAmount(amountObject["edu_fee"]);
        schoolBasicsAmount= _formatAmount(amountObject["school_basics"]);
        transportClaimsAmount= _formatAmount(amountObject["transport"]);
        
        // Parse notices with null safety
        note1= _formatNotice(noteObject["notice_1"]);
        note2= _formatNotice(noteObject["notice_2"]);
        
        // Parse feeds with null safety
        complaints= _formatCount(feedsObject["complaints"]);
        feedback= _formatCount(feedsObject["feedbacks"]);
        
        // Set defaults for missing data
        schoolBasics= "0";
        residenceClaimAmount= "0";
        
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
      SaveNotificationToken(token)
    });
  }

  void SaveNotificationToken(String notificationToken) async{
    var url = constants.getApiBaseURL()+constants.authentication+"gadget";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['gadget_id'] = notificationToken;
    APIService.addAuthHeaderToMultipartRequest(request);
    var response = await request.send();
    try {
      final resp = await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
        } else {
        }
      } else {
        var body = jsonDecode(resp.body);
        if(!(body["Message"].toString().contains('Your request has same device ID'))){
          String message = body["Message"].toString();
          uiUpdates.ShowToast(message);
        }
      }
    }catch(e){
      uiUpdates.ShowToast(e);
    }
  }

  // Helper widget for employee stat items
  Widget _buildEmployeeStatItem({String label, String value}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.colors.newPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: AppTheme.colors.newWhite,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.colors.newWhite,
              fontSize: 11,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for notice items
  Widget _buildNoticeItem(String notice) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorD10.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.colors.newWhite.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.colors.newWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.push_pin,
              color: AppTheme.colors.newWhite,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              notice,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for claim cards
  Widget _buildClaimCard({String title, String subtitle, String amount, IconData icon}) {
    final formattedAmount = amount == "0" || amount.isEmpty 
        ? "0 PKR" 
        : constants.ConvertMappedNumber(amount) + " PKR";
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.colors.newWhite,
            size: 22,
          ),
        ),
        SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.colors.newWhite,
            fontSize: 13,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: AppTheme.colors.newWhite.withOpacity(0.9),
            fontSize: 11,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          formattedAmount,
          style: TextStyle(
            color: AppTheme.colors.newWhite,
            fontSize: 14,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // Helper widget for status cards (Delivered/In Progress)
  Widget _buildStatusCard({String label, String amount, Color color}) {
    final formattedAmount = amount == "0" || amount.isEmpty 
        ? "0 PKR" 
        : constants.ConvertMappedNumber(amount) + " PKR";
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.colors.newWhite,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            formattedAmount,
            style: TextStyle(
              color: AppTheme.colors.newWhite,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for feedback/complaints stats
  Widget _buildFeedbackStat({IconData icon, String label, String value}) {
    final displayValue = value == "0" || value.isEmpty ? "0" : value;
    
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.colors.newWhite,
          size: 24,
        ),
        SizedBox(height: 8),
        Text(
          displayValue,
          style: TextStyle(
            color: AppTheme.colors.newWhite,
            fontSize: 20,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.colors.newWhite.withOpacity(0.9),
            fontSize: 12,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper widget for education sub-cards
  Widget _buildEducationSubCard({String title, String count, String amount, IconData icon}) {
    final displayCount = count == "0" || count.isEmpty ? "0" : count;
    final formattedAmount = amount == "0" || amount.isEmpty 
        ? "0 PKR" 
        : constants.ConvertMappedNumber(amount) + " PKR";
    
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.colors.colorLightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.colors.newPrimary,
            size: 20,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.colors.newPrimary,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "($displayCount)",
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 10,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            formattedAmount,
            style: TextStyle(
              color: AppTheme.colors.newPrimary,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
