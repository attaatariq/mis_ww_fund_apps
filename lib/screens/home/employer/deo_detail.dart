import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/screens/home/employer/stenotypist.dart';
import 'package:http/http.dart' as http;
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../network/api_service.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../widgets/standard_header.dart';

class DeoDetail extends StatefulWidget {
  @override
  _DeoDetailState createState() => _DeoDetailState();
}

class _DeoDetailState extends State<DeoDetail> {
  String deoImage = "";
  String name = "";
  String designation = "";
  String gender = "";
  String cnic = "";
  String email = "";
  String number = "";
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool hasDeo = false;
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
            title: "Data Entry Operator",
            subtitle: hasDeo ? "Assigned" : null,
            actionIcon: hasDeo ? null : Icons.add,
            onActionPressed: hasDeo
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDeo(),
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {
                          isLoading = true;
                          hasDeo = false;
                        });
                        GetInformation();
                      }
                    });
                  },
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : hasDeo
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
                          child: _buildDeoCard(),
                        ),
                      )
                    : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildDeoCard() {
    bool isValidImage = deoImage != null &&
                        deoImage.isNotEmpty &&
                        deoImage != "null" &&
                        deoImage != "NULL" &&
                        deoImage != "-" &&
                        deoImage != "N/A";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.colors.newPrimary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.1),
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
                  AppTheme.colors.newPrimary,
                  AppTheme.colors.newPrimary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.5),
                topRight: Radius.circular(14.5),
              ),
            ),
            child: Row(
              children: [
                // Profile Image
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: isValidImage
                        ? FadeInImage(
                            image: NetworkImage(constants.getImageBaseURL() + deoImage),
                            placeholder: AssetImage("archive/images/no_image.jpg"),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "archive/images/no_image.jpg",
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            "archive/images/no_image.jpg",
                            fit: BoxFit.cover,
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
                          "Data Entry Operator",
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

                // Gender & CNIC
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        gender == "Male" ? Icons.male : Icons.female,
                        "Gender",
                        gender.isNotEmpty && gender != "null" ? gender : "N/A",
                        Color(0xFF2196F3),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.credit_card,
                        "CNIC",
                        cnic.isNotEmpty && cnic != "null" ? cnic : "N/A",
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ],
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
            color: AppTheme.colors.newPrimary,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
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
          Icon(icon, size: 16, color: AppTheme.colors.newPrimary),
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
              "No Data Entry Operator",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Add a Data Entry Operator to manage your company data",
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
      List<String> tagsList = [constants.accountInfo, constants.deoInfo];
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
                var deoDetail = account["DEO"];
                if (deoDetail != null && deoDetail is Map) {
                  // DEO exists
                  name = deoDetail["user_name"]?.toString() ?? "";
                  deoImage = deoDetail["user_image"]?.toString() ?? "";
                  number = deoDetail["user_contact"]?.toString() ?? "";
                  cnic = deoDetail["user_cnic"]?.toString() ?? "";
                  gender = deoDetail["user_gender"]?.toString() ?? "";
                  email = deoDetail["user_email"]?.toString() ?? "";
                  designation = deoDetail["user_about"]?.toString() ?? "";

                  if (mounted) {
                    setState(() {
                      isLoading = false;
                      hasDeo = true;
                    });
                  }
                  uiUpdates.DismissProgresssDialog();
                } else {
                  // No DEO
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                      hasDeo = false;
                    });
                  }
                  uiUpdates.DismissProgresssDialog();
                }
              } else {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                    hasDeo = false;
                  });
                }
                uiUpdates.DismissProgresssDialog();
              }
            } else {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  hasDeo = false;
                });
              }
              uiUpdates.DismissProgresssDialog();
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowError(message);
            }
            if (mounted) {
              setState(() {
                isLoading = false;
                hasDeo = false;
              });
            }
            uiUpdates.DismissProgresssDialog();
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              isLoading = false;
              hasDeo = false;
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
              hasDeo = false;
            });
          }
          uiUpdates.DismissProgresssDialog();
        } catch (e) {
          if (mounted) {
            setState(() {
              isLoading = false;
              hasDeo = false;
            });
          }
          uiUpdates.DismissProgresssDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasDeo = false;
        });
      }
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowError(Strings.instance.somethingWentWrong);
    }
  }
}
