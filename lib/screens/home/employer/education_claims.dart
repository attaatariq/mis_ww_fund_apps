import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/EducationalClaimModel.dart';
import 'package:wwf_apps/screens/home/employee/educational_claim_detail.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../network/api_service.dart';
import '../../../views/educational_claim_list_item.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../models/ClaimStageModel.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/standard_header.dart';

class EducationClaimList extends StatefulWidget {
  @override
  _EducationClaimListState createState() => _EducationClaimListState();
}

class _EducationClaimListState extends State<EducationClaimList> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError = false;
  String errorMessage = "";
  List<EducationalClaimModel> educationClaimsList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
  }

  // Load claim stages from information API if not already loaded
  Future<void> LoadClaimStagesIfNeeded() async {
    if (!ClaimStagesData.instance.hasStages()) {
      try {
        List<String> tagsList = [constants.accountInfo];
        Map data = {
          "user_id": UserSessions.instance.getUserID,
          "api_tags": jsonEncode(tagsList).toString(),
        };
        var url = constants.getApiBaseURL() + constants.authentication + "information";
        var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
        ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
        if (responseCodeModel.status == true) {
          var body = jsonDecode(response.body);
          String code = body["Code"]?.toString() ?? "0";
          if (code == "1") {
            var dataObj = body["Data"];
            ClaimStagesData.loadFromInformationResponse(dataObj);
          }
        }
      } catch (e) {
        // Silently fail - claim stages might be loaded from login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            StandardHeader(
              title: "Educational Claims",
              subtitle: educationClaimsList.isNotEmpty
                  ? "${educationClaimsList.length} ${educationClaimsList.length == 1 ? 'Claim' : 'Claims'}"
                  : null,
            ),

            // Content
            Expanded(
              child: isError && educationClaimsList.isEmpty
                  ? EmptyStates.noClaims(type: 'Education')
                  : educationClaimsList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 80,
                                color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Educational Claims",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 16,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No educational claims found",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                                  fontSize: 14,
                                  fontFamily: "AppFont",
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            educationClaimsList.clear();
                            await Future.delayed(Duration(milliseconds: 500));
                            CheckTokenExpiry();
                          },
                          color: AppTheme.colors.newPrimary,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          itemBuilder: (_, int index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EducationalClaimDetail(educationClaimsList[index].claim_id),
                                ),
                              );
                            },
                            child: EducationalClaimListItem(constants, educationClaimsList[index]),
                          ),
                            itemCount: educationClaimsList.length,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      } else {
        // Load claim stages before loading claims
        LoadClaimStagesIfNeeded().then((_) {
          GetEducationClaims();
        });
      }
    });
  }

  void GetEducationClaims() async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      }
      
      // Format: /uri/endpoint/{user_id}/C/{comp_id}
      String userId = UserSessions.instance.getUserID;
      String compId = UserSessions.instance.getRefID; // comp_id for employer
      var url = constants.getApiBaseURL() + constants.claims + "educational_claim/" + userId + "/C/" + compId;
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            List<dynamic> claimsData = body["Data"] ?? [];
            educationClaimsList.clear();
            
            if (claimsData.length > 0) {
              claimsData.forEach((row) {
                EducationalClaimModel claim = EducationalClaimModel(
                  // Basic Info
                  claim_id: row["claim_id"]?.toString() ?? "",
                  beneficiary: row["beneficiary"]?.toString() ?? "",
                  start_date: row["start_date"]?.toString() ?? "",
                  end_date: row["end_date"]?.toString() ?? "",
                  claim_stage: row["claim_stage"]?.toString() ?? "",
                  claim_gateway: row["claim_gateway"]?.toString() ?? "",
                  reference_number: row["reference_number"]?.toString() ?? "",
                  bank_status: row["bank_status"]?.toString() ?? "",
                  created_at: row["created_at"]?.toString() ?? "",
                  
                  // Financial
                  claim_amount: row["claim_amount"]?.toString() ?? "",
                  claim_payment: row["claim_payment"]?.toString() ?? "",
                  claim_excluded: row["claim_excluded"]?.toString() ?? "",
                  
                  // User Information
                  user_name: row["user_name"]?.toString() ?? "",
                  user_cnic: row["user_cnic"]?.toString() ?? "",
                  user_gender: row["user_gender"]?.toString() ?? "",
                  user_image: row["user_image"]?.toString() ?? "",
                  
                  // Child Information (when beneficiary = "Child")
                  child_name: row["child_name"]?.toString() ?? "",
                  child_cnic: row["child_cnic"]?.toString() ?? "",
                  child_gender: row["child_gender"]?.toString() ?? "",
                  child_image: row["child_image"]?.toString() ?? "",
                );
                
                educationClaimsList.add(claim);
              });

              setState(() {
                isError = false;
                isLoading = false;
              });
            } else {
              setState(() {
                isError = true;
                errorMessage = Strings.instance.notFound;
                isLoading = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            }
            setState(() {
              isError = true;
              errorMessage = Strings.instance.notFound;
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
        }
      } else {
        uiUpdates.ShowError(responseCodeModel.message);
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

