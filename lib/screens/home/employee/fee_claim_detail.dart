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
  String applicationFormDoc="", resultCardDoc="", feeVoucherDoc="", transportVoucherDoc="", hostelVoucherDoc="";
  String for_whom= "-", claim_started= "-", claim_ended= "-", tuition_fee= "-", registration_fee= "-", prospectus_fee= "-", security_fee= "-",
      library_fee= "-", exams_fee= "-", computer_fee= "-", sports_fee= "-", washing_fee= "-", development= "-", fee_arrears= "-", adjustment= "-",
      reimbursment= "-", tax_amount= "-", late_fee_fine= "-", other_fine= "-", other_charges= "-", remarks_1= "-", remarks_2= "-", 
      transport_cost= "-", hostel_rent= "-", mess_charges= "-", created_at= "-", claim_stage= "-", claim_amount= "-";

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
                    // User Info Card
                    _buildUserInfoCard(),
                    SizedBox(height: 16),

                    // Status Card
                    _buildStatusCard(),
                    SizedBox(height: 16),

                    // Claim Period & Amount
                    _buildClaimOverview(),
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
              child: UserSessions.instance.getUserImage != "null" && 
                     UserSessions.instance.getUserImage != "" && 
                     UserSessions.instance.getUserImage != "NULL"
                  ? FadeInImage(
                      image: NetworkImage(constants.getImageBaseURL() + UserSessions.instance.getUserImage),
                      placeholder: AssetImage("archive/images/no_image.jpg"),
                      fit: BoxFit.cover,
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
                  UserSessions.instance.getUserName,
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
                    Text(
                      UserSessions.instance.getUserCNIC,
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
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
              color: AppTheme.colors.colorExelent,
            ),
            child: Text(
              for_whom,
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
                    "$claim_started - $claim_ended",
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
          _buildFeeItem("Exams Fee", exams_fee),
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
          _buildFeeItem("Fee Arrears", fee_arrears, isFirst: true),
          _buildFeeItem("Adjustment", adjustment),
          _buildFeeItem("Reimbursement", reimbursment),
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
          Text(
            label,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "PKR $value",
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
                      doc["doc"] != "N/A";

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

  void GetFeeClaimsDetail() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "fee_info/", 
          UserSessions.instance.getUserID, 
          additionalPath: widget.calim_ID);
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            // API returns Data as object, not array
            var data= body["Data"];
            if(data != null) {
              for_whom= data["for_whom"] != null ? data["for_whom"].toString() : "-";
              claim_started= data["claim_started"] != null ? data["claim_started"].toString() : "-";
              claim_ended= data["claim_ended"] != null ? data["claim_ended"].toString() : "-";
              tuition_fee= data["tuition_fee"] != null ? data["tuition_fee"].toString() : "-";
              registration_fee= data["registration_fee"] != null ? data["registration_fee"].toString() : "-";
              prospectus_fee= data["prospectus_fee"] != null ? data["prospectus_fee"].toString() : "-";
              security_fee= data["security_fee"] != null ? data["security_fee"].toString() : "-";
              library_fee= data["library_fee"] != null ? data["library_fee"].toString() : "-";
              exams_fee= data["exams_fee"] != null ? data["exams_fee"].toString() : "-";
              computer_fee= data["computer_fee"] != null ? data["computer_fee"].toString() : "-";
              sports_fee= data["sports_fee"] != null ? data["sports_fee"].toString() : "-";
              washing_fee= data["washing_fee"] != null ? data["washing_fee"].toString() : "-";
              development= data["development"] != null ? data["development"].toString() : "-";
              fee_arrears= data["fee_arrears"] != null ? data["fee_arrears"].toString() : "-";
              adjustment= data["adjustment"] != null ? data["adjustment"].toString() : "-";
              reimbursment= data["reimbursment"] != null ? data["reimbursment"].toString() : "-";
              tax_amount= data["tax_amount"] != null ? data["tax_amount"].toString() : "-";
              late_fee_fine= data["late_fee_fine"] != null ? data["late_fee_fine"].toString() : "-";
              other_fine= data["other_fine"] != null ? data["other_fine"].toString() : "-";
              other_charges= data["other_charges"] != null ? data["other_charges"].toString() : "-";
              remarks_1= data["remarks_1"] != null ? data["remarks_1"].toString() : "-";
              remarks_2= data["remarks_2"] != null ? data["remarks_2"].toString() : "-";
              transport_cost= data["transport_cost"] != null ? data["transport_cost"].toString() : "-";
              hostel_rent= data["hostel_rent"] != null ? data["hostel_rent"].toString() : "-";
              mess_charges= data["mess_charges"] != null ? data["mess_charges"].toString() : "-";
              created_at= data["created_at"] != null ? data["created_at"].toString() : "-";
              claim_stage= data["claim_stage"] != null ? data["claim_stage"].toString() : "-";
              claim_amount= data["claim_amount"] != null ? data["claim_amount"].toString() : "-";
              applicationFormDoc= data["appeal_form"] != null ? data["appeal_form"].toString() : "";
              resultCardDoc= data["result_card"] != null ? data["result_card"].toString() : "";
              feeVoucherDoc= data["fee_voucher"] != null ? data["fee_voucher"].toString() : "";
              transportVoucherDoc= data["transport_voucher"] != null ? data["transport_voucher"].toString() : "";
              hostelVoucherDoc= data["hostel_voucher"] != null ? data["hostel_voucher"].toString() : "";

              setState(() {
              });
            } else {
              uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
            }
          } else {
            String message = body["Message"] != null ? body["Message"].toString() : "";
            if(message.isNotEmpty && message != "null") {
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
          
          if(message == constants.expireToken){
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          }else if(message.isNotEmpty && message != "null"){
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}

