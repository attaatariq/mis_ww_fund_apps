import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/home/employee/InformationSelection.dart';
import 'package:wwf_apps/screens/home/employee/death_claim.dart';
import 'package:wwf_apps/screens/home/employee/drawer/drawer_view.dart';
import 'package:wwf_apps/screens/home/employee/marriage_claim.dart';
import 'package:wwf_apps/screens/home/employee/verification_scrutiny_screen.dart';
import 'package:wwf_apps/screens/home/employee/create_educational_claim.dart';
import 'package:wwf_apps/screens/home/employee/childrens_list.dart';
import 'package:wwf_apps/screens/general/my_profile.dart';
import 'package:wwf_apps/screens/home/employee/education_claim_list.dart';
import 'package:wwf_apps/screens/home/employee/death_claim_list.dart';
import 'package:wwf_apps/screens/home/employee/marriage_calim_list.dart';
import 'package:wwf_apps/screens/home/employee/estate_claim.dart';
import 'package:wwf_apps/screens/home/employee/hajj_claim.dart';
import 'package:wwf_apps/dialogs/feedback_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/utils/proof_stages_helper.dart';
import 'package:wwf_apps/utils/password_validator.dart';
import 'package:wwf_apps/widgets/password_warning_banner.dart';

class EmployeeHome extends StatefulWidget {
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  Constants constants;
  UIUpdates uiUpdates;
  bool _isPasswordWeak = false;
  bool _passwordCheckDone = false;
  String totalClaim = "0",
      reimbursed_claims = "0",
      inprogress_claims = "0",
      benefits_amount = "0",
      notice_1 = "Not Available",
      notice_2 = "Not Available",
      estate_claim_delivered = "0",
      hajj_claim_delivered = "0",
      total_death_amount = "0",
      death_amount_delivered = "0",
      death_amount_inprogress = "0",
      total_marriage_amount = "0",
      marriage_amount_delivered = "0",
      marriage_amount_inprogress = "0",
      education_claims_count = "0",
      total_edu_claim_amount = "0",
      edu_claims = "0",
      school_basics = "0",
      transport_amount = "0",
      residence_amount = "0",
      complaints = "0",
      feedbacks = "0",
      total_school_basics = "0",
      total_transport_claim = "0",
      total_residence_claim = "0",
      total_edu_claims = "0";

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
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
              "Welcome back, ${UserSessions.instance.getUserName}",
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
        child: Drawer(child: EmployeeDrawerView()),
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
                  // Balance Card
                  _buildBalanceCard(),

                  SizedBox(height: 20),

                  // Quick Actions
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 16,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildQuickActions(),

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

