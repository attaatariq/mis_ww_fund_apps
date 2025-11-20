import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/educational_claim_list_item.dart';
import 'package:wwf_apps/models/EducationalClaimModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/home/employee/create_educational_claim.dart';
import 'package:wwf_apps/screens/home/employee/educational_claim_detail.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/models/ClaimStageModel.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/network/api_service.dart';


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
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  // Load claim stages from information API if not already loaded
  Future<void> LoadClaimStagesIfNeeded() async {
    // Only load if claim stages are not already available
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
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,
              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text("Educational Claims",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 14,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                      InkWell(
                        onTap: () {
                          CheckEducationDetail();
                        },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.add_box_outlined, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),
                  ],
                ),
              ),
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
                                "Create your first educational claim",
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

  void GetCEducationClaims() async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      }
      
      // Format: /uri/endpoint/{user_id}/E/{emp_id}
      String userId = UserSessions.instance.getUserID;
      String empId = UserSessions.instance.getEmployeeID;
      
      // If emp_id is empty, try to fetch from information API
      if (empId.isEmpty || empId == "") {
        empId = await _fetchEmployeeID();
      }
      
      if (empId.isEmpty || empId == "") {
        setState(() {
          isError = true;
          errorMessage = "Employee ID not found. Please try again.";
          isLoading = false;
        });
        uiUpdates.DismissProgresssDialog();
        return;
      }
      
      var url = constants.getApiBaseURL() + constants.claims + "educational_claim/" + userId + "/E/" + empId;
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            dynamic dataField = body["Data"];
            List<dynamic> claimsData = [];
            
            // Handle different response structures
            if (dataField != null) {
              if (dataField is List) {
                claimsData = dataField;
              } else if (dataField is Map) {
                // If Data is a map, try to extract a list from it
                if (dataField.containsKey("claims") && dataField["claims"] is List) {
                  claimsData = dataField["claims"];
                } else if (dataField.containsKey("data") && dataField["data"] is List) {
                  claimsData = dataField["data"];
                }
              }
            }
            
            educationClaimsList.clear();
            
            // Handle case where Data might be null or not a list
            if (claimsData != null && claimsData is List && claimsData.length > 0) {
              claimsData.forEach((row) {
                if (row != null && row is Map) {
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
                }
              });

              if (educationClaimsList.length > 0) {
                setState(() {
                  isError = false;
                  isLoading = false;
                });
              } else {
                setState(() {
                  isError = true;
                  errorMessage = "No educational claims found.";
                  isLoading = false;
                });
              }
            } else {
              setState(() {
                isError = true;
                errorMessage = "No educational claims available.";
                isLoading = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null" && message != "NULL") {
              uiUpdates.ShowToast(message);
              setState(() {
                isError = true;
                errorMessage = message;
                isLoading = false;
              });
            } else {
              setState(() {
                isError = true;
                errorMessage = "No educational claims found.";
                isLoading = false;
              });
            }
          }
        } catch (e) {
          setState(() {
            isError = true;
            errorMessage = "Failed to parse response: ${e.toString()}";
            isLoading = false;
          });
          uiUpdates.ShowToast("Failed to load educational claims. Please try again.");
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
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

  Future<String> _fetchEmployeeID() async {
    try {
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 15));
      
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      } else {
        // Load claim stages before loading claims
        LoadClaimStagesIfNeeded().then((_) {
          GetCEducationClaims();
        });
      }
    });
  }

  void CheckEducationDetail() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "edu_check/", 
          UserSessions.instance.getUserID, 
          additionalPath: "emp_id--" + UserSessions.instance.getRefID);
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
            if(data != null){
              String edu_living= data["edu_living"]?.toString() ?? "0";
              String edu_mess= data["edu_mess"]?.toString() ?? "0";
              String edu_transport= data["edu_transport"]?.toString() ?? "0";
              String edu_nature= data["edu_nature"]?.toString() ?? "";
              String edu_level= data["edu_level"]?.toString() ?? "";
              String stip_amount= data["stip_amount"]?.toString() ?? "0";

              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      CreateFeeClaim(
                          edu_living, edu_mess, edu_transport, edu_nature,
                          edu_level, stip_amount)
              ));
            }else{
              // Navigate anyway with default values - allows adding child claims
              String defaultValue = "0";
              String defaultString = "";
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      CreateFeeClaim(
                          defaultValue, defaultValue, defaultValue, defaultString,
                          defaultString, defaultValue)
              ));
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if(message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            } else {
              // Navigate anyway with default values
              String defaultValue = "0";
              String defaultString = "";
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      CreateFeeClaim(
                          defaultValue, defaultValue, defaultValue, defaultString,
                          defaultString, defaultValue)
              ));
            }
          }
        } catch (e) {
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    } catch (e) {
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      uiUpdates.DismissProgresssDialog();
    }
  }
}
