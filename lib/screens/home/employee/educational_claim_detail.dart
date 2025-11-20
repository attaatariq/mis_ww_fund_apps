import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/viewer/ImageViewer.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/utils/claim_stages_helper.dart';
import 'package:wwf_apps/network/api_service.dart';
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
  // Documents
  String applicationFormDoc = "", resultCardDoc = "", feeVoucherDoc = "", feeStructureDoc = "", transportVoucherDoc = "", hostelVoucherDoc = "";
  
  // Basic Info
  String beneficiary = "-", start_date = "-", end_date = "-", created_at = "-", claim_stage = "-";
  
  // Financial
  String claim_amount = "-", claim_payment = "-", claim_excluded = "-";
  
  // Fee Breakdown
  String tuition_fee = "-", registration_fee = "-", prospectus_fee = "-", security_fee = "-",
      library_fee = "-", examination_fee = "-", computer_fee = "-", sports_fee = "-", washing_fee = "-", 
      development = "-", outstanding_fee = "-", adjustment = "-", reimbursement = "-", tax_amount = "-", 
      late_fee_fine = "-", other_fine = "-", other_charges = "-";
  
  // Transport & Hostel
  String transport_cost = "-", hostel_rent = "-", mess_charges = "-";
  
  // Remarks
  String remarks_1 = "-", remarks_2 = "-";
  
  // Child Information
  String child_id = "", child_name = "-", child_cnic = "-", child_image = "-", child_gender = "-", 
      child_birthday = "-", child_identity = "-", child_status = "-";
  
  // User Information (from API or UserSessions)
  String user_name = "-", user_image = "-", user_cnic = "-", user_gender = "-";

  @override
  void initState() {
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetFeeClaimsDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Modern Header with Shadow
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.newPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppTheme.colors.newWhite,
                          size: 22,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Fee Claim Details",
                      style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // User Info Card (Always show employee info)
                    _buildUserInfoCard(),
                    SizedBox(height: 16),
                    
                    // Child Info Card (Only if beneficiary is Child)
                    if (beneficiary == "Child" && child_name != "-" && child_name.isNotEmpty)
                      _buildChildInfoCard(),
                    if (beneficiary == "Child" && child_name != "-" && child_name.isNotEmpty)
                      SizedBox(height: 16),

                    // Status Card
                    _buildStatusCard(),
                    SizedBox(height: 16),

                    // Claim Period & Amount
                    _buildClaimOverview(),
                    SizedBox(height: 16),
                    
                    // Financial Summary
                    _buildSectionHeader("Financial Summary", Icons.account_balance_wallet),
                    SizedBox(height: 12),
                    _buildFinancialSummaryCard(),
                    SizedBox(height: 16),

                    // Fee Breakdown Section
                    _buildSectionHeader("Fee Breakdown", Icons.receipt_long),
                    SizedBox(height: 12),
                    _buildFeeBreakdownCard(),
                    SizedBox(height: 16),

                    // Additional Charges Section
                    _buildSectionHeader("Additional Charges", Icons.add_circle_outline),
                    SizedBox(height: 12),
                    _buildAdditionalChargesCard(),
                    SizedBox(height: 16),

                    // Transport & Hostel Section
                    _buildSectionHeader("Transport & Accommodation", Icons.directions_bus),
                    SizedBox(height: 12),
                    _buildTransportHostelCard(),
                    SizedBox(height: 16),

                    // Remarks Section
                    _buildSectionHeader("Remarks", Icons.note_alt_outlined),
                    SizedBox(height: 12),
                    _buildRemarksCard(),
                    SizedBox(height: 16),

                    // Documents Section
                    _buildSectionHeader("Documents", Icons.folder_outlined),
                    SizedBox(height: 12),
                    _buildDocumentsGrid(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    // Always show employee/user information
    String displayName = user_name != "-" && user_name.isNotEmpty 
        ? user_name 
        : (UserSessions.instance.getUserName ?? "Employee");
    String displayCnic = user_cnic != "-" && user_cnic.isNotEmpty 
        ? user_cnic 
        : (UserSessions.instance.getUserCNIC ?? "");
    String displayImage = user_image != "-" && user_image.isNotEmpty 
        ? user_image 
        : (UserSessions.instance.getUserImage ?? "");
    
    bool isValidImage = displayImage != "null" && 
                       displayImage != "" && 
                       displayImage != "NULL" &&
                       displayImage != "-" &&
                       displayImage != "N/A";
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppTheme.colors.newPrimary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: isValidImage
                  ? FadeInImage(
                      image: NetworkImage(constants.getImageBaseURL() + displayImage),
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 16,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                if (displayCnic.isNotEmpty && displayCnic != "-")
                  Row(
                    children: [
                      Icon(
                        Icons.badge_outlined,
                        size: 14,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          displayCnic,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 12,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.colors.newPrimary,
            ),
            child: Text(
              "Employee",
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 11,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChildInfoCard() {
    bool isValidImage = child_image != "null" && 
                       child_image != "" && 
                       child_image != "NULL" &&
                       child_image != "-" &&
                       child_image != "N/A";
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.child_care,
                size: 18,
                color: AppTheme.colors.newPrimary,
              ),
              SizedBox(width: 8),
              Text(
                "Child Information",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppTheme.colors.newPrimary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: isValidImage
                      ? FadeInImage(
                          image: NetworkImage(constants.getImageBaseURL() + child_image),
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child_name != "-" ? child_name : "Child",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 15,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (child_cnic.isNotEmpty && child_cnic != "-")
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 12,
                            color: AppTheme.colors.colorDarkGray,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              child_cnic,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.colors.colorDarkGray,
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (child_gender != "-" && child_gender.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              child_gender.toLowerCase() == "male" ? Icons.male : Icons.female,
                              size: 12,
                              color: child_gender.toLowerCase() == "male" ? Colors.blue : Colors.pink,
                            ),
                            SizedBox(width: 4),
                            Text(
                              child_gender,
                              style: TextStyle(
                                color: AppTheme.colors.colorDarkGray,
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
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
  
  Widget _buildFinancialSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFinancialItem("Total Claim Amount", claim_amount, isPrimary: true),
          SizedBox(height: 12),
          _buildFinancialItem("Amount Paid", claim_payment),
          SizedBox(height: 12),
          _buildFinancialItem("Amount Excluded", claim_excluded),
        ],
      ),
    );
  }
  
  Widget _buildFinancialItem(String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: isPrimary ? 14 : 13,
            fontFamily: "AppFont",
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          "PKR $value",
          style: TextStyle(
            color: isPrimary ? AppTheme.colors.newPrimary : AppTheme.colors.newBlack,
            fontSize: isPrimary ? 18 : 15,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Column(
      children: [
        // Dynamic Claim Status Card
        ClaimStagesHelper.buildDetailStatusCard(claim_stage),
        SizedBox(height: 12),
        // Submission Date Card
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Submitted Date",
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 11,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    created_at,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem({IconData icon, String label, String value, Color valueColor}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.colors.newPrimary),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: 11,
            fontFamily: "AppFont",
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: valueColor != null ? valueColor : AppTheme.colors.newBlack,
            fontSize: 13,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildClaimOverview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.colors.newPrimary,
            AppTheme.colors.newPrimary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Claim Period",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$start_date - $end_date",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.date_range,
                color: AppTheme.colors.newWhite.withOpacity(0.8),
                size: 28,
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppTheme.colors.newWhite.withOpacity(0.3), height: 1),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Claim Amount",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "PKR $claim_amount",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 20,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.account_balance_wallet,
                color: AppTheme.colors.newWhite.withOpacity(0.8),
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.colors.newPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppTheme.colors.newPrimary,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 15,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeBreakdownCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFeeItem("Tuition Fee", tuition_fee, isFirst: true),
          _buildFeeItem("Registration Fee", registration_fee),
          _buildFeeItem("Prospectus Fee", prospectus_fee),
          _buildFeeItem("Security Fee", security_fee),
          _buildFeeItem("Library Fee", library_fee),
          _buildFeeItem("Examination Fee", examination_fee),
          _buildFeeItem("Computer Fee", computer_fee),
          _buildFeeItem("Sports Fee", sports_fee),
          _buildFeeItem("Washing Fee", washing_fee),
          _buildFeeItem("Development Fee", development, isLast: true),
        ],
      ),
    );
  }

  Widget _buildAdditionalChargesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFeeItem("Outstanding Fee", outstanding_fee, isFirst: true),
          _buildFeeItem("Adjustment", adjustment),
          _buildFeeItem("Reimbursement", reimbursement),
          _buildFeeItem("Tax Amount", tax_amount),
          _buildFeeItem("Late Fee Fine", late_fee_fine),
          _buildFeeItem("Other Fine", other_fine),
          _buildFeeItem("Other Charges", other_charges, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTransportHostelCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFeeItem("Transport Cost", transport_cost, isFirst: true),
          _buildFeeItem("Hostel Rent", hostel_rent),
          _buildFeeItem("Mess Charges", mess_charges, isLast: true),
        ],
      ),
    );
  }

  Widget _buildRemarksCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRemarkItem("Remarks 1", remarks_1),
          SizedBox(height: 12),
          _buildRemarkItem("Remarks 2", remarks_2),
        ],
      ),
    );
  }

  Widget _buildRemarkItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: 11,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 13,
            fontFamily: "AppFont",
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeItem(String label, String value, {bool isFirst = false, bool isLast = false}) {
    // Format value: if "-" or empty, show "0.00", otherwise show the value
    String displayValue = (value == "-" || value.isEmpty || value == "null" || value == "NULL") 
        ? "0.00" 
        : value;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Text(
            "PKR $displayValue",
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsGrid() {
    final List<Map<String, String>> documents = [
      {"title": "Application Form", "doc": applicationFormDoc},
      {"title": "Result Card", "doc": resultCardDoc},
      {"title": "Fee Structure", "doc": feeStructureDoc},
      {"title": "Fee Voucher", "doc": feeVoucherDoc},
      {"title": "Transport Voucher", "doc": transportVoucherDoc},
      {"title": "Hostel Voucher", "doc": hostelVoucherDoc},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        final hasDoc = doc["doc"] != null && 
                      doc["doc"] != "" && 
                      doc["doc"] != "NULL" && 
                      doc["doc"] != "null" && 
                      doc["doc"] != "N/A" &&
                      doc["doc"] != "-" &&
                      doc["doc"].toString().toLowerCase() != "none";

        return InkWell(
          onTap: hasDoc
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(constants.getImageBaseURL() + doc["doc"]),
                    ),
                  );
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.newWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasDoc
                    ? AppTheme.colors.newPrimary.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasDoc
                        ? AppTheme.colors.newPrimary.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasDoc ? Icons.check_circle : Icons.insert_drive_file_outlined,
                    size: 32,
                    color: hasDoc ? AppTheme.colors.newPrimary : Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    doc["title"],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasDoc ? AppTheme.colors.newBlack : Colors.grey,
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  hasDoc ? "Available" : "Not Available",
                  style: TextStyle(
                    color: hasDoc ? AppTheme.colors.colorExelent : Colors.grey,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void GetFeeClaimsDetail() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(constants.claims + "educational_info/", UserSessions.instance.getUserID, additionalPath: widget.calim_ID);
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            var data = body["Data"];
            if (data != null) {
              // Basic Info
              beneficiary = data["beneficiary"]?.toString() ?? "-";
              start_date = data["start_date"]?.toString() ?? "-";
              end_date = data["end_date"]?.toString() ?? "-";
              created_at = data["created_at"]?.toString() ?? "-";
              claim_stage = data["claim_stage"]?.toString() ?? "-";
              
              // Fee Breakdown (format as "0.00" if null/empty)
              tuition_fee = _formatAmount(data["tuition_fee"]);
              registration_fee = _formatAmount(data["registration_fee"]);
              prospectus_fee = _formatAmount(data["prospectus_fee"]);
              security_fee = _formatAmount(data["security_fee"]);
              library_fee = _formatAmount(data["library_fee"]);
              examination_fee = _formatAmount(data["examination_fee"]);
              computer_fee = _formatAmount(data["computer_fee"]);
              sports_fee = _formatAmount(data["sports_fee"]);
              washing_fee = _formatAmount(data["washing_fee"]);
              development = _formatAmount(data["development"]);
              outstanding_fee = _formatAmount(data["outstanding_fee"]);
              adjustment = _formatAmount(data["adjustment"]);
              reimbursement = _formatAmount(data["reimbursement"]);
              tax_amount = _formatAmount(data["tax_amount"]);
              late_fee_fine = _formatAmount(data["late_fee_fine"]);
              other_fine = _formatAmount(data["other_fine"]);
              other_charges = _formatAmount(data["other_charges"]);
              
              // Transport & Hostel
              transport_cost = _formatAmount(data["transport_cost"]);
              hostel_rent = _formatAmount(data["hostel_rent"]);
              mess_charges = _formatAmount(data["mess_charges"]);
              
              // Financial (format as "0.00" if null/empty)
              claim_amount = _formatAmount(data["claim_amount"]);
              claim_payment = _formatAmount(data["claim_payment"]);
              claim_excluded = _formatAmount(data["claim_excluded"]);
              
              // Remarks
              remarks_1 = data["remarks_1"]?.toString() ?? "-";
              remarks_2 = data["remarks_2"]?.toString() ?? "-";
              
              // Documents (handle null and validate paths)
              applicationFormDoc = _validateDocumentPath(data["application_form"]);
              resultCardDoc = _validateDocumentPath(data["result_card"]);
              feeStructureDoc = _validateDocumentPath(data["fee_structure"]);
              feeVoucherDoc = _validateDocumentPath(data["fee_voucher"]);
              transportVoucherDoc = _validateDocumentPath(data["transport_voucher"]);
              hostelVoucherDoc = _validateDocumentPath(data["hostel_voucher"]);
              
              // Child Information
              child_id = data["child_id"]?.toString() ?? "";
              child_name = data["child_name"]?.toString() ?? "-";
              child_cnic = data["child_cnic"]?.toString() ?? "-";
              child_image = data["child_image"]?.toString() ?? "-";
              child_gender = data["child_gender"]?.toString() ?? "-";
              child_birthday = data["child_birthday"]?.toString() ?? "-";
              child_identity = data["child_identity"]?.toString() ?? "-";
              child_status = data["child_status"]?.toString() ?? "-";
              
              // User Information (try from API first, fallback to UserSessions)
              user_name = data["user_name"]?.toString() ?? 
                         (UserSessions.instance.getUserName ?? "-");
              user_image = data["user_image"]?.toString() ?? 
                          (UserSessions.instance.getUserImage ?? "-");
              user_cnic = data["user_cnic"]?.toString() ?? 
                         (UserSessions.instance.getUserCNIC ?? "-");
              user_gender = data["user_gender"]?.toString() ?? "-";

              setState(() {});
            } else {
              uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
            }
          } else {
            String message = body["Message"] != null ? body["Message"].toString() : "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            } else {
              uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
            }
          }
        } catch (e) {
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"] != null ? body["Message"].toString() : "";
          
          if (message == constants.expireToken) {
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          } else if (message.isNotEmpty && message != "null") {
            uiUpdates.ShowToast(message);
          } else {
            uiUpdates.ShowToast(responseCodeModel.message);
          }
        } catch (e) {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
      }
    } catch (e) {
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }

  String _formatAmount(dynamic value) {
    if (value == null) return "0.00";
    String strValue = value.toString().trim();
    if (strValue.isEmpty || strValue == "-" || strValue == "null" || strValue == "NULL" || strValue == "N/A") {
      return "0.00";
    }
    // If it's already a valid number, return as is
    try {
      double.parse(strValue);
      return strValue;
    } catch (e) {
      return "0.00";
    }
  }
  
  String _validateDocumentPath(dynamic value) {
    if (value == null) return "";
    String docPath = value.toString().trim();
    if (docPath.isEmpty || 
        docPath == "null" || 
        docPath == "NULL" || 
        docPath == "N/A" || 
        docPath == "-" ||
        docPath.toLowerCase() == "none") {
      return "";
    }
    return docPath;
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}

