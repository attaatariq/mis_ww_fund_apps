import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/models/VerificationStatusModel.dart';
import 'package:wwf_apps/models/ProofStageModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/utils/proof_stages_helper.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../general/my_profile.dart';
import '../../general/change_password.dart';
import 'employee_home.dart';

class VerificationScrutinyScreen extends StatefulWidget {
  @override
  _VerificationScrutinyScreenState createState() => _VerificationScrutinyScreenState();
}

class _VerificationScrutinyScreenState extends State<VerificationScrutinyScreen> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  VerificationStatusModel verificationStatus;
  ProofStageModel currentStage;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation - user must stay on this screen
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Column(
          children: [
            StandardHeader(
              title: "Account Verification",
              showBackButton: false,
              actionIcon: Icons.power_settings_new,
              onActionPressed: () {
                _showLogoutDialog();
              },
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(Duration(milliseconds: 500));
                        // Reload proof stages and check verification status
                        await _loadProofStages();
                        await _loadEmployeeInfo();
                        GetVerificationStatus();
                      },
                      color: AppTheme.colors.newPrimary,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main Heading
                            Text(
                              currentStage != null
                                  ? currentStage.heading.toUpperCase()
                                  : "VERIFICATION STATUS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 20,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),

                            SizedBox(height: 20),
                            Divider(color: Colors.grey.withOpacity(0.3), height: 1),
                            SizedBox(height: 20),

                            // Alert Message
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getAlertColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getAlertColor().withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                currentStage != null
                                    ? currentStage.message
                                    : "Verification status is being processed.",
                                style: TextStyle(
                                  color: _getAlertColor(),
                                  fontSize: 13,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Action Button
                            if (verificationStatus != null && verificationStatus.isUnsuccessful)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyProfile(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(_getAlertColor()),
                                    foregroundColor: MaterialStateProperty.all(AppTheme.colors.newWhite),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                  ),
                                  child: Text("Update Profile"),
                                ),
                              )
                            else if (verificationStatus != null && verificationStatus.isScrutinized)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to dashboard
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeHome(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(_getProgressColor()),
                                    foregroundColor: MaterialStateProperty.all(AppTheme.colors.newWhite),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                  ),
                                  child: Text("Access Dashboard"),
                                ),
                              ),

                            SizedBox(height: 30),

                            // Progress Bar
                            _buildProgressBar(),

                            SizedBox(height: 30),
                            Divider(color: Colors.grey.withOpacity(0.3), height: 1),
                            SizedBox(height: 20),

                            // Registration Details
                            if (verificationStatus != null && verificationStatus.created_at.isNotEmpty)
                              _buildRegistrationDetails(),

                            SizedBox(height: 20),

                            // Verification Summary Timeline
                            if (verificationStatus != null)
                              _buildVerificationSummary(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    int percent = currentStage != null ? currentStage.getPercentValue() : 0;
    Color progressColor = _getProgressColor();
    String percentLabel = _getPercentLabel(percent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress",
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "$percent% ($percentLabel)",
              style: TextStyle(
                color: progressColor,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor,
                        progressColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "$percent% ($percentLabel)",
                  style: TextStyle(
                    color: percent > 0 ? AppTheme.colors.newWhite : AppTheme.colors.newBlack,
                    fontSize: 12,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationDetails() {
    String createdAt = verificationStatus.created_at;
    String formattedDate = "";
    if (createdAt.isNotEmpty && createdAt != "null") {
      try {
        formattedDate = constants.GetFormatedDate(createdAt);
      } catch (e) {
        formattedDate = createdAt;
      }
    }

    String empMedium = verificationStatus.emp_medium ?? "";
    String mediumText = "";
    if (empMedium.isNotEmpty && empMedium != "null") {
      if (empMedium == "web") {
        mediumText = "Web Portal";
      } else if (empMedium == "mobile") {
        mediumText = "Mobile App";
      } else {
        mediumText = empMedium;
      }
    }

    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: AppTheme.colors.colorDarkGray,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registered via $mediumText on $formattedDate",
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 12,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Remarks: No additional remarks or description provided.",
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationSummary() {
    List<Map<String, String>> timelineItems = [];

    // Add registration
    if (verificationStatus.created_at.isNotEmpty && verificationStatus.created_at != "null") {
      String empMedium = verificationStatus.emp_medium ?? "";
      String mediumText = empMedium == "web" ? "Web Portal" : (empMedium == "mobile" ? "Mobile App" : empMedium);
      timelineItems.add({
        "title": "Registered via $mediumText",
        "date": verificationStatus.created_at,
        "remarks": "No additional remarks or description provided.",
      });
    }

    // Add verification steps
    for (int i = 1; i <= 4; i++) {
      String checkedAt = "";
      String remarks = "";
      String processBy = "";

      switch (i) {
        case 1:
          checkedAt = verificationStatus.checked_at_1 ?? "";
          remarks = verificationStatus.emp_remarks_1 ?? "";
          processBy = "Identified by the C.E.O / D.E.O of the company";
          break;
        case 2:
          checkedAt = verificationStatus.checked_at_2 ?? "";
          remarks = verificationStatus.emp_remarks_2 ?? "";
          processBy = "Assessed by the Assistant Director of Education";
          break;
        case 3:
          checkedAt = verificationStatus.checked_at_3 ?? "";
          remarks = verificationStatus.emp_remarks_3 ?? "";
          processBy = "Verified NADRA records by the Director of IT (DD-IT)";
          break;
        case 4:
          checkedAt = verificationStatus.checked_at_4 ?? "";
          remarks = verificationStatus.emp_remarks_4 ?? "";
          processBy = "Scrutinized by the Scrutiny Committee";
          break;
      }

      if (checkedAt.isNotEmpty && checkedAt != "null") {
        timelineItems.add({
          "title": processBy,
          "date": checkedAt,
          "remarks": remarks.isNotEmpty && remarks != "null" ? remarks : "No Remarks",
        });
      }
    }

    if (timelineItems.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verification Timeline",
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 16,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...timelineItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> item = entry.value;
          bool isLast = index == timelineItems.length - 1;

          String formattedDate = "";
          try {
            formattedDate = constants.GetFormatedDate(item["date"]);
          } catch (e) {
            formattedDate = item["date"];
          }

          return Padding(
            padding: EdgeInsets.only(left: 20, bottom: isLast ? 0 : 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline line and dot
                Column(
                  children: [
                    Container(
                      width: 2,
                      height: isLast ? 0 : 40,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 20,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] + " " + formattedDate,
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Remarks: ${item["remarks"]}",
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
          );
        }).toList(),
      ],
    );
  }

  Color _getAlertColor() {
    if (verificationStatus == null) return AppTheme.colors.colorDarkGray;
    
    if (verificationStatus.isUnsuccessful) {
      return Color(0xFFF44336); // Red/Danger
    }
    
    int percent = currentStage != null ? currentStage.getPercentValue() : 0;
    if (percent == 100) {
      return Color(0xFF4CAF50); // Green/Success
    } else if (percent >= 75) {
      return Color(0xFF4CAF50); // Green/Success
    } else if (percent >= 50) {
      return Color(0xFF2196F3); // Blue/Info
    } else if (percent >= 25) {
      return Color(0xFFFF9800); // Orange/Warning
    } else {
      return Color(0xFFF44336); // Red/Danger
    }
  }

  Color _getProgressColor() {
    if (verificationStatus == null) return AppTheme.colors.colorDarkGray;
    
    if (verificationStatus.isUnsuccessful) {
      return Color(0xFFF44336); // Red/Danger
    }
    
    int percent = currentStage != null ? currentStage.getPercentValue() : 0;
    if (percent == 100) {
      return Color(0xFF4CAF50); // Green/Success
    } else if (percent >= 75) {
      return Color(0xFF4CAF50); // Green/Success
    } else if (percent >= 50) {
      return Color(0xFF2196F3); // Blue/Info
    } else if (percent >= 25) {
      return Color(0xFFFF9800); // Orange/Warning
    } else {
      return Color(0xFFF44336); // Red/Danger
    }
  }

  String _getPercentLabel(int percent) {
    if (percent == 100) {
      return "Finalized/Completed";
    } else if (percent >= 75) {
      return "Finalizing/Completing";
    } else if (percent >= 50) {
      return "Review/Analysis";
    } else if (percent >= 25) {
      return "In Progress/Processing";
    } else {
      return "Initiating/Starting";
    }
  }

  void GetVerificationStatus() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      
      // First, load proof_stages from information API if not loaded
      await _loadProofStages();
      
      String userId = UserSessions.instance.getUserID;
      String empId = UserSessions.instance.getEmployeeID;

      if (empId.isEmpty || empId == "" || empId == "null") {
        // Try to fetch from information API
        empId = await _fetchEmployeeID();
      }

      if (empId.isEmpty || empId == "" || empId == "null") {
        setState(() {
          isLoading = false;
        });
        uiUpdates.DismissProgresssDialog();
        uiUpdates.ShowToast("Employee ID not found. Please try again.");
        return;
      }

      // API endpoint: /companies/is_verified/{user_id}/{emp_id}
      var url = constants.getApiBaseURL() +
                constants.companies +
                "is_verified/" +
                userId + "/" +
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
            var messageData = body["Message"];
            if (messageData != null && messageData is Map) {
              verificationStatus = VerificationStatusModel.fromJson(messageData);
              
              // Also fetch emp_medium and created_at from information API
              await _loadEmployeeInfo();
              
              // Get current stage based on emp_check
              String empCheck = verificationStatus.emp_check;
              currentStage = ProofStagesData.instance.getStageForStatus(empCheck);

              setState(() {
                isLoading = false;
              });
              uiUpdates.DismissProgresssDialog();
            } else {
              setState(() {
                isLoading = false;
              });
              uiUpdates.DismissProgresssDialog();
              uiUpdates.ShowToast("Verification data not available.");
            }
          } else {
            setState(() {
              isLoading = false;
            });
            uiUpdates.DismissProgresssDialog();
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            }
          }
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          uiUpdates.DismissProgresssDialog();
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
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
            uiUpdates.ShowToast(message);
          }

          setState(() {
            isLoading = false;
          });
          uiUpdates.DismissProgresssDialog();
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          uiUpdates.DismissProgresssDialog();
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
  }

  Future<void> _loadEmployeeInfo() async {
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
          if (account != null && verificationStatus != null) {
            // Update verification status with emp_medium and created_at if available
            String empMedium = account["emp_medium"]?.toString() ?? "";
            String createdAt = account["created_at"]?.toString() ?? "";
            if (empMedium.isNotEmpty && empMedium != "null") {
              verificationStatus.emp_medium = empMedium;
            }
            if (createdAt.isNotEmpty && createdAt != "null") {
              verificationStatus.created_at = createdAt;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _loadProofStages() async {
    if (!ProofStagesData.instance.hasStages()) {
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
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(
            context,
            Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        GetVerificationStatus();
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            Strings.instance.logout,
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 18,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            Strings.instance.logoutMessage,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                constants.LogoutUser(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppTheme.colors.newPrimary),
                foregroundColor: MaterialStateProperty.all(AppTheme.colors.newWhite),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
              ),
              child: Text(
                Strings.instance.logout,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

