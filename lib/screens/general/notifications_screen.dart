import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/notification_list_item.dart';
import 'package:wwf_apps/models/NotificationModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = "";
  List<NotificationModel> notificationList = [];

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
  }

  // Determine user type for API: W for Worker/Employee, C for Company
  String _getUserType() {
    String sector = UserSessions.instance.getUserSector;
    String role = UserSessions.instance.getUserRole;
    
    // Employee/Worker: sector 7/4 with role 6/3, or sector 8 with role 9
    if ((sector == "7" && role == "6") || 
        (sector == "4" && role == "3") ||
        (sector == "8" && role == "9")) {
      return "W"; // Worker/Employee
    }
    // Employer/Company: sector 8 with role 7 or 8
    else if (sector == "8" && (role == "7" || role == "8")) {
      return "C"; // Company/Employer
    }
    // Default to Worker
    return "W";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Notifications",
            subtitle: notificationList.isNotEmpty
                ? "${notificationList.length} ${notificationList.length == 1 ? 'Notification' : 'Notifications'}"
                : null,
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? _buildErrorState()
                    : notificationList.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                notificationList.clear();
                                isLoading = true;
                              });
                              await Future.delayed(Duration(milliseconds: 500));
                              GetNotifications(false);
                            },
                            color: AppTheme.colors.newPrimary,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: notificationList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  NotificationModel notification = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: NotificationListItem(notification),
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
              errorMessage.isNotEmpty ? errorMessage : "No Notifications Available",
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
                GetNotifications(false);
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
              Icons.notifications_none_outlined,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              "No Notifications",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You don't have any notifications yet",
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
        GetNotifications(false);
      }
    });
  }

  GetNotifications(bool isRefresh) async {
    try {
      if (!isRefresh) {
        uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      }

      String userType = _getUserType(); // W for Worker/Employee, C for Company
      String userId = UserSessions.instance.getUserID;
      // API endpoint: /alerts/notifications/{user_id}/{W or C}
      var url = constants.getApiBaseURL() + 
                constants.alerts + 
                "notifications/" + 
                userId + "/" + 
                userType;
      
      var response = await http.get(
        Uri.parse(url),
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      uiUpdates.DismissProgresssDialog();
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            var data = body["Data"];
            List<dynamic> notifications = data != null ? (data is List ? data : []) : [];
            
            notificationList.clear();
            
            if (notifications.length > 0) {
              notifications.forEach((row) {
                notificationList.add(NotificationModel(
                  not_id: row["not_id"]?.toString() ?? "",
                  user_id: row["user_id"]?.toString() ?? "",
                  not_subject: row["not_subject"]?.toString() ?? "",
                  not_message: row["not_message"]?.toString() ?? "",
                  not_recipient: row["not_recipient"]?.toString() ?? "",
                  not_read: row["not_read"]?.toString() ?? "0",
                  created_at: row["created_at"]?.toString() ?? "",
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
              uiUpdates.ShowToast(message);
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
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = Strings.instance.somethingWentWrong;
      });
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
  }
}

