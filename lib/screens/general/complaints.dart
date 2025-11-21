import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/complaint_list_item.dart';
import 'package:wwf_apps/models/ComplaintModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/general/add_complaint.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;

class Complaints extends StatefulWidget {
  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = "";
  List<ComplaintModel> list = [];

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
          StandardHeader(
            title: "Complaints",
            subtitle: list.isNotEmpty
                ? "${list.length} ${list.length == 1 ? 'Complaint' : 'Complaints'}"
                : null,
            actionIcon: Icons.add_box_outlined,
            onActionPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddComplaint()
              )).then((value) {
                if (value == true) {
                  setState(() {
                    list.clear();
                    isLoading = true;
                  });
                  GetComplaints(false);
                }
              });
            },
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? _buildErrorState()
                    : list.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                list.clear();
                                isLoading = true;
                              });
                              await Future.delayed(Duration(milliseconds: 500));
                              GetComplaints(false);
                            },
                            color: AppTheme.colors.newPrimary,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: list.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  ComplaintModel complaint = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: ComplaintItem(complaint),
                                  );
                                }).toList(),
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
              errorMessage.isNotEmpty ? errorMessage : "No Complaints Available",
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
                GetComplaints(false);
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              "No Complaints",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You haven't submitted any complaints yet",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                fontSize: 14,
                fontFamily: "AppFont",
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
        constants.OpenLogoutDialog(
          context,
          Strings.instance.expireSessionTitle,
          Strings.instance.expireSessionMessage,
        );
      } else {
        GetComplaints(false);
      }
    });
  }

  GetComplaints(bool isRefresh) async {
    try {
      if (!isRefresh) {
        uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      }

      // API endpoint: interaction/complaints/{user_id}
      String userId = UserSessions.instance.getUserID;
      var url = constants.getApiBaseURL() + 
                constants.assessments + 
                "complaints/" + 
                userId;
      
      var response = await http.get(
        Uri.parse(url),
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (!isRefresh) {
        uiUpdates.DismissProgresssDialog();
      }
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            var data = body["Data"];
            List<dynamic> complaints = data != null ? (data is List ? data : []) : [];
            
            list.clear();
            
            if (complaints.length > 0) {
              complaints.forEach((row) {
                list.add(ComplaintModel(
                  id: row["com_id"]?.toString() ?? "",
                  type: row["com_type"]?.toString() ?? "",
                  subject: row["com_subject"]?.toString() ?? "",
                  message: row["com_message"]?.toString() ?? "",
                  complaintResponse: row["com_response"]?.toString() ?? "",
                  respondBy: row["respond_by"]?.toString() ?? "",
                  responderName: row["user_name"]?.toString() ?? "",
                  responderGender: row["user_gender"]?.toString() ?? "",
                  responderImage: row["user_image"]?.toString() ?? "",
                  responderSectorName: row["sector_name"]?.toString() ?? "",
                  responderRoleName: row["role_name"]?.toString() ?? "",
                  respondedAt: row["respond_at"]?.toString() ?? "",
                  createdAt: row["created_at"]?.toString() ?? "",
                ));
              });

              setState(() {
                isLoading = false;
                isError = false;
              });
            } else {
              setState(() {
                isLoading = false;
                isError = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowError(message);
            }
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = message.isNotEmpty ? message : Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = Strings.instance.somethingWentWrong;
          });
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
          
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = message.isNotEmpty ? message : Strings.instance.notAvail;
          });
        } catch (e) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = Strings.instance.notAvail;
          });
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
}