  Widget _buildBalanceCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Benefits",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "PKR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            benefits_amount == "0" || benefits_amount.isEmpty
                ? "Rs. 0.00"
                : "Rs. ${constants.ConvertMappedNumber(benefits_amount)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
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
                  child: _buildStatColumn(
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
                  child: _buildStatColumn(
                    "Completed",
                    reimbursed_claims,
                    Icons.check_circle_outline,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildStatColumn(
                    "Pending",
                    inprogress_claims,
                    Icons.access_time,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
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
            "New Claim",
            Icons.add_circle_outline,
            () {
              _showNewClaimDialog();
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            "Claims List",
            Icons.list_alt,
            () {
              _showClaimsListDialog();
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            "Children",
            Icons.child_care,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChildrenList()),
              );
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            "Profile",
            Icons.person_outline,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile()),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showNewClaimDialog() {
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
                    "Educational Claim",
                    Icons.school,
                    Color(0xFF10B981),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateFeeClaim("", "", "", "", "", "0"),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildClaimTypeButton(
                    "Marriage Claim",
                    Icons.favorite,
                    Color(0xFFEC4899),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarraiageClaim(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildClaimTypeButton(
                    "Death Claim",
                    Icons.favorite_border,
                    Color(0xFFEF4444),
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeathClaim(),
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
                          builder: (context) => EstateClaim(),
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
                          builder: (context) => HajjClaim(),
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
                  estate_claim_delivered,
                  Icons.home_work,
                  Color(0xFF6366F1),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildClaimItem(
                  "Hajj",
                  hajj_claim_delivered,
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
          total_death_amount,
          death_amount_delivered,
          death_amount_inprogress,
          Color(0xFFEF4444),
        ),
        SizedBox(height: 12),
        _buildBenefitRow(
          "Marriage Claim",
          total_marriage_amount,
          marriage_amount_delivered,
          marriage_amount_inprogress,
          Color(0xFFEC4899),
        ),
        SizedBox(height: 12),
        _buildBenefitRow(
          "Estate Claim",
          estate_claim_delivered,
          estate_claim_delivered,
          "0",
          Color(0xFF6366F1),
        ),
        SizedBox(height: 12),
        _buildBenefitRow(
          "Hajj Claim",
          hajj_claim_delivered,
          hajj_claim_delivered,
          "0",
          Color(0xFF8B5CF6),
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
                      total_edu_claim_amount == "0" || total_edu_claim_amount.isEmpty
                          ? "Rs. 0"
                          : "Rs. ${constants.ConvertMappedNumber(total_edu_claim_amount)}",
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
                  "${education_claims_count} claims",
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
              _buildEducationCard("Fee", edu_claims, Icons.receipt),
              _buildEducationCard("Basics", school_basics, Icons.book),
              _buildEducationCard("Transport", transport_amount, Icons.directions_bus),
              _buildEducationCard("Residence", residence_amount, Icons.home),
            ],
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
        _buildNoticeItem(notice_1),
        SizedBox(height: 12),
        _buildNoticeItem(notice_2),
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
                  feedbacks,
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

  // API and helper methods (keeping existing logic)
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

  GetDashBoardData() async {
    var url = constants.getApiBaseURL() +
        constants.homescreen +
        "/" +
        constants.homeEmployees +
        "/" +
        UserSessions.instance.getUserID +
        "/" +
        UserSessions.instance.getUserID;
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

        // Parse counts with null safety
        totalClaim = _formatCount(countObject["overall"]);
        reimbursed_claims = _formatCount(countObject["completed"]);
        inprogress_claims = _formatCount(countObject["pending"]);
        education_claims_count = _formatCount(countObject["education"]);
        total_edu_claims = _formatCount(countObject["edu_fee"]);

        // Parse amounts with null safety
        benefits_amount = _formatAmount(amountObject["benefits"]);
        estate_claim_delivered = _formatAmount(amountObject["estate"]);
        hajj_claim_delivered = _formatAmount(amountObject["hajj"]);
        total_death_amount = _formatAmount(amountObject["death"]);
        death_amount_delivered = _formatAmount(amountObject["dth_done"]);
        death_amount_inprogress = _formatAmount(amountObject["dth_remaining"]);
        total_marriage_amount = _formatAmount(amountObject["merriage"]);
        marriage_amount_delivered = _formatAmount(amountObject["mrg_done"]);
        marriage_amount_inprogress =
            _formatAmount(amountObject["mrg_remaining"]);
        total_edu_claim_amount = _formatAmount(amountObject["education"]);
        edu_claims = _formatAmount(amountObject["edu_fee"]);
        school_basics = _formatAmount(amountObject["school_basics"]);
        transport_amount = _formatAmount(amountObject["transport"]);
        residence_amount = "0";

        // Parse notices with null safety
        notice_1 = _formatNotice(noteObject["notice_1"]);
        notice_2 = _formatNotice(noteObject["notice_2"]);

        // Parse feeds with null safety
        complaints = _formatCount(feedsObject["complaints"]);
        feedbacks = _formatCount(feedsObject["feedbacks"]);

        // Set defaults for missing data
        total_school_basics = "0";
        total_transport_claim = "0";
        total_residence_claim = "0";

        setState(() {});
      }
    } else {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowError(responseCodeModel.message);
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        constants.CheckForNewUpdate(context);
        GetTokenAndSave();
        _checkVerificationStatus();
      }
    });
  }

  void _checkVerificationStatus() async {
    String userSector = UserSessions.instance.getUserSector;
    String userRole = UserSessions.instance.getUserRole;

    if (userSector == "8" && (userRole == "7" || userRole == "8")) {
      if (constants.CheckDataNullSafety(UserSessions.instance.getRefID)) {
        GetDashBoardData();
      }
      _checkAndShowFeedbackDialog();
      return;
    }

    await _loadProofStagesIfNeeded();

    try {
      String userId = UserSessions.instance.getUserID;
      String empId = UserSessions.instance.getEmployeeID;

      if (empId.isEmpty || empId == "" || empId == "null") {
        empId = await _fetchEmployeeID();
      }

      if (empId.isEmpty || empId == "" || empId == "null") {
        if (constants.CheckDataNullSafety(UserSessions.instance.getRefID)) {
          GetDashBoardData();
        }
        _checkAndShowFeedbackDialog();
        return;
      }

      var url = constants.getApiBaseURL() +
          constants.companies +
          "is_verified/" +
          userId +
          "/" +
          empId;

      var response = await http.get(
        Uri.parse(url),
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        dynamic codeValue = body["Code"];
        String code = codeValue != null ? codeValue.toString() : "0";

        if (code == "1" || codeValue == 1) {
          var messageData = body["Message"];
          if (messageData != null && messageData is Map) {
            String empCheck = messageData["emp_check"]?.toString() ?? "";

            if (empCheck != "Scrutinized" && empCheck.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationScrutinyScreen(),
                ),
              );
              return;
            }
          }
        }
      }

      if (constants.CheckDataNullSafety(UserSessions.instance.getRefID)) {
        GetDashBoardData();
      }
      _checkPasswordStrength();
      _checkAndShowFeedbackDialog();
    } catch (e) {
      if (constants.CheckDataNullSafety(UserSessions.instance.getRefID)) {
        GetDashBoardData();
      }
      _checkPasswordStrength();
      _checkAndShowFeedbackDialog();
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

  Future<void> _loadProofStagesIfNeeded() async {
    if (!ProofStagesData.instance.hasStages()) {
      try {
        List<String> tagsList = [constants.accountInfo];
        Map data = {
          "user_id": UserSessions.instance.getUserID,
          "api_tags": jsonEncode(tagsList).toString(),
        };
        var url = constants.getApiBaseURL() +
            constants.authentication +
            "information";
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
            ProofStagesData.loadFromInformationResponse(dataObj);
          }
        }
      } catch (e) {
        // Silently fail
      }
    }
  }

  Future<String> _fetchEmployeeID() async {
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
          if (account != null && account["emp_id"] != null) {
            String empId = account["emp_id"].toString();
            if (empId.isNotEmpty && empId != "null") {
              UserSessions.instance.setEmployeeID(empId);
              return empId;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail
    }
    return "";
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

