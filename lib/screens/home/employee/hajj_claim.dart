import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/viewer/ImageViewer.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/hajj_claim_item.dart';
import 'package:wwf_apps/models/HajjClaimModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;

class HajjClaim extends StatefulWidget {
  @override
  _HajjClaimState createState() => _HajjClaimState();
}

class _HajjClaimState extends State<HajjClaim> {
  Constants constants;
  UIUpdates uiUpdates;
  String reciptDocURL="";
  bool isError= false;
  List<HajjClaimModel> list = [];
  String errorMessage="";

  @override
  void initState() {
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Hajj Claim",
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
                    child: list.isEmpty
                        ? Center(
                            child: EmptyStates.noClaims(type: 'Hajj'),
                          )
                        : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
                                ...list.map((claim) => HajjClaimItem(constants, claim)).toList(),
                              ],
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
      }else{
        GetHajjClaim();
      }
    });
  }

  void GetHajjClaim() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      // Format: /claims/hajj_claim/{user_id}/E/{emp_id}
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
        });
        uiUpdates.DismissProgresssDialog();
        return;
      }
      
      var url = constants.getApiBaseURL() + constants.claims + "hajj_claim/" + userId + "/E/" + empId;
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
            List<dynamic> claims = [];
            
            // Handle different response structures
            if (dataField != null) {
              if (dataField is List) {
                claims = dataField;
              } else if (dataField is Map) {
                // If Data is a map, try to extract a list from it
                if (dataField.containsKey("claims") && dataField["claims"] is List) {
                  claims = dataField["claims"];
                } else if (dataField.containsKey("data") && dataField["data"] is List) {
                  claims = dataField["data"];
                }
              }
            }
            
            // Employee gets single record (first item)
            if (claims != null && claims is List && claims.length > 0) {
              list.clear();
              var element = claims[0]; // Get first claim for employee
              if (element != null && element is Map) {
                String claim_year = element["claim_year"]?.toString() ?? "";
                String claim_receipt = element["claim_receipt"]?.toString() ?? "";
                String claim_amount = element["claim_amount"]?.toString() ?? "";
                String created_at = element["created_at"]?.toString() ?? "";
                String user_name = element["user_name"]?.toString() ?? "";
                String comp_name = element["comp_name"]?.toString() ?? "";
                
                list.add(new HajjClaimModel(claim_year, claim_receipt, claim_amount, created_at, user_name, comp_name));

                setState(() {
                  isError = false;
                  errorMessage = "";
                });
              } else {
                setState(() {
                  isError = true;
                  errorMessage = "Invalid data format received.";
                });
              }
            } else {
              setState(() {
                isError = true;
                errorMessage = "No Hajj claims found.";
              });
            }
          } else {
            String message = body["Message"] != null ? body["Message"].toString() : Strings.instance.notAvail;
            setState(() {
              isError= true;
              errorMessage = message;
            });
          }
        } catch (e) {
          setState(() {
            isError = true;
            errorMessage = "Failed to parse response: ${e.toString()}";
          });
          uiUpdates.ShowToast("Error: ${e.toString()}");
        }
      } else {
        if(responseCodeModel.message != null && responseCodeModel.message != "null") {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
        setState(() {
          isError= true;
          errorMessage = Strings.instance.notAvail;
        });
      }
    } catch (e) {
      setState(() {
        isError= true;
        errorMessage = Strings.instance.notAvail;
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
}
