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
            child: EmployeeDrawerView()
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
                        child: Center(
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: 30,
                            width: 30,
                            color: AppTheme.colors.newWhite,
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
                          UserSessions.instance.getUserName,
                          textAlign: TextAlign.center,
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
                            Icons.email_outlined,
                            size: 12,
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              UserSessions.instance.getUserEmail,
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
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 12,
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              UserSessions.instance.getUserCNIC,
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.colors.newPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.colors.newPrimary.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Claims",
                                        style: TextStyle(
                                          color: AppTheme.colors.white.withOpacity(0.9),
                                          fontSize: 13,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        totalClaim,
                                        style: TextStyle(
                                          color: AppTheme.colors.white,
                                          fontSize: 32,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/money.png",
                                        height: 28,
                                        width: 28,
                                        color: AppTheme.colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        label: "Reimbursed",
                                        value: reimbursed_claims,
                                        color: AppTheme.colors.white,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 30,
                                      color: AppTheme.colors.white.withOpacity(0.3),
                                    ),
                                    Expanded(
                                      child: _buildStatItem(
                                        label: "In Progress",
                                        value: inprogress_claims,
                                        color: AppTheme.colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                  "Total Benefits Received",
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
                              constants.ConvertMappedNumber(benefits_amount) + " PKR",
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
                                  _buildNoticeItem(notice_1),
                                  SizedBox(height: 20),
                                  _buildNoticeItem(notice_2),
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
                                amount: estate_claim_delivered,
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
                                amount: hajj_claim_delivered,
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
                                  "assets/images/death.png",
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
                              total_death_amount == "0" || total_death_amount.isEmpty
                                  ? "0 PKR"
                                  : constants.ConvertMappedNumber(total_death_amount) + " PKR",
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
                                    amount: death_amount_delivered,
                                    color: AppTheme.colors.colorD18,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatusCard(
                                    label: "In Progress",
                                    amount: death_amount_inprogress,
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
                                  "assets/images/merriage.png",
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
                              total_marriage_amount == "0" || total_marriage_amount.isEmpty
                                  ? "0 PKR"
                                  : constants.ConvertMappedNumber(total_marriage_amount) + " PKR",
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
                                    amount: marriage_amount_delivered,
                                    color: AppTheme.colors.colorD19,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatusCard(
                                    label: "In Progress",
                                    amount: marriage_amount_inprogress,
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          total_edu_claim_amount == "0" || total_edu_claim_amount.isEmpty
                                              ? "0 PKR"
                                              : constants.ConvertMappedNumber(total_edu_claim_amount) + " PKR",
                                          style: TextStyle(
                                            color: AppTheme.colors.newPrimary,
                                            fontSize: 22,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          width: 80,
                                          height: 2,
                                          color: AppTheme.colors.newPrimary,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Total Amount",
                                          style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 13,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.w600,
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
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.colorLightGray,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          education_claims_count == "0" || education_claims_count.isEmpty
                                              ? "0"
                                              : education_claims_count,
                                          style: TextStyle(
                                            color: AppTheme.colors.newPrimary,
                                            fontSize: 24,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Count",
                                          style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEducationSubCard(
                                    title: "Fee Claims",
                                    count: total_fee_claims,
                                    amount: fee_claims,
                                    icon: Icons.receipt,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildEducationSubCard(
                                    title: "School Basics",
                                    count: total_school_basics,
                                    amount: school_basics,
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
                                    count: total_transport_claim,
                                    amount: transport_amount,
                                    icon: Icons.directions_bus,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildEducationSubCard(
                                    title: "Residence",
                                    count: total_residence_claim,
                                    amount: residence_amount,
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
                                value: feedbacks,
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
        var noteObject= data["notice"] ?? {};
        var countObject= data["counts"] ?? {};
        var amountObject= data["amount"] ?? {};
        var feedsObject= data["feeds"] ?? {};
        
        // Parse counts with null safety
        totalClaim= _formatCount(countObject["overall"]);
        reimbursed_claims= _formatCount(countObject["completed"]);
        inprogress_claims= _formatCount(countObject["pending"]);
        education_claims_count= _formatCount(countObject["education"]);
        total_fee_claims= _formatCount(countObject["edu_fee"]);
        
        // Parse amounts with null safety
        benefits_amount= _formatAmount(amountObject["benefits"]);
        estate_claim_delivered= _formatAmount(amountObject["estate"]);
        hajj_claim_delivered= _formatAmount(amountObject["hajj"]);
        total_death_amount= _formatAmount(amountObject["death"]);
        death_amount_delivered= _formatAmount(amountObject["dth_done"]);
        death_amount_inprogress= _formatAmount(amountObject["dth_remaining"]);
        total_marriage_amount= _formatAmount(amountObject["merriage"]);
        marriage_amount_delivered= _formatAmount(amountObject["mrg_done"]);
        marriage_amount_inprogress= _formatAmount(amountObject["mrg_remaining"]);
        total_edu_claim_amount= _formatAmount(amountObject["education"]);
        fee_claims= _formatAmount(amountObject["edu_fee"]);
        school_basics= _formatAmount(amountObject["school_basics"]);
        transport_amount= _formatAmount(amountObject["transport"]);
        residence_amount= "0";
        
        // Parse notices with null safety
        notice_1= _formatNotice(noteObject["notice_1"]);
        notice_2= _formatNotice(noteObject["notice_2"]);
        
        // Parse feeds with null safety
        complaints= _formatCount(feedsObject["complaints"]);
        feedbacks= _formatCount(feedsObject["feedbacks"]);
        
        // Set defaults for missing data
        total_school_basics= "0";
        total_transport_claim= "0";
        total_residence_claim= "0";
        
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

  // Helper widget for stat items
  Widget _buildStatItem({String label, String value, Color color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 11,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w500,
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
