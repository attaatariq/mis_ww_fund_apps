import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/faq_list_item.dart';
import 'package:wwf_apps/models/FaqModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class FAQs extends StatefulWidget {
  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<FaqModel> list= [];

  @override
  void initState() {
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  // Determine if user is employee (E) or employer/company (C)
  String _getUserType() {
    String sector = UserSessions.instance.getUserSector;
    String role = UserSessions.instance.getUserRole;
    
    // Employee: sector 7/4 with role 6/3, or sector 8 with role 9
    if ((sector == "7" && role == "6") || 
        (sector == "4" && role == "3") ||
        (sector == "8" && role == "9")) {
      return "E"; // Employee
    }
    // Employer/Company: sector 8 with role 7 or 8
    else if (sector == "8" && (role == "7" || role == "8")) {
      return "C"; // Company/Employer
    }
    // Default to Employee
    return "E";
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
                        "Frequently Asked Questions",
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
                            Icons.help_outline,
                            size: 64,
                            color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            errorMessage.isNotEmpty ? errorMessage : "No FAQs Available",
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
                            child: EmptyStateWidget(
                              icon: Icons.help_outline,
                              message: 'No FAQs Available',
                              description: 'Frequently asked questions will appear here once available.',
                            ),
                          )
                        : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ...list.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  FaqModel faq = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          OpenCloseFaq(index);
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: FaqListItem(faq),
                                      ),
                                    ),
                                  );
                                }).toList(),
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

  GetFaqs(bool isRefresh) async {
    try {
      if(!isRefresh) {
        uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      }
      
      String userType = _getUserType(); // E for Employee, C for Company/Employer
      // Build URL: /interaction/faqs/{user_id}/{E or C}
      String baseUrl = constants.assessments + "faqs/";
      String userId = UserSessions.instance.getUserID;
      var url = constants.getApiBaseURL() + baseUrl + userId + "/" + userType;
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            var data= body["Data"];
            List<dynamic> faqs = data != null ? (data is List ? data : []) : [];
            if(faqs.length > 0)
            {
              list.clear();
              faqs.forEach((row) {
                String faq_id= row["faq_id"]?.toString() ?? "";
                String faq_question= row["faq_question"]?.toString() ?? "";
                String faq_answer= row["faq_answer"]?.toString() ?? "";
                String faq_type= row["faq_type"]?.toString() ?? "";
                String created_at= row["created_at"]?.toString() ?? "";
                list.add(new FaqModel(faq_id, faq_question, faq_answer, faq_type, created_at, false));
              });

              setState(() {
                isError= false;
              });
            }else
            {
              setState(() {
                isError= true;
                errorMessage = Strings.instance.notAvail;
              });
            }
          } else {
            String message = body["Message"] != null ? body["Message"].toString() : "";
            if(message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
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
        }
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        GetFaqs(false);
      }
    });
  }

  void OpenCloseFaq(int index) {
    setState(() {
      list[index].isOpen = !list[index].isOpen;
    });
  }
}
