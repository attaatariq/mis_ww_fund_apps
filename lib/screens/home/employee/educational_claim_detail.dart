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

class EducationalClaimDetail extends StatefulWidget {
  String claimID = "";

  EducationalClaimDetail(this.claimID);

  @override
  _EducationalClaimDetailState createState() => _EducationalClaimDetailState();
}

class _EducationalClaimDetailState extends State<EducationalClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  
  bool isLoading = true;
  bool isError = false;
  String errorMessage = "";
  
  // Claim Basic Info
  String claim_id = "", support_type = "", beneficiary = "", start_date = "", end_date = "", 
      claim_stage = "", claim_gateway = "", reference_number = "", bank_status = "", 
      created_at = "", term_frequency = "";
  
  // Financial
  String claim_amount = "0.00", claim_payment = "0.00", claim_excluded = "0.00";
  
  // User Information
  String user_name = "-", user_cnic = "-", user_email = "-", user_contact = "-",
      user_gender = "-", user_image = "-", user_scale = "-", user_about = "-";
  
  // Company & Employee Information
  String comp_name = "-", role_name = "-", sector_name = "-", emp_father = "-",
      emp_about = "-", emp_address = "-", emp_bank = "-", emp_title = "-", emp_account = "-";
  
  // Location Information
  String city_name = "-", district_name = "-", state_name = "-";
  
  // Child Information
  String child_name = "-", child_cnic = "-", child_gender = "-", child_image = "-";
  
  // School Information
  String school_name = "-", school_panel = "-", school_email = "-", school_contact = "-",
      school_fax_no = "-", school_type = "-", school_bank = "-", school_title = "-",
      school_nature = "-", school_account = "-", school_code = "-";
  
  // Education Information
  String edu_nature = "-", edu_level = "-", edu_degree = "-", edu_class = "-",
      edu_started = "-", edu_ended = "-", edu_living = "-", edu_mess = "-", edu_transport = "-";
  
  // Payment Information
  String debit_account = "-", recipient_bank = "-", credit_account = "-", 
      credit_amount = "-", bank_number = "-", transferred_at = "-";
  
  // Benefit Flags
  Map<String, int> benefitFlags = {};
  
  // Benefit 1: Academic Fee
  String tuition_fee = "0.00", registration_fee = "0.00", prospectus_fee = "0.00",
      security_fee = "0.00", library_fee = "0.00", examination_fee = "0.00",
      computer_fee = "0.00", sports_fee = "0.00", washing_fee = "0.00",
      development = "0.00", outstanding_fee = "0.00", adjustment = "0.00",
      reimbursement = "0.00", tax_amount = "0.00", late_fee_fine = "0.00",
      other_fine = "0.00", remarks_1 = "-", other_charges = "0.00", remarks_2 = "-";
  String application_form = "", result_card = "", fee_structure = "", fee_voucher = "";
  
  // Benefit 2: Uniform & Books
  String uniform_charges = "0.00", supplies_charges = "0.00", essentials_remarks = "-";
  String uniform_voucher = "", supplies_voucher = "";
  
  // Benefit 3: Transport
  String transport_type = "-", travel_distance = "0.00", transport_cost = "0.00";
  String transport_voucher = "";
  
  // Benefit 4: Stipend
  String stipend_amount = "0.00", stipend_category = "-", stipend_remarks = "-";
  
  // Benefit 5: Hostel & Mess
  String hostel_rent = "0.00", mess_charges = "0.00", hostel_remarks = "-";
  String hostel_voucher = "";

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
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Modern Header
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
                    Expanded(
                      child: Text(
                        "Educational Claim Details",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: isError
                ? _buildErrorState()
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Claim Details Card
                              _buildClaimDetailsCard(),
                              SizedBox(height: 16),
                              
                              // User/Child Info Card
                              if (beneficiary == "Child")
                                _buildChildInfoCard()
                              else
                                _buildUserInfoCard(),
                              SizedBox(height: 16),
                              
                              // Status Card
                              _buildStatusCard(),
                              SizedBox(height: 16),
                              
                              // Company & Location Information
                              _buildCompanyLocationCard(),
                              SizedBox(height: 16),
                              
                              // Educational Details
                              _buildEducationalDetailsCard(),
                              SizedBox(height: 16),
                              
                              // School/Institution Details
                              _buildSchoolDetailsCard(),
                              SizedBox(height: 16),
                              
                              // Employee Bank Details
                              if (emp_bank != "-" || emp_account != "-")
                                _buildEmployeeBankDetailsCard(),
                              if (emp_bank != "-" || emp_account != "-")
                                SizedBox(height: 16),
                              
                              // Financial Summary
                              _buildFinancialSummaryCard(),
                              SizedBox(height: 16),
                              
                              // Benefits Coverage
                              _buildBenefitsCoverageCard(),
                              SizedBox(height: 16),
                              
                              // Benefit 1: Academic Fee
                              if (isBenefitIncluded(1))
                                _buildAcademicFeeBenefitCard(),
                              if (isBenefitIncluded(1))
                                SizedBox(height: 16),
                              
                              // Benefit 2: Uniform & Books
                              if (isBenefitIncluded(2))
                                _buildUniformBooksBenefitCard(),
                              if (isBenefitIncluded(2))
                                SizedBox(height: 16),
                              
                              // Benefit 3: Transport
                              if (isBenefitIncluded(3))
                                _buildTransportBenefitCard(),
                              if (isBenefitIncluded(3))
                                SizedBox(height: 16),
                              
                              // Benefit 4: Stipend
                              if (isBenefitIncluded(4))
                                _buildStipendBenefitCard(),
                              if (isBenefitIncluded(4))
                                SizedBox(height: 16),
                              
                              // Benefit 5: Hostel & Mess
                              if (isBenefitIncluded(5))
                                _buildHostelMessBenefitCard(),
                              if (isBenefitIncluded(5))
                                SizedBox(height: 16),
                              
                              // Payment Information
                              _buildPaymentInformationCard(),
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

  // Helper method to check if benefit is included
  bool isBenefitIncluded(int benefitNumber) {
    return (benefitFlags[benefitNumber.toString()] ?? 0) == 1;
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              errorMessage.isNotEmpty ? errorMessage : Strings.instance.notAvail,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isError = false;
                  isLoading = true;
                });
                CheckTokenExpiry();
              },
              icon: Icon(Icons.refresh, size: 18),
              label: Text("Retry"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppTheme.colors.newPrimary),
                foregroundColor: MaterialStateProperty.all(AppTheme.colors.newWhite),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimDetailsCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Claim Details",
                style: TextStyle(
                  color: AppTheme.colors.newWhite,
                  fontSize: 16,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  claim_id,
                  style: TextStyle(
                    color: AppTheme.colors.newWhite,
                    fontSize: 12,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildWhiteInfoRow("Support Type", support_type, "Beneficiary", beneficiary),
          SizedBox(height: 12),
          _buildWhiteInfoRow("Start Date", start_date, "End Date", end_date),
          SizedBox(height: 12),
          _buildWhiteInfoRow("Submission Date", created_at, "", ""),
        ],
      ),
    );
  }

  Widget _buildWhiteInfoRow(String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  color: AppTheme.colors.newWhite.withOpacity(0.9),
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value1,
                style: TextStyle(
                  color: AppTheme.colors.newWhite,
                  fontSize: 13,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (label2.isNotEmpty)
          SizedBox(width: 16),
        if (label2.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    color: AppTheme.colors.newWhite.withOpacity(0.9),
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value2,
                  style: TextStyle(
                    color: AppTheme.colors.newWhite,
                    fontSize: 13,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfoCard() {
    bool isValidImage = user_image != "null" && 
                       user_image != "" && 
                       user_image != "NULL" &&
                       user_image != "-" &&
                       user_image != "N/A";
    
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
          Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.colors.newPrimary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: isValidImage
                      ? FadeInImage(
                          image: NetworkImage(constants.getImageBaseURL() + user_image),
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
                      user_name,
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
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: AppTheme.colors.colorDarkGray,
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            user_cnic,
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
                    if (comp_name != "-")
                      SizedBox(height: 4),
                    if (comp_name != "-")
                      Text(
                        comp_name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.colors.newPrimary,
                          fontSize: 11,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: user_gender.toLowerCase() == "male" 
                      ? Colors.blue.withOpacity(0.1) 
                      : Colors.pink.withOpacity(0.1),
                ),
                child: Text(
                  user_gender,
                  style: TextStyle(
                    color: user_gender.toLowerCase() == "male" 
                        ? Colors.blue 
                        : Colors.pink,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
          Text(
            "Child Information",
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF6366F1).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
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
                      child_name,
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
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: AppTheme.colors.colorDarkGray,
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            child_cnic,
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
                  color: child_gender.toLowerCase() == "male" 
                      ? Colors.blue.withOpacity(0.1) 
                      : Colors.pink.withOpacity(0.1),
                ),
                child: Text(
                  child_gender,
                  style: TextStyle(
                    color: child_gender.toLowerCase() == "male" 
                        ? Colors.blue 
                        : Colors.pink,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Column(
      children: [
        ClaimStagesHelper.buildDetailStatusCard(claim_stage),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.colors.colorExelent,
                AppTheme.colors.colorExelent.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.colors.colorExelent.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
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
                      fontSize: 24,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.account_balance_wallet,
                color: AppTheme.colors.newWhite.withOpacity(0.8),
                size: 36,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyLocationCard() {
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  size: 20,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Company & Location",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          if (comp_name != "-")
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.colors.newPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.colors.newPrimary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Company Name",
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 11,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    comp_name,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          if (comp_name != "-")
            SizedBox(height: 12),
          
          _buildInfoRow("City", city_name, "District", district_name),
          if (state_name != "-")
            SizedBox(height: 12),
          if (state_name != "-")
            _buildInfoRow("Province", state_name, "Role", role_name),
        ],
      ),
    );
  }

  Widget _buildEducationalDetailsCard() {
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  size: 20,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Educational Details",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 15,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildInfoRow("Nature / Level", "$edu_nature / $edu_level", "Degree / Class", "$edu_degree / $edu_class"),
          SizedBox(height: 12),
          _buildInfoRow("Session / Batch", "$edu_started - $edu_ended", "", ""),
          SizedBox(height: 12),
          _buildInfoRow("Residency", edu_living, "Transport", edu_transport),
          if (edu_mess != "-")
            SizedBox(height: 12),
          if (edu_mess != "-")
            _buildInfoRow("Mess Facility", edu_mess, "", ""),
        ],
      ),
    );
  }

  Widget _buildSchoolDetailsCard() {
    if (school_name == "-" || school_name.isEmpty) {
      return SizedBox.shrink();
    }
    
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance,
                  size: 20,
                  color: Color(0xFF6366F1),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "School/Institution Details",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF6366F1).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFF6366F1).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Institution Name",
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  school_name,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 13,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 12),
          _buildInfoRow("Type", school_type, "Panel", school_panel),
          SizedBox(height: 12),
          _buildInfoRow("Email", school_email != "-" ? school_email : "N/A", "Contact", school_contact != "-" ? school_contact : "N/A"),
          
          if (school_bank != "-" || school_account != "-")
            SizedBox(height: 16),
          if (school_bank != "-" || school_account != "-")
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          if (school_bank != "-" || school_account != "-")
            SizedBox(height: 12),
          
          if (school_bank != "-" || school_account != "-")
            Text(
              "School Bank Details",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 12,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
            ),
          if (school_bank != "-" || school_account != "-")
            SizedBox(height: 12),
          if (school_bank != "-" || school_account != "-")
            _buildInfoRow("Bank Name", school_bank, "Account Title", school_title),
          if (school_account != "-")
            SizedBox(height: 12),
          if (school_account != "-")
            _buildInfoRow("Account Number", school_account, "Account Nature", school_nature),
          if (school_code != "-")
            SizedBox(height: 12),
          if (school_code != "-")
            _buildInfoRow("Branch Code", school_code, "", ""),
        ],
      ),
    );
  }

  Widget _buildEmployeeBankDetailsCard() {
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 20,
                  color: Colors.amber.shade700,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Employee Bank Details",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 15,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildInfoRow("Bank Name", emp_bank, "Account Title", emp_title),
          SizedBox(height: 12),
          _buildInfoRow("Account Number", emp_account, "", ""),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.colorExelent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.monetization_on,
                  size: 20,
                  color: AppTheme.colors.colorExelent,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Financial Summary",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 15,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildFinancialItem("Total Amount", claim_amount, AppTheme.colors.colorExelent),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFinancialItem("Payment", claim_payment, Colors.green),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFinancialItem("Excluded", claim_excluded, Colors.red),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFinancialItem("Balance", (double.tryParse(claim_amount) ?? 0 - (double.tryParse(claim_payment) ?? 0) - (double.tryParse(claim_excluded) ?? 0)).toStringAsFixed(2), Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(String label, String amount, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 11,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "PKR $amount",
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCoverageCard() {
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.checklist,
                  size: 20,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Benefits Coverage",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 15,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildBenefitCoverageItem("Academic Fee Benefit", isBenefitIncluded(1)),
          _buildBenefitCoverageItem("Uniform and Books/Stationery Benefit", isBenefitIncluded(2)),
          _buildBenefitCoverageItem("Transport Benefit", isBenefitIncluded(3)),
          _buildBenefitCoverageItem("Stipend Benefit", isBenefitIncluded(4)),
          _buildBenefitCoverageItem("Hostel and Mess Benefit", isBenefitIncluded(5)),
        ],
      ),
    );
  }

  Widget _buildBenefitCoverageItem(String title, bool included) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: included ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              included ? Icons.check_circle : Icons.cancel,
              size: 18,
              color: included ? Colors.green : Colors.grey,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: included ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              included ? "Included" : "Excluded",
              style: TextStyle(
                color: included ? Colors.green : Colors.grey,
                fontSize: 10,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicFeeBenefitCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 2,
        ),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  size: 20,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Academic Fee Benefit (BNF1)",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Included",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildFeeItem("Tuition Fee", tuition_fee),
          _buildFeeItem("Registration Fee", registration_fee),
          _buildFeeItem("Prospectus Fee", prospectus_fee),
          _buildFeeItem("Security Fee", security_fee),
          _buildFeeItem("Library Fee", library_fee),
          _buildFeeItem("Examination Fee", examination_fee),
          _buildFeeItem("Computer Fee", computer_fee),
          _buildFeeItem("Sports Fee", sports_fee),
          _buildFeeItem("Washing Charges", washing_fee),
          _buildFeeItem("Development", development),
          _buildFeeItem("Outstanding Fee", outstanding_fee),
          _buildFeeItem("Adjustment", adjustment),
          _buildFeeItem("Reimbursement", reimbursement),
          _buildFeeItem("Tax Amount", tax_amount),
          _buildFeeItem("Late Fee Fine", late_fee_fine),
          _buildFeeItem("Other Fine", other_fine),
          _buildFeeItem("Other Charges", other_charges),
          
          if (remarks_1 != "-" && remarks_1.isNotEmpty)
            SizedBox(height: 12),
          if (remarks_1 != "-" && remarks_1.isNotEmpty)
            _buildRemarkItem("Fine Remarks", remarks_1),
          if (remarks_2 != "-" && remarks_2.isNotEmpty)
            _buildRemarkItem("Charges Remarks", remarks_2),
          
          SizedBox(height: 16),
          _buildDocumentsSection([
            {"title": "Application Form", "doc": application_form},
            {"title": "Result Card", "doc": result_card},
            {"title": "Fee Structure", "doc": fee_structure},
            {"title": "Fee Voucher", "doc": fee_voucher},
          ]),
        ],
      ),
    );
  }

  Widget _buildUniformBooksBenefitCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 2,
        ),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.menu_book,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Uniform & Books/Stationery Benefit (BNF2)",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Included",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildFeeItem("Uniform Charges", uniform_charges),
          _buildFeeItem("Books/Stationery Charges", supplies_charges),
          
          if (essentials_remarks != "-" && essentials_remarks.isNotEmpty)
            SizedBox(height: 12),
          if (essentials_remarks != "-" && essentials_remarks.isNotEmpty)
            _buildRemarkItem("Description", essentials_remarks),
          
          SizedBox(height: 16),
          _buildDocumentsSection([
            {"title": "Uniform Voucher", "doc": uniform_voucher},
            {"title": "Books/Stationery Voucher", "doc": supplies_voucher},
          ]),
        ],
      ),
    );
  }

  Widget _buildTransportBenefitCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 2,
        ),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_bus,
                  size: 20,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Transport Benefit (BNF3)",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Included",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildFeeItem("Transport Type", transport_type != "-" ? transport_type : "N/A"),
          _buildFeeItem("Travel Distance", travel_distance + " Km"),
          _buildFeeItem("Transport Cost", transport_cost),
          
          SizedBox(height: 16),
          _buildDocumentsSection([
            {"title": "Transport Voucher", "doc": transport_voucher},
          ]),
        ],
      ),
    );
  }

  Widget _buildStipendBenefitCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 2,
        ),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.money,
                  size: 20,
                  color: Colors.purple,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Stipend Benefit (BNF4)",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Included",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildFeeItem("Stipend Amount", stipend_amount),
          _buildFeeItem("Stipend Category", stipend_category != "-" ? stipend_category : "N/A"),
          
          if (stipend_remarks != "-" && stipend_remarks.isNotEmpty)
            SizedBox(height: 12),
          if (stipend_remarks != "-" && stipend_remarks.isNotEmpty)
            _buildRemarkItem("Description", stipend_remarks),
        ],
      ),
    );
  }

  Widget _buildHostelMessBenefitCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.teal.withOpacity(0.3),
          width: 2,
        ),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.hotel,
                  size: 20,
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Hostel & Mess Benefit (BNF5)",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Included",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildFeeItem("Hostel Rent", hostel_rent),
          _buildFeeItem("Mess Charges", mess_charges),
          
          if (hostel_remarks != "-" && hostel_remarks.isNotEmpty)
            SizedBox(height: 12),
          if (hostel_remarks != "-" && hostel_remarks.isNotEmpty)
            _buildRemarkItem("Description", hostel_remarks),
          
          SizedBox(height: 16),
          _buildDocumentsSection([
            {"title": "Hostel Voucher", "doc": hostel_voucher},
          ]),
        ],
      ),
    );
  }

  Widget _buildPaymentInformationCard() {
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payment,
                  size: 20,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Payment Information",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 15,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          _buildInfoRow("Payment Gateway", claim_gateway, "Term Frequency", term_frequency != "-" ? term_frequency : "N/A"),
          if (reference_number != "-" && reference_number.isNotEmpty && reference_number != "null")
            SizedBox(height: 12),
          if (reference_number != "-" && reference_number.isNotEmpty && reference_number != "null")
            _buildInfoRow("Reference Number", reference_number, "Bank Status", bank_status != "-" ? bank_status : "N/A"),
        ],
      ),
    );
  }

  Widget _buildFeeItem(String label, String value) {
    // Format the value for currency fields
    String displayValue = value;
    if (double.tryParse(value) != null) {
      displayValue = "PKR $value";
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 12,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarkItem(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorDarkGray.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(List<Map<String, String>> documents) {
    // Filter out documents that don't exist
    final List<Map<String, String>> validDocs = documents.where((doc) {
      final docPath = doc["doc"];
      return docPath != null && 
             docPath != "" && 
             docPath != "NULL" && 
             docPath != "null" && 
             docPath != "N/A";
    }).toList();

    if (validDocs.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Documents",
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: 12,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: validDocs.length,
          itemBuilder: (context, index) {
            final doc = validDocs[index];
            final docPath = doc["doc"] ?? "";

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(constants.getImageBaseURL() + docPath),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.colors.newPrimary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage(
                          image: NetworkImage(constants.getImageBaseURL() + docPath),
                          placeholder: AssetImage("archive/images/no_image.jpg"),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey.withOpacity(0.1),
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey.withOpacity(0.5),
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            doc["title"] ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 10,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.visibility,
                            size: 14,
                            color: AppTheme.colors.newPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 13,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 13,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        GetEducationalClaimDetail();
      }
    });
  }

  void GetEducationalClaimDetail() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      
      String userId = UserSessions.instance.getUserID;
      var url = constants.getApiBaseURL() + constants.claims + "educational_detail/" + userId + "/" + widget.claimID;
      
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
      
      if (responseCodeModel.status == true) {
        try {
          var bodyData = jsonDecode(response.body);
          String code = bodyData["Code"]?.toString() ?? "0";
          
          if (code == "1") {
            var body = bodyData["Data"];
            
            // Parse all fields from API response
            setState(() {
              // Basic Info
              claim_id = body["claim_id"]?.toString() ?? "";
              support_type = body["support_type"]?.toString() ?? "-";
              beneficiary = body["beneficiary"]?.toString() ?? "-";
              start_date = body["start_date"]?.toString() ?? "-";
              end_date = body["end_date"]?.toString() ?? "-";
              claim_stage = body["claim_stage"]?.toString() ?? "-";
              claim_gateway = body["claim_gateway"]?.toString() ?? "-";
              reference_number = body["reference_number"]?.toString() ?? "";
              bank_status = body["bank_status"]?.toString() ?? "";
              created_at = body["created_at"]?.toString() ?? "-";
              term_frequency = body["term_frequency"]?.toString() ?? "";
              
              // Financial
              claim_amount = body["claim_amount"]?.toString() ?? "0.00";
              claim_payment = body["claim_payment"]?.toString() ?? "0.00";
              claim_excluded = body["claim_excluded"]?.toString() ?? "0.00";
              
              // User Information
              user_name = body["user_name"]?.toString() ?? "-";
              user_cnic = body["user_cnic"]?.toString() ?? "-";
              user_email = body["user_email"]?.toString() ?? "-";
              user_contact = body["user_contact"]?.toString() ?? "-";
              user_gender = body["user_gender"]?.toString() ?? "-";
              user_image = body["user_image"]?.toString() ?? "-";
              user_scale = body["user_scale"]?.toString() ?? "-";
              user_about = body["user_about"]?.toString() ?? "-";
              
              // Company & Employee Information
              comp_name = body["comp_name"]?.toString() ?? "-";
              role_name = body["role_name"]?.toString() ?? "-";
              sector_name = body["sector_name"]?.toString() ?? "-";
              emp_father = body["emp_father"]?.toString() ?? "-";
              emp_about = body["emp_about"]?.toString() ?? "-";
              emp_address = body["emp_address"]?.toString() ?? "-";
              emp_bank = body["emp_bank"]?.toString() ?? "-";
              emp_title = body["emp_title"]?.toString() ?? "-";
              emp_account = body["emp_account"]?.toString() ?? "-";
              
              // Location
              city_name = body["city_name"]?.toString() ?? "-";
              district_name = body["district_name"]?.toString() ?? "-";
              state_name = body["state_name"]?.toString() ?? "-";
              
              // Child Information
              child_name = body["child_name"]?.toString() ?? "-";
              child_cnic = body["child_cnic"]?.toString() ?? "-";
              child_gender = body["child_gender"]?.toString() ?? "-";
              child_image = body["child_image"]?.toString() ?? "-";
              
              // School Information
              school_name = body["school_name"]?.toString() ?? "-";
              school_panel = body["school_panel"]?.toString() ?? "-";
              school_email = body["school_email"]?.toString() ?? "-";
              school_contact = body["school_contact"]?.toString() ?? "-";
              school_fax_no = body["school_fax_no"]?.toString() ?? "-";
              school_type = body["school_type"]?.toString() ?? "-";
              school_bank = body["school_bank"]?.toString() ?? "-";
              school_title = body["school_title"]?.toString() ?? "-";
              school_nature = body["school_nature"]?.toString() ?? "-";
              school_account = body["school_account"]?.toString() ?? "-";
              school_code = body["school_code"]?.toString() ?? "-";
              
              // Education Information
              edu_nature = body["edu_nature"]?.toString() ?? "-";
              edu_level = body["edu_level"]?.toString() ?? "-";
              edu_degree = body["edu_degree"]?.toString() ?? "-";
              edu_class = body["edu_class"]?.toString() ?? "-";
              edu_started = body["edu_started"]?.toString() ?? "-";
              edu_ended = body["edu_ended"]?.toString() ?? "-";
              edu_living = body["edu_living"]?.toString() ?? "-";
              edu_mess = body["edu_mess"]?.toString() ?? "-";
              edu_transport = body["edu_transport"]?.toString() ?? "-";
              
              // Payment Information
              debit_account = body["debit_account"]?.toString() ?? "-";
              recipient_bank = body["recipient_bank"]?.toString() ?? "-";
              credit_account = body["credit_account"]?.toString() ?? "-";
              credit_amount = body["credit_amount"]?.toString() ?? "-";
              bank_number = body["bank_number"]?.toString() ?? "-";
              transferred_at = body["transferred_at"]?.toString() ?? "-";
              
              // Parse benefit flags
              String claimBenefit = body["claim_benefit"]?.toString() ?? "";
              if (claimBenefit.isNotEmpty && claimBenefit != "null") {
                String cleaned = claimBenefit
                    .replaceAll('{', '')
                    .replaceAll('}', '')
                    .replaceAll('"', '');
                
                List<String> pairs = cleaned.split(',');
                benefitFlags.clear();
                
                for (String pair in pairs) {
                  List<String> parts = pair.split(':');
                  if (parts.length == 2) {
                    String key = parts[0].trim();
                    int value = int.tryParse(parts[1].trim()) ?? 0;
                    benefitFlags[key] = value;
                  }
                }
              }
              
              // Benefit 1: Academic Fee
              tuition_fee = body["tuition_fee"]?.toString() ?? "0.00";
              registration_fee = body["registration_fee"]?.toString() ?? "0.00";
              prospectus_fee = body["prospectus_fee"]?.toString() ?? "0.00";
              security_fee = body["security_fee"]?.toString() ?? "0.00";
              library_fee = body["library_fee"]?.toString() ?? "0.00";
              examination_fee = body["examination_fee"]?.toString() ?? "0.00";
              computer_fee = body["computer_fee"]?.toString() ?? "0.00";
              sports_fee = body["sports_fee"]?.toString() ?? "0.00";
              washing_fee = body["washing_fee"]?.toString() ?? "0.00";
              development = body["development"]?.toString() ?? "0.00";
              outstanding_fee = body["outstanding_fee"]?.toString() ?? "0.00";
              adjustment = body["adjustment"]?.toString() ?? "0.00";
              reimbursement = body["reimbursement"]?.toString() ?? "0.00";
              tax_amount = body["tax_amount"]?.toString() ?? "0.00";
              late_fee_fine = body["late_fee_fine"]?.toString() ?? "0.00";
              other_fine = body["other_fine"]?.toString() ?? "0.00";
              remarks_1 = body["remarks_1"]?.toString() ?? "-";
              other_charges = body["other_charges"]?.toString() ?? "0.00";
              remarks_2 = body["remarks_2"]?.toString() ?? "-";
              application_form = body["application_form"]?.toString() ?? "";
              result_card = body["result_card"]?.toString() ?? "";
              fee_structure = body["fee_structure"]?.toString() ?? "";
              fee_voucher = body["fee_voucher"]?.toString() ?? "";
              
              // Benefit 2: Uniform & Books
              uniform_charges = body["uniform_charges"]?.toString() ?? "0.00";
              supplies_charges = body["supplies_charges"]?.toString() ?? "0.00";
              essentials_remarks = body["essentials_remarks"]?.toString() ?? "-";
              uniform_voucher = body["uniform_voucher"]?.toString() ?? "";
              supplies_voucher = body["supplies_voucher"]?.toString() ?? "";
              
              // Benefit 3: Transport
              transport_type = body["transport_type"]?.toString() ?? "-";
              travel_distance = body["travel_distance"]?.toString() ?? "0.00";
              transport_cost = body["transport_cost"]?.toString() ?? "0.00";
              transport_voucher = body["transport_voucher"]?.toString() ?? "";
              
              // Benefit 4: Stipend
              stipend_amount = body["stipend_amount"]?.toString() ?? "0.00";
              stipend_category = body["stipend_category"]?.toString() ?? "-";
              stipend_remarks = body["stipend_remarks"]?.toString() ?? "-";
              
              // Benefit 5: Hostel & Mess
              hostel_rent = body["hostel_rent"]?.toString() ?? "0.00";
              mess_charges = body["mess_charges"]?.toString() ?? "0.00";
              hostel_voucher = body["hostel_voucher"]?.toString() ?? "";
              hostel_remarks = body["hostel_remarks"]?.toString() ?? "-";
              
              isLoading = false;
              isError = false;
            });
          } else {
            setState(() {
              isError = true;
              errorMessage = Strings.instance.notFound;
              isLoading = false;
            });
            uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
          }
        } catch (e) {
          setState(() {
            isError = true;
            errorMessage = Strings.instance.somethingWentWrong;
            isLoading = false;
          });
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"]?.toString() ?? "";
          
          if (message == constants.expireToken) {
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
                Strings.instance.expireSessionMessage);
          } else if (message.isNotEmpty && message != "null") {
            uiUpdates.ShowToast(message);
          } else {
            uiUpdates.ShowToast(responseCodeModel.message);
          }
        } catch (e) {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
        
        setState(() {
          isError = true;
          errorMessage = responseCodeModel.message;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = Strings.instance.somethingWentWrong;
        isLoading = false;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
