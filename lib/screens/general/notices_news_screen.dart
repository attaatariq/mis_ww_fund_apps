import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/notice_list_item.dart';
import 'package:wwf_apps/models/NoticeModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;

class NoticesNewsScreen extends StatefulWidget {
  @override
  _NoticesNewsScreenState createState() => _NoticesNewsScreenState();
}

class _NoticesNewsScreenState extends State<NoticesNewsScreen> with SingleTickerProviderStateMixin {
  Constants constants;
  UIUpdates uiUpdates;
  TabController _tabController;
  bool isLoadingNotices = true;
  bool isLoadingNews = true;
  bool isErrorNotices = false;
  bool isErrorNews = false;
  String errorMessageNotices = "";
  String errorMessageNews = "";
  List<NoticeModel> noticesList = [];
  List<NoticeModel> newsList = [];

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    _tabController = TabController(length: 2, vsync: this);
    CheckTokenExpiry();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            title: "Notices & News",
            subtitle: _tabController.index == 0
                ? (noticesList.isNotEmpty
                    ? "${noticesList.length} ${noticesList.length == 1 ? 'Notice' : 'Notices'}"
                    : null)
                : (newsList.isNotEmpty
                    ? "${newsList.length} ${newsList.length == 1 ? 'News' : 'News Items'}"
                    : null),
          ),

          // Tab Bar
          Container(
            color: AppTheme.colors.newWhite,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.colors.newPrimary,
              indicatorWeight: 3,
              labelColor: AppTheme.colors.newPrimary,
              unselectedLabelColor: AppTheme.colors.colorDarkGray,
              labelStyle: TextStyle(
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(
                  icon: Icon(Icons.announcement_outlined, size: 20),
                  text: "Notices",
                ),
                Tab(
                  icon: Icon(Icons.newspaper_outlined, size: 20),
                  text: "News",
                ),
              ],
              onTap: (index) {
                setState(() {});
              },
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNoticesTab(),
                _buildNewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticesTab() {
    return isLoadingNotices
        ? Center(child: CircularProgressIndicator())
        : isErrorNotices
            ? _buildErrorState(errorMessageNotices, () {
                setState(() {
                  isErrorNotices = false;
                  isLoadingNotices = true;
                });
                GetNotices(false);
              })
            : noticesList.isEmpty
                ? _buildEmptyState("No Notices", "You don't have any notices yet", Icons.announcement_outlined)
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        noticesList.clear();
                        isLoadingNotices = true;
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      GetNotices(false);
                    },
                    color: AppTheme.colors.newPrimary,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: noticesList.asMap().entries.map((entry) {
                          int index = entry.key;
                          NoticeModel notice = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: NoticeListItem(notice, isNews: false),
                          );
                        }).toList(),
                      ),
                    ),
                  );
  }

  Widget _buildNewsTab() {
    return isLoadingNews
        ? Center(child: CircularProgressIndicator())
        : isErrorNews
            ? _buildErrorState(errorMessageNews, () {
                setState(() {
                  isErrorNews = false;
                  isLoadingNews = true;
                });
                GetNews(false);
              })
            : newsList.isEmpty
                ? _buildEmptyState("No News", "You don't have any news updates yet", Icons.newspaper_outlined)
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        newsList.clear();
                        isLoadingNews = true;
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      GetNews(false);
                    },
                    color: AppTheme.colors.newPrimary,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: newsList.asMap().entries.map((entry) {
                          int index = entry.key;
                          NoticeModel news = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: NoticeListItem(news, isNews: true),
                          );
                        }).toList(),
                      ),
                    ),
                  );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
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
              message.isNotEmpty ? message : "No Data Available",
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
              onPressed: onRetry,
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

  Widget _buildEmptyState(String title, String description, IconData icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
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
        // Load both notices and news
        GetNotices(true);
        GetNews(true);
      }
    });
  }

  GetNotices(bool isRefresh) async {
    try {
      String userType = _getUserType(); // W for Worker/Employee, C for Company
      String userId = UserSessions.instance.getUserID;
      // API endpoint: /alerts/notices/{user_id}/{W or C}
      var url = constants.getApiBaseURL() + 
                constants.alerts + 
                "notices/" + 
                userId + "/" + 
                userType;
      
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
            List<dynamic> notices = data != null ? (data is List ? data : []) : [];
            
            noticesList.clear();
            
            if (notices.length > 0) {
              notices.forEach((row) {
                // Only add if not deleted
                if (row["deleted_at"] == null || 
                    row["deleted_at"].toString() == "null" ||
                    row["deleted_at"].toString().isEmpty) {
                  noticesList.add(NoticeModel(
                    alert_id: row["alert_id"]?.toString() ?? "",
                    alert_heading: row["alert_heading"]?.toString() ?? "",
                    alert_subject: row["alert_subject"]?.toString() ?? "",
                    alert_message: row["alert_message"]?.toString() ?? "",
                    alert_recipient: row["alert_recipient"]?.toString() ?? "",
                    created_by: row["created_by"]?.toString() ?? "",
                    created_at: row["created_at"]?.toString() ?? "",
                    deleted_by: row["deleted_by"]?.toString() ?? "",
                    deleted_at: row["deleted_at"]?.toString() ?? "",
                  ));
                }
              });

              setState(() {
                isLoadingNotices = false;
                isErrorNotices = false;
              });
            } else {
              setState(() {
                isLoadingNotices = false;
                isErrorNotices = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowError(message);
            }
            setState(() {
              isLoadingNotices = false;
              isErrorNotices = true;
              errorMessageNotices = message.isNotEmpty ? message : Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isLoadingNotices = false;
            isErrorNotices = true;
            errorMessageNotices = Strings.instance.somethingWentWrong;
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
            uiUpdates.ShowToast(message);
          }
          
          setState(() {
            isLoadingNotices = false;
            isErrorNotices = true;
            errorMessageNotices = message.isNotEmpty ? message : Strings.instance.notAvail;
          });
        } catch (e) {
          setState(() {
            isLoadingNotices = false;
            isErrorNotices = true;
            errorMessageNotices = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoadingNotices = false;
        isErrorNotices = true;
        errorMessageNotices = Strings.instance.somethingWentWrong;
      });
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowError(Strings.instance.somethingWentWrong);
    }
  }

  GetNews(bool isRefresh) async {
    try {
      String userType = _getUserType(); // W for Worker/Employee, C for Company
      String userId = UserSessions.instance.getUserID;
      // API endpoint: /alerts/news/{user_id}/{W or C}
      var url = constants.getApiBaseURL() + 
                constants.alerts + 
                "news/" + 
                userId + "/" + 
                userType;
      
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
            List<dynamic> news = data != null ? (data is List ? data : []) : [];
            
            newsList.clear();
            
            if (news.length > 0) {
              news.forEach((row) {
                // Only add if not deleted
                if (row["deleted_at"] == null || 
                    row["deleted_at"].toString() == "null" ||
                    row["deleted_at"].toString().isEmpty) {
                  newsList.add(NoticeModel(
                    alert_id: row["alert_id"]?.toString() ?? "",
                    alert_heading: row["alert_heading"]?.toString() ?? "",
                    alert_subject: row["alert_subject"]?.toString() ?? "",
                    alert_message: row["alert_message"]?.toString() ?? "",
                    alert_recipient: row["alert_recipient"]?.toString() ?? "",
                    created_by: row["created_by"]?.toString() ?? "",
                    created_at: row["created_at"]?.toString() ?? "",
                    deleted_by: row["deleted_by"]?.toString() ?? "",
                    deleted_at: row["deleted_at"]?.toString() ?? "",
                  ));
                }
              });

              setState(() {
                isLoadingNews = false;
                isErrorNews = false;
              });
            } else {
              setState(() {
                isLoadingNews = false;
                isErrorNews = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowError(message);
            }
            setState(() {
              isLoadingNews = false;
              isErrorNews = true;
              errorMessageNews = message.isNotEmpty ? message : Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isLoadingNews = false;
            isErrorNews = true;
            errorMessageNews = Strings.instance.somethingWentWrong;
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
            uiUpdates.ShowToast(message);
          }
          
          setState(() {
            isLoadingNews = false;
            isErrorNews = true;
            errorMessageNews = message.isNotEmpty ? message : Strings.instance.notAvail;
          });
        } catch (e) {
          setState(() {
            isLoadingNews = false;
            isErrorNews = true;
            errorMessageNews = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoadingNews = false;
        isErrorNews = true;
        errorMessageNews = Strings.instance.somethingWentWrong;
      });
      uiUpdates.ShowError(Strings.instance.somethingWentWrong);
    }
  }
}

