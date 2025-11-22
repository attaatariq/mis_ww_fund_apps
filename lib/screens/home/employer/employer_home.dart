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
import 'package:wwf_apps/screens/home/employer/add_worker.dart';
import 'package:wwf_apps/screens/home/employer/annexure1_create.dart';
import 'package:wwf_apps/screens/home/employer/annexure2_create_new.dart';
import 'package:wwf_apps/screens/home/employer/employer_settings.dart';
import 'package:wwf_apps/screens/home/employer/education_claims.dart';
import 'package:wwf_apps/screens/home/employer/marriage_claims.dart';
import 'package:wwf_apps/screens/home/employer/death_claim_list.dart';
import 'package:wwf_apps/screens/home/employer/estate_claims.dart';
import 'package:wwf_apps/screens/home/employer/hajj_claims.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/models/ClaimStageModel.dart';
import 'package:wwf_apps/dialogs/feedback_dialog.dart';
import 'package:wwf_apps/utils/password_validator.dart';
import 'package:wwf_apps/widgets/password_warning_banner.dart';
import 'package:http/http.dart' as http;

import 'drawer/drawer_view.dart';

class EmployerHome extends StatefulWidget {
  @override
  _EmployerHomeState createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {
  Constants constants;
  UIUpdates uiUpdates;
  bool _isPasswordWeak = false;
  bool _passwordCheckDone = false;
  String companyName = "Unknown",
      companyAddress = "Unknown",
      companyLogo = "null";
  String totalEmployee = "0",
      totalDisable = "0",
      totalAvailingBenefits = "0",
      totalClaim = "0",
      totalReimbursed = "0",
      totalInprogress = "0",
      totalAmountReimbursed = "0",
      annexureAAmount = "0",
      annexure3AAmount = "0",
      totalAnnexesAmount = "0",
      estateClaimCount = "0",
      estateClaimAmount = "0",
      hajjClaims = "0",
      hajjClaimAmount = "0",
      deathClaimsTotalAmount = "0",
      deathClaimsDeliveredAmount = "0",
      deathClaimsInprogressAmount = "0",
      marriageClaimsTotalAmount = "0",
      marriageClaimDeliveredAmount = "0",
      marriageClaimsInprogressAmount = "0",
      totalEducationClaims = "0",
      educationClaimsTotalAmount = "0",
      feeClaims = "0",
      schoolBasics = "0",
      feeClaimAmount = "0",
      schoolBasicsAmount = "0",
      transportClaimsAmount = "0",
      residenceClaimAmount = "0",
      note1 = "Not Available",
      note2 = "Not Available",
      complaints = "0",
      feedback = "0";

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    constants.CheckForNewUpdate(context);
    GetDashBoardData();
    GetTokenAndSave();
    _checkPasswordStrength();
    _checkAndShowFeedbackDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded, color: AppTheme.colors.newBlack),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Text(
              companyName != "Unknown" ? companyName : "Company Dashboard",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  constants.LogoutUser(context);
                },
                borderRadius: BorderRadius.circular(14),
                splashColor: Color(0xFFEF4444).withOpacity(0.2),
                highlightColor: Color(0xFFEF4444).withOpacity(0.1),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFEF4444),
                        Color(0xFFDC2626),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEF4444).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.78,
        child: Drawer(child: EmployerDrawerView()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Password Warning Banner
            if (_passwordCheckDone && _isPasswordWeak)
              PasswordWarningBanner(
                onDismiss: () {
                  setState(() {
                    _isPasswordWeak = false;
                  });
                },
              ),

            // Main Content
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Info Card
                  _buildCompanyCard(),

                  SizedBox(height: 20),

                  // Quick Actions
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack.withOpacity(0.6),
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildQuickActions(),

                  SizedBox(height: 24),

                  // Reimbursed Amount (Full Width)
                  _buildReimbursedCard(),

                  SizedBox(height: 24),

                  // Contribution Summary
                  Text(
                    "Contribution Summary",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 16,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildContributionCard(),

                  SizedBox(height: 24),

                  // Benefits Breakdown
                  Text(
                    "Benefits Breakdown",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 16,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildBenefitsBreakdown(),

                  SizedBox(height: 24),

                  // Education Claims
                  _buildEducationSection(),

                  SizedBox(height: 24),

                  // Notice Board
                  Text(
                    "Notice Board",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 16,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildNoticeBoard(),

                  SizedBox(height: 24),

                  // Activity Summary
                  _buildActivitySummary(),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.colors.newPrimary,
            AppTheme.colors.newPrimary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: companyLogo != "null" &&
                          companyLogo != "" &&
                          companyLogo != "NULL" &&
                          companyLogo != "N/A" &&
                          companyLogo != "-" &&
                          companyLogo != "Unknown"
                      ? FadeInImage(
                          image: NetworkImage(
                              constants.getImageBaseURL() + companyLogo),
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName != "Unknown" ? companyName : "Company Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            companyAddress != "Unknown"
                                ? companyAddress
                                : "Address Not Available",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildCompanyStatColumn(
                    "Employees",
                    totalEmployee,
                    Icons.people_outline,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildCompanyStatColumn(
                    "Total Claims",
                    totalClaim,
                    Icons.assignment_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildCompanyStatColumn(
                    "Completed",
                    totalReimbursed,
                    Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            "Worker",
            Icons.person_add_outlined,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddWorker()),
              );
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            "Contribute",
            Icons.account_balance_wallet_outlined,
            () {
              _showContributionDialog();
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            "Claims",
            Icons.receipt_outlined,
            () {
              _showClaimsListDialog();
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            "Settings",
            Icons.settings_outlined,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerSettings()),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showContributionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Select Contribution Type",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 20,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildContributionTypeButton(
                    "WPF Contribution Sheet",
                    Icons.description_outlined,
                    Color(0xFF3B82F6),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnexA(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildContributionTypeButton(
                    "Interest Contribution Sheet",
                    Icons.account_balance_wallet_outlined,
                    Color(0xFF10B981),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Annex3ANew(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionTypeButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 16,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.colors.colorDarkGray,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClaimsListDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Select Claim Type",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 20,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildClaimTypeButton(
                    "Educational Claims",
                    Icons.school,
                    Color(0xFF10B981),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EducationClaimList(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildClaimTypeButton(
                    "Marriage Claims",
                    Icons.favorite,
                    Color(0xFFEC4899),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarriageClaimList(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildClaimTypeButton(
                    "Death Claims",
                    Icons.favorite_border,
                    Color(0xFFEF4444),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeathClaimList(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildClaimTypeButton(
                    "Estate Claims",
                    Icons.home_work,
                    Color(0xFF6366F1),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EstateClaimList(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildClaimTypeButton(
                    "Hajj Claims",
                    Icons.mosque,
                    Color(0xFF8B5CF6),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HajjClaimList(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimTypeButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 16,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.colors.colorDarkGray,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.colors.newPrimary,
                  size: 24,
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.colors.newBlack.withOpacity(0.7),
                  fontSize: 10,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReimbursedCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.monetization_on_outlined,
              color: Color(0xFF10B981),
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reimbursed Amount",
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 12,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  totalAmountReimbursed == "0" || totalAmountReimbursed.isEmpty
                      ? "Rs. 0"
                      : "Rs. ${constants.ConvertMappedNumber(totalAmountReimbursed)}",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 24,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value == "0" || value.isEmpty
                ? (title.contains("Reimb") ? "Rs. 0" : "0")
                : (title.contains("Reimb")
                    ? "Rs. ${constants.ConvertMappedNumber(value)}"
                    : value),
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 20,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.savings_outlined,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Contribution",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      totalAnnexesAmount == "0" || totalAnnexesAmount.isEmpty
                          ? "Rs. 0"
                          : "Rs. ${constants.ConvertMappedNumber(totalAnnexesAmount)}",
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 24,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Annexure-III",
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 11,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        annexureAAmount == "0" || annexureAAmount.isEmpty
                            ? "Rs. 0"
                            : "Rs. ${constants.ConvertMappedNumber(annexureAAmount)}",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 14,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Annexure-III (A)",
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 11,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        annexure3AAmount == "0" || annexure3AAmount.isEmpty
                            ? "Rs. 0"
                            : "Rs. ${constants.ConvertMappedNumber(annexure3AAmount)}",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 14,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildClaimsOverview() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildClaimItem(
                  "Estate",
                  estateClaimAmount,
                  Icons.home_work,
                  Color(0xFF6366F1),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildClaimItem(
                  "Hajj",
                  hajjClaimAmount,
                  Icons.mosque,
                  Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClaimItem(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            amount == "0" || amount.isEmpty
                ? "Rs. 0"
                : "Rs. ${constants.ConvertMappedNumber(amount)}",
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 16,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsBreakdown() {
    return Column(
      children: [
        _buildBenefitRow(
          "Death Claim",
          deathClaimsTotalAmount,
          deathClaimsDeliveredAmount,
          deathClaimsInprogressAmount,
          Color(0xFFEF4444),
        ),
        SizedBox(height: 12),
        _buildBenefitRow(
          "Marriage Claim",
          marriageClaimsTotalAmount,
          marriageClaimDeliveredAmount,
          marriageClaimsInprogressAmount,
          Color(0xFFEC4899),
        ),
      ],
    );
  }

  Widget _buildBenefitRow(String title, String total, String delivered,
      String inProgress, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  title.contains("Death") ? Icons.favorite : Icons.favorite_border,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      total == "0" || total.isEmpty
                          ? "Rs. 0"
                          : "Rs. ${constants.ConvertMappedNumber(total)}",
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivered",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      delivered == "0" || delivered.isEmpty
                          ? "Rs. 0"
                          : "Rs. ${constants.ConvertMappedNumber(delivered)}",
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "In Progress",
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      inProgress == "0" || inProgress.isEmpty
                          ? "Rs. 0"
                          : "Rs. ${constants.ConvertMappedNumber(inProgress)}",
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Education Claims
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Education Claims",
                          style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 16,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          educationClaimsTotalAmount == "0" ||
                                  educationClaimsTotalAmount.isEmpty
                              ? "Rs. 0"
                              : "Rs. ${constants.ConvertMappedNumber(educationClaimsTotalAmount)}",
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 20,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${totalEducationClaims} claims",
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _buildEducationCard("Fee", feeClaimAmount, Icons.receipt),
                  _buildEducationCard("Basics", schoolBasicsAmount, Icons.book),
                  _buildEducationCard(
                      "Transport", transportClaimsAmount, Icons.directions_bus),
                  _buildEducationCard("Residence", residenceClaimAmount, Icons.home),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        // Estate and Hajj Claims
        Row(
          children: [
            Expanded(
              child: _buildEstateHajjCard(
                "Estate",
                estateClaimAmount,
                Icons.home_work,
                Color(0xFF6366F1),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEstateHajjCard(
                "Hajj",
                hajjClaimAmount,
                Icons.mosque,
                Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEstateHajjCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            amount == "0" || amount.isEmpty
                ? "Rs. 0"
                : "Rs. ${constants.ConvertMappedNumber(amount)}",
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 16,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(String title, String amount, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF10B981),
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  amount == "0" || amount.isEmpty
                      ? "Rs. 0"
                      : "Rs. ${constants.ConvertMappedNumber(amount)}",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 12,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBoard() {
    return Column(
      children: [
        _buildNoticeItem(note1),
        SizedBox(height: 12),
        _buildNoticeItem(note2),
      ],
    );
  }

  Widget _buildNoticeItem(String notice) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications_active,
              color: Color(0xFFF59E0B),
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              notice,
              style: TextStyle(
                color: AppTheme.colors.newBlack,
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

  Widget _buildActivitySummary() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Activity",
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActivityItem(
                  "Complaints",
                  complaints,
                  Icons.report_problem_outlined,
                  Color(0xFFEF4444),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildActivityItem(
                  "Feedback",
                  feedback,
                  Icons.feedback_outlined,
                  Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 20,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // API and helper methods (existing logic)
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

  String _formatCount(dynamic value) {
    String parsed = _safeParseValue(value, defaultValue: "0");
    try {
      int count = int.parse(parsed);
      return count.toString();
    } catch (e) {
      return "0";
    }
  }

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

  GetDashBoardData() async {
    var url = constants.getApiBaseURL() +
        constants.homescreen +
        "/" +
        constants.homeCompanies +
        "/" +
        UserSessions.instance.getUserID +
        "/" +
        UserSessions.instance.getRefID;
    var response =
        await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel =
        constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data = body["Data"];
        var noteObject = data["notice"] ?? {};
        var countObject = data["counts"] ?? {};
        var amountObject = data["amount"] ?? {};
        var feedsObject = data["feeds"] ?? {};
        var information = data["extra"] != null && data["extra"]["company"] != null
            ? data["extra"]["company"]
            : {};

        // Parse company information with null safety
        companyName = _formatCompanyInfo(information["comp_name"],
            defaultValue: "Unknown");
        companyAddress = _formatCompanyInfo(information["comp_address"],
            defaultValue: "Unknown");
        companyLogo =
            _formatCompanyInfo(information["comp_logo"], defaultValue: "null");

        // Parse counts with null safety
        totalEmployee = _formatCount(countObject["workers"]);
        totalDisable = _formatCount(countObject["special"]);
        totalAvailingBenefits = _formatCount(countObject["availing"]);
        totalClaim = _formatCount(countObject["overall"]);
        totalReimbursed = _formatCount(countObject["completed"]);
        totalInprogress = _formatCount(countObject["pending"]);
        estateClaimCount = _formatCount(countObject["estate"]);
        hajjClaims = _formatCount(countObject["hajj"]);
        totalEducationClaims = _formatCount(countObject["education"]);
        feeClaims = _formatCount(countObject["edu_fee"]);

        // Parse amounts with null safety
        totalAmountReimbursed = _formatAmount(amountObject["benefits"]);
        annexureAAmount = _formatAmount(amountObject["annexure_1"]);
        annexure3AAmount = _formatAmount(amountObject["annexure_2"]);
        totalAnnexesAmount = _formatAmount(amountObject["contribution"]);
        estateClaimAmount = _formatAmount(amountObject["estate"]);
        hajjClaimAmount = _formatAmount(amountObject["hajj"]);
        deathClaimsTotalAmount = _formatAmount(amountObject["death"]);
        deathClaimsDeliveredAmount = _formatAmount(amountObject["dth_done"]);
        deathClaimsInprogressAmount =
            _formatAmount(amountObject["dth_remaining"]);
        marriageClaimsTotalAmount = _formatAmount(amountObject["merriage"]);
        marriageClaimDeliveredAmount = _formatAmount(amountObject["mrg_done"]);
        marriageClaimsInprogressAmount =
            _formatAmount(amountObject["mrg_remaining"]);
        educationClaimsTotalAmount = _formatAmount(amountObject["education"]);
        feeClaimAmount = _formatAmount(amountObject["edu_fee"]);
        schoolBasicsAmount = _formatAmount(amountObject["school_basics"]);
        transportClaimsAmount = _formatAmount(amountObject["transport"]);

        // Parse notices with null safety
        note1 = _formatNotice(noteObject["notice_1"]);
        note2 = _formatNotice(noteObject["notice_2"]);

        // Parse feeds with null safety
        complaints = _formatCount(feedsObject["complaints"]);
        feedback = _formatCount(feedsObject["feedbacks"]);

        // Load claim stages from dashboard data if available
        if (data["claim_stages"] != null) {
          ClaimStagesData.loadFromInformationResponse(data);
        }

        // Set defaults for missing data
        schoolBasics = "0";
        residenceClaimAmount = "0";

        setState(() {});
      }
    } else {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowError(responseCodeModel.message);
    }
  }

  void _checkPasswordStrength() async {
    try {
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url =
          constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String code = body["Code"]?.toString() ?? "0";
        if (code == "1" || body["Code"] == 1) {
          var dataObj = body["Data"];
          var account = dataObj["account"];
          if (account != null && account is Map) {
            bool isWeak = PasswordValidator.isPasswordWeakFromAccount(account);
            if (mounted) {
              setState(() {
                _isPasswordWeak = isWeak;
                _passwordCheckDone = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _passwordCheckDone = true;
              });
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _passwordCheckDone = true;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _passwordCheckDone = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _passwordCheckDone = true;
        });
      }
    }
  }

  void _checkAndShowFeedbackDialog() {
    bool feedbackShown = UserSessions.instance.getFeedbackDialogShown;
    if (!feedbackShown) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          bool stillNotShown = UserSessions.instance.getFeedbackDialogShown;
          if (!stillNotShown) {
            UserSessions.instance.setFeedbackDialogShown(true);
            showFeedbackDialog(context).then((result) {
              // Dialog closed
            });
          }
        }
      });
    }
  }

  void GetTokenAndSave() async {
    FirebaseMessaging _firebaseMessaging = await FirebaseMessaging.instance;
    if (Platform.isAndroid) {
      GetToken();
    } else if (Platform.isIOS) {
      GetToken();
    }
  }

  void GetToken() async {
    await FirebaseMessaging.instance.getToken().then((token) => {
          SaveNotificationToken(token)
        });
  }

  void SaveNotificationToken(String notificationToken) async {
    var url = constants.getApiBaseURL() + constants.authentication + "gadget";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['gadget_id'] = notificationToken;
    APIService.addAuthHeaderToMultipartRequest(request);
    var response = await request.send();
    try {
      final resp = await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel =
          constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
        } else {}
      } else {
        var body = jsonDecode(resp.body);
        if (!(body["Message"]
            .toString()
            .contains('Your request has same device ID'))) {
          String message = body["Message"].toString();
          uiUpdates.ShowError(message);
        }
      }
    } catch (e) {
      uiUpdates.ShowError(e.toString());
    }
  }
}

