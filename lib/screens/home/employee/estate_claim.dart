import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/pay_installment_dialog_model.dart';
import 'package:wwf_apps/views/installment_item.dart';
import 'package:wwf_apps/models/EstateClaimModel.dart';
import 'package:wwf_apps/models/InstallmentModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/utils/claim_stages_helper.dart';

class EstateClaim extends StatefulWidget {
  @override
  _EstateClaimState createState() => _EstateClaimState();
}

class _EstateClaimState extends State<EstateClaim> {
  String claim_balloting="-", claim_scheme="-", scheme_name="-", claim_location="-", claim_quota="-", claim_dated="-", claim_abode="-", claim_number="-", claim_floor="-",
      claim_street="-", claim_block="-", claim_impound="-", claim_amount="-", claim_payment="-", claim_balance="-", created_at="-", claim_stage="-";
  String user_name="-", user_image="-", user_cnic="-", user_gender="-";
  String claim_id = ""; // Store claim ID for fetching installments
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  bool hasEstateData = false;
  bool hasInstallmentError = false;
  String installmentErrorMessage = "";
  List<InstallmentModel> list= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetEstateClaim();
  }

  void parentFunction()
  {
    GetEstateClaim();
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
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Estate Claim",
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
                ? Center(
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
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        isError = false;
                        list.clear();
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      CheckTokenExpiry();
                    },
                    color: AppTheme.colors.newPrimary,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // User Info Card
                            if (hasEstateData) _buildUserInfoCard(),
                            if (hasEstateData) SizedBox(height: 16),

                            // Status Card (if claim_stage is available)
                            if (hasEstateData && claim_stage != "-" && claim_stage.isNotEmpty)
                              ClaimStagesHelper.buildDetailStatusCard(claim_stage),
                            if (hasEstateData && claim_stage != "-" && claim_stage.isNotEmpty)
                              SizedBox(height: 12),
                            
                            // Submission Date Card
                            if (hasEstateData && created_at != "-" && created_at.isNotEmpty)
                              _buildSubmissionDateCard(),
                            if (hasEstateData && created_at != "-" && created_at.isNotEmpty)
                              SizedBox(height: 16),

                            // Estate Overview Card
                            if (hasEstateData) _buildEstateOverviewCard(),
                            if (hasEstateData) SizedBox(height: 16),

                            // Estate Details Card
                            if (hasEstateData) _buildEstateDetailsCard(),
                            if (hasEstateData) SizedBox(height: 16),

                            // Financial Summary Card
                            if (hasEstateData) _buildFinancialSummaryCard(),
                            if (hasEstateData) SizedBox(height: 16),

                            // Installments Section
                            if (hasEstateData) ...[
                              _buildSectionHeader("Installments", Icons.receipt_long),
                              SizedBox(height: 12),
                              if (list.isNotEmpty)
                                ...list.map((installment) => Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: InstallmentItem(installment, parentFunction),
                                )).toList(),
                              if (list.isEmpty)
                                Container(
                                  padding: EdgeInsets.all(24),
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
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 48,
                                        color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'No Installments Available',
                                        style: TextStyle(
                                          color: AppTheme.colors.colorDarkGray,
                                          fontSize: 14,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        installmentErrorMessage.isNotEmpty 
                                            ? installmentErrorMessage 
                                            : 'There are no installments for this estate claim.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                                          fontSize: 12,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }

  void GetEstateClaim() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      // Format: /claims/estate_claim/{user_id}/E/{emp_id}
      String userId = UserSessions.instance.getUserID;
      String empId = UserSessions.instance.getEmployeeID;
      var url = constants.getApiBaseURL() + constants.claims + "estate_claim/" + userId + "/E/" + empId;
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var data= body["Data"];
            // API returns an array - employee gets first item (single claim)
            if(data != null) {
              List<dynamic> estateList = data is List ? data : [];
              if(estateList.isNotEmpty) {
                var estateData = estateList[0]; // Get first claim for employee
                
                claim_balloting= estateData["claim_balloting"]?.toString() ?? "-";
                claim_scheme= estateData["claim_scheme"]?.toString() ?? "-";
                scheme_name= estateData["scheme_name"]?.toString() ?? "-";
                claim_location= estateData["claim_location"]?.toString() ?? "-";
                claim_quota= estateData["claim_quota"]?.toString() ?? "-";
                claim_dated= estateData["claim_dated"]?.toString() ?? "-";
                claim_abode= estateData["claim_abode"]?.toString() ?? "-";
                claim_number= estateData["claim_number"]?.toString() ?? "-";
                claim_floor= estateData["claim_floor"]?.toString() ?? "-";
                claim_street= estateData["claim_street"]?.toString() ?? "-";
                claim_block= estateData["claim_block"]?.toString() ?? "-";
                claim_impound= estateData["claim_impound"]?.toString() ?? "-";
                claim_amount= estateData["claim_amount"]?.toString() ?? "-";
                claim_payment= estateData["claim_payment"]?.toString() ?? "-";
                claim_balance= estateData["claim_balance"]?.toString() ?? "-";
                claim_id = estateData["claim_id"]?.toString() ?? "";
                // created_at and claim_stage will be fetched from estate_detail API
                created_at = "-";
                claim_stage = "-";
                
                // User info from estate_claim API (if available)
                user_name = estateData["user_name"]?.toString() ?? "-";
                user_image = estateData["user_image"]?.toString() ?? "-";
                user_cnic = estateData["user_cnic"]?.toString() ?? "-";
                user_gender = estateData["user_gender"]?.toString() ?? "-";

                setState(() {
                  hasEstateData = true;
                  isError= false;
                });
                
                // Now fetch full details (user info, claim_stage, created_at, installments) from estate_detail API
                if (claim_id.isNotEmpty) {
                  GetEstateInstallments(claim_id);
                } else {
                  setState(() {
                    hasEstateData = true;
                    hasInstallmentError = true;
                    installmentErrorMessage = Strings.instance.notFound;
                  });
                }
              } else {
                setState(() {
                  hasEstateData = false;
                  isError= true;
                  errorMessage = Strings.instance.notFound;
                });
              }
            } else {
              setState(() {
                hasEstateData = false;
                isError= true;
                errorMessage = Strings.instance.notFound;
              });
            }
          } else {
            setState(() {
              hasEstateData = false;
              isError= true;
              errorMessage = Strings.instance.notFound;
            });
          }
        } catch (e) {
          setState(() {
            hasEstateData = false;
            isError= true;
            errorMessage = Strings.instance.notFound;
          });
        }
      } else {
        if(responseCodeModel.message != null && responseCodeModel.message != "null") {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
        setState(() {
          hasEstateData = false;
          isError= true;
          errorMessage = Strings.instance.notFound;
        });
      }
    } catch (e) {
      setState(() {
        hasEstateData = false;
        isError= true;
        errorMessage = Strings.instance.notFound;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      // Add small delay to ensure dialog is shown before dismissing
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }

  void GetEstateInstallments(String claimId) async {
    try {
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "estate_detail/", 
          UserSessions.instance.getUserID,
          additionalPath: claimId);
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var data = body["Data"];
            if(data != null) {
              // Update user information and claim stage from estate_detail API
              if (data["user_name"] != null) user_name = data["user_name"]?.toString() ?? user_name;
              if (data["user_image"] != null) user_image = data["user_image"]?.toString() ?? user_image;
              if (data["user_cnic"] != null) user_cnic = data["user_cnic"]?.toString() ?? user_cnic;
              if (data["user_gender"] != null) user_gender = data["user_gender"]?.toString() ?? user_gender;
              if (data["created_at"] != null) created_at = data["created_at"]?.toString() ?? created_at;
              if (data["claim_stage"] != null) claim_stage = data["claim_stage"]?.toString() ?? claim_stage;
              
              // Parse installments - check both "instalments" and "installments" (API might use either)
              List<dynamic> instalments = [];
              if (data["instalments"] != null) {
                instalments = data["instalments"] is List ? data["instalments"] : [];
              } else if (data["installments"] != null) {
                instalments = data["installments"] is List ? data["installments"] : [];
              }
              
              if (instalments.length > 0) {
                list.clear();
                instalments.forEach((row) {
                  if (row != null) {
                    String ins_id = row["ins_id"]?.toString() ?? "";
                    String ins_number = row["ins_number"]?.toString() ?? "";
                    String ins_amount = row["ins_amount"]?.toString() ?? "";
                    String ins_payment = row["ins_payment"]?.toString() ?? "";
                    String ins_balance = row["ins_balance"]?.toString() ?? "";
                    String ins_duedate = row["ins_duedate"]?.toString() ?? "";
                    String deposited_at = row["deposited_at"]?.toString() ?? "";
                    String ins_bank_name = row["ins_bank_name"]?.toString() ?? "";
                    String ins_challan_no = row["ins_challan_no"]?.toString() ?? "";
                    String ins_challan = row["ins_challan"]?.toString() ?? "";
                    String ins_remarks = row["ins_remarks"]?.toString() ?? "";
                    String created_at = row["created_at"]?.toString() ?? "";
                    list.add(new InstallmentModel(ins_id, ins_number, ins_amount, ins_payment, ins_balance, ins_duedate, deposited_at, ins_bank_name, ins_challan_no, ins_challan, ins_remarks, created_at));
                  }
                });

                setState(() {
                  hasInstallmentError = false;
                });
              } else {
                setState(() {
                  hasInstallmentError = false; // Don't show error, just empty state
                  installmentErrorMessage = "No installments available for this estate claim.";
                });
              }
            } else {
              setState(() {
                hasInstallmentError = false;
                installmentErrorMessage = "No installments available for this estate claim.";
              });
            }
          } else {
            setState(() {
              hasInstallmentError = false;
              installmentErrorMessage = "No installments available for this estate claim.";
            });
          }
        } catch (e) {
          setState(() {
            hasInstallmentError = false;
            installmentErrorMessage = "No installments available for this estate claim.";
          });
        }
      } else {
        setState(() {
          hasInstallmentError = false;
          installmentErrorMessage = "No installments available for this estate claim.";
        });
      }
    } catch (e) {
      setState(() {
        hasInstallmentError = false;
        installmentErrorMessage = "No installments available for this estate claim.";
      });
    }
  }

  // Helper Methods for Professional UI (same as estate_claim_detail.dart)

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
              child: user_image != "null" &&
                  user_image != "" &&
                  user_image != "NULL" &&
                  user_image != "-" &&
                  user_image != "N/A"
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
                  user_name != "-" ? user_name : "Estate Claim",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 16,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user_cnic != "-" && user_cnic.isNotEmpty)
                  SizedBox(height: 4),
                if (user_cnic != "-" && user_cnic.isNotEmpty)
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
              "Estate Claim",
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

  Widget _buildEstateOverviewCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.colors.newPrimary,
            AppTheme.colors.newPrimary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.home_work,
                color: AppTheme.colors.newWhite,
                size: 32,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scheme Name",
                      style: TextStyle(
                        color: AppTheme.colors.newWhite.withOpacity(0.9),
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      scheme_name != "-" ? scheme_name : claim_scheme,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 16,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppTheme.colors.newWhite.withOpacity(0.3), height: 1),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balloting Date",
                      style: TextStyle(
                        color: AppTheme.colors.newWhite.withOpacity(0.9),
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      claim_balloting != "-" ? claim_balloting : "N/A",
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Allotment Date",
                      style: TextStyle(
                        color: AppTheme.colors.newWhite.withOpacity(0.9),
                        fontSize: 11,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      claim_dated != "-" ? claim_dated : "N/A",
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
          ),
        ],
      ),
    );
  }

  Widget _buildEstateDetailsCard() {
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
          _buildSectionSubHeader("Estate Details", Icons.info_outline),
          SizedBox(height: 16),
          _buildInfoRow("Quota", claim_quota, "Location", claim_location),
          if (claim_quota != "-" || claim_location != "-") SizedBox(height: 12),
          _buildInfoRow("Abode Type", claim_abode, "Unit Number", claim_number),
          if (claim_abode != "-" || claim_number != "-") SizedBox(height: 12),
          _buildInfoRow("Floor", claim_floor, "Street", claim_street),
          if (claim_floor != "-" || claim_street != "-") SizedBox(height: 12),
          _buildInfoRow("Block", claim_block, "Possession Date", claim_impound),
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
          _buildSectionSubHeader("Financial Summary", Icons.account_balance_wallet),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.colors.newPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildFinancialRow("Total Amount", claim_amount, true),
                SizedBox(height: 12),
                Divider(height: 1),
                SizedBox(height: 12),
                _buildFinancialRow("Amount Paid", claim_payment, false),
                SizedBox(height: 12),
                Divider(height: 1),
                SizedBox(height: 12),
                _buildFinancialRow("Remaining Balance", claim_balance, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String amount, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: 13,
            fontFamily: "AppFont",
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount != "-" ? amount + " PKR" : "N/A",
          style: TextStyle(
            color: isBold ? AppTheme.colors.newPrimary : AppTheme.colors.newBlack,
            fontSize: 14,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    if ((value1.isEmpty || value1 == "-") && (value2.isEmpty || value2 == "-")) {
      return SizedBox.shrink();
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                (value1.isEmpty || value1 == "-") ? "N/A" : value1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: (value1.isEmpty || value1 == "-") ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                (value2.isEmpty || value2 == "-") ? "N/A" : value2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: (value2.isEmpty || value2 == "-") ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.colors.newPrimary,
        ),
        SizedBox(width: 8),
        Text(
          title + (list.isNotEmpty ? " (${list.length})" : ""),
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 16,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionSubHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.colors.newPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.colors.newPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.colors.newPrimary,
          ),
          SizedBox(width: 8),
          Text(
            title,
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

  Widget _buildSubmissionDateCard() {
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
                created_at != "-" ? created_at : "N/A",
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
    );
  }
}
