import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/screens/home/employer/create_person.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../network/api_service.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';

class ContactPerson extends StatefulWidget {
  @override
  _ContactPersonState createState() => _ContactPersonState();
}

class _ContactPersonState extends State<ContactPerson> {
  String faxNo = "";
  String name = "";
  String designation = "";
  String gender = "";
  String email = "";
  String number = "";
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool hasContactPerson = false;
  String errorMessage = "";

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
            title: "Contact Person",
            subtitle: hasContactPerson ? "Assigned" : null,
            actionIcon: hasContactPerson ? null : Icons.add,
            onActionPressed: hasContactPerson
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddContactPerson(),
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {
                          isLoading = true;
                          hasContactPerson = false;
                        });
                        GetInformation();
                      }
                    });
                  },
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : hasContactPerson
                    ? RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await Future.delayed(Duration(milliseconds: 500));
                          GetInformation();
                        },
                        color: AppTheme.colors.newPrimary,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: _buildContactPersonCard(),
                        ),
                      )
                    : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactPersonCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF2196F3).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2196F3).withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2196F3),
                  Color(0xFF2196F3).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.5),
                topRight: Radius.circular(14.5),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.colors.newWhite.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.perm_contact_cal_rounded,
                      size: 32,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Contact Person",
                          style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        name.isNotEmpty ? name : "Name not available",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (designation.isNotEmpty && designation != "null")
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            designation,
                            style: TextStyle(
                              color: AppTheme.colors.newWhite.withOpacity(0.9),
                              fontSize: 13,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                _buildSectionHeader("Personal Information"),
                SizedBox(height: 16),

                // Gender
                _buildInfoCard(
                  gender == "Male" ? Icons.male : Icons.female,
                  "Gender",
                  gender.isNotEmpty && gender != "null" ? gender : "N/A",
                  Color(0xFF2196F3),
                ),

                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Contact Information Section
                _buildSectionHeader("Contact Information"),
                SizedBox(height: 16),

                // Email
                if (email.isNotEmpty && email != "null")
                  _buildInfoRow(
                    Icons.email,
                    "Email",
                    email,
                  ),
                if (email.isNotEmpty && email != "null") SizedBox(height: 12),

                // Contact Number
                if (number.isNotEmpty && number != "null")
                  _buildInfoRow(
                    Icons.phone,
                    "Contact Number",
                    number,
                  ),
                if (number.isNotEmpty && number != "null") SizedBox(height: 12),

                // Fax Number
                if (faxNo.isNotEmpty && faxNo != "null")
                  _buildInfoRow(
                    Icons.fax,
                    "Fax Number",
                    faxNo,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 15,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFF2196F3)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 11,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 13,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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
              Icons.person_add_outlined,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              "No Contact Person",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Add a contact person to manage company communications",
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
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        GetInformation();
      }
    });
  }

  GetInformation() async {
    try {
      List<String> tagsList = [constants.accountInfo, constants.contactPersonInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(
        Uri.parse(url),
        body: data,
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
            var dataObj = body["Data"];
            if (dataObj != null) {
              var account = dataObj["account"];
              if (account != null) {
                var personDetail = account["person"];
                if (personDetail != null && personDetail is Map) {
                  // Contact Person exists
                  name = personDetail["person_name"]?.toString() ?? "";
                  faxNo = personDetail["person_fax_no"]?.toString() ?? "";
                  number = personDetail["person_contact"]?.toString() ?? "";
                  gender = personDetail["person_gender"]?.toString() ?? "";
                  email = personDetail["person_email"]?.toString() ?? "";
                  designation = personDetail["person_about"]?.toString() ?? "";

                  setState(() {
                    isLoading = false;
                    hasContactPerson = true;
                  });
                } else {
                  // No Contact Person
                  setState(() {
                    isLoading = false;
                    hasContactPerson = false;
                  });
                }
              } else {
                setState(() {
                  isLoading = false;
                  hasContactPerson = false;
                });
              }
            } else {
              setState(() {
                isLoading = false;
                hasContactPerson = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            }
            setState(() {
              isLoading = false;
              hasContactPerson = false;
            });
          }
        } catch (e) {
          setState(() {
            isLoading = false;
            hasContactPerson = false;
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
            hasContactPerson = false;
          });
        } catch (e) {
          setState(() {
            isLoading = false;
            hasContactPerson = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasContactPerson = false;
      });
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
  }
}
