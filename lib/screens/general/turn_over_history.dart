import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/turn_over_history_item.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/models/TurnoverHistoryModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;

class TurnOverHistory extends StatefulWidget {
  @override
  _TurnOverHistoryState createState() => _TurnOverHistoryState();
}

class _TurnOverHistoryState extends State<TurnOverHistory> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = "";
  TurnoverHistoryModel currentEmployment;
  List<TurnoverHistoryModel> previousEmploymentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    GetTurnOverHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Turnover History",
            subtitle: currentEmployment != null || previousEmploymentList.isNotEmpty
                ? "${currentEmployment != null ? 1 : 0} Current, ${previousEmploymentList.length} Previous"
                : null,
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? _buildErrorState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            isLoading = true;
                            isError = false;
                            currentEmployment = null;
                            previousEmploymentList.clear();
                          });
                          await Future.delayed(Duration(milliseconds: 500));
                          GetTurnOverHistory();
                        },
                        color: AppTheme.colors.newPrimary,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Current Employment Section
                              if (currentEmployment != null) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "Current Employment",
                                    style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 16,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                TurnOverHistoryItem(
                                  currentEmployment,
                                  isCurrent: true,
                                ),
                                SizedBox(height: 24),
                              ],

                              // Previous Employment Section
                              if (previousEmploymentList.isNotEmpty) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "Previous Employment",
                                    style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 16,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                ...previousEmploymentList.map((employment) => TurnOverHistoryItem(
                                      employment,
                                      isCurrent: false,
                                    )),
                                SizedBox(height: 16),
                              ],

                              // Empty State
                              if (currentEmployment == null && previousEmploymentList.isEmpty)
                                Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.work_outline,
                                          size: 80,
                                          color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "No Employment History",
                                          style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 16,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Employment history will appear here once available",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                                            fontSize: 14,
                                            fontFamily: "AppFont",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
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
                GetTurnOverHistory();
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

  void GetTurnOverHistory() async {
    try {
      String userId = UserSessions.instance.getUserID;
      String compId = UserSessions.instance.getRefID;
      String empId = UserSessions.instance.getEmployeeID;

      // Fetch comp_id if not available
      if (compId.isEmpty || compId == "" || compId == "null") {
        compId = await _fetchCompanyID();
      }

      // Fetch emp_id if not available
      if (empId.isEmpty || empId == "" || empId == "null") {
        empId = await _fetchEmployeeID();
      }

      if (compId.isEmpty || compId == "" || compId == "null") {
        if (mounted) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = "Company ID not found. Please try again.";
          });
        }
        return;
      }

      if (empId.isEmpty || empId == "" || empId == "null") {
        if (mounted) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = "Employee ID not found. Please try again.";
          });
        }
        return;
      }

      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      // Format: /companies/turnovers/{user_id}/{comp_id}/{emp_id}
      var url = constants.getApiBaseURL() + 
                constants.companies + 
                "turnovers/" + 
                userId + "/" + 
                compId + "/" + 
                empId;
      
      var response = await http.get(
        Uri.parse(url),
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 30));
      
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
              // Parse current employment
              var currentList = data["current"];
              if (currentList != null && currentList is List && currentList.length > 0) {
                var currentComp = currentList[0];
                currentEmployment = TurnoverHistoryModel(
                  comp_name: currentComp["comp_name"]?.toString() ?? "",
                  comp_address: currentComp["comp_address"]?.toString() ?? "",
                  comp_city: currentComp["comp_city"]?.toString() ?? "",
                  comp_district: currentComp["comp_district"]?.toString() ?? "",
                  comp_province: currentComp["comp_province"]?.toString() ?? "",
                  comp_status: currentComp["comp_status"]?.toString() ?? "",
                  appointed_at: currentComp["appointed_at"]?.toString() ?? "",
                  comp_type: currentComp["comp_type"]?.toString() ?? "",
                  comp_landline: currentComp["comp_landline"]?.toString() ?? "",
                  city_name: currentComp["city_name"]?.toString() ?? "",
                  district_name: currentComp["district_name"]?.toString() ?? "",
                  state_name: currentComp["state_name"]?.toString() ?? "",
                );
              }

              // Parse previous employment
              var previousList = data["previous"];
              previousEmploymentList.clear();
              if (previousList != null && previousList is List && previousList.length > 0) {
                previousList.forEach((row) {
                  previousEmploymentList.add(TurnoverHistoryModel(
                    comp_name: row["comp_name"]?.toString() ?? "",
                    comp_address: row["comp_address"]?.toString() ?? "",
                    comp_city: row["comp_city"]?.toString() ?? "",
                    comp_district: row["comp_district"]?.toString() ?? "",
                    comp_province: row["comp_province"]?.toString() ?? "",
                    comp_status: row["comp_status"]?.toString() ?? "",
                    appointed_at: row["appointed_at"]?.toString() ?? "",
                    comp_type: row["comp_type"]?.toString() ?? "",
                    comp_landline: row["comp_landline"]?.toString() ?? "",
                    city_name: row["city_name"]?.toString() ?? "",
                    district_name: row["district_name"]?.toString() ?? "",
                    state_name: row["state_name"]?.toString() ?? "",
                  ));
                });
              }

              if (mounted) {
                setState(() {
                  isLoading = false;
                  isError = false;
                });
              }
              uiUpdates.DismissProgresssDialog();
            } else {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  isError = true;
                  errorMessage = Strings.instance.notAvail;
                });
              }
              uiUpdates.DismissProgresssDialog();
            }
          } else {
            if (mounted) {
              setState(() {
                isLoading = false;
                isError = true;
                errorMessage = Strings.instance.notAvail;
              });
            }
            uiUpdates.DismissProgresssDialog();
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = Strings.instance.somethingWentWrong;
            });
          }
          uiUpdates.DismissProgresssDialog();
          uiUpdates.ShowError(Strings.instance.somethingWentWrong);
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"]?.toString() ?? "";
          
          if (message == constants.expireToken) {
            constants.OpenLogoutDialog(
              context,
              Strings.instance.expireSessionTitle,
              Strings.instance.expireSessionMessage,
            );
          } else if (message.isNotEmpty && message != "null") {
            uiUpdates.ShowError(message);
          }
          
          if (mounted) {
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = message.isNotEmpty ? message : Strings.instance.notAvail;
            });
          }
          uiUpdates.DismissProgresssDialog();
        } catch (e) {
          if (mounted) {
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = Strings.instance.notAvail;
            });
          }
          uiUpdates.DismissProgresssDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = Strings.instance.somethingWentWrong;
        });
      }
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowError(Strings.instance.somethingWentWrong);
    }
  }

  Future<String> _fetchCompanyID() async {
    try {
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
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
          if (account != null && account["comp_id"] != null) {
            String compId = account["comp_id"].toString();
            if (compId.isNotEmpty && compId != "null") {
              UserSessions.instance.setRefID(compId);
              return compId;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail
    }
    return "";
  }

  Future<String> _fetchEmployeeID() async {
    try {
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}
