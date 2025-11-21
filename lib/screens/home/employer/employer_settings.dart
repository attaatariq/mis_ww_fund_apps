import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/screens/general/change_password.dart';
import 'package:wwf_apps/screens/general/edit_my_profile.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:http/http.dart' as http;

class EmployerSettings extends StatefulWidget {
  @override
  _EmployerSettingsState createState() => _EmployerSettingsState();
}

class _EmployerSettingsState extends State<EmployerSettings> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;

  // User Info
  String userName = "";
  String userImage = "";
  String userEmail = "";
  String userCNIC = "";
  String userContact = "";
  String userAbout = "";

  // Company Info
  String compName = "";
  String compAddress = "";
  String compLogo = "";
  String compCity = "";
  String compDistrict = "";
  String compProvince = "";
  String compType = "";
  String compStatus = "";
  String compLandline = "";

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    bool isValidUserImage = userImage != "null" &&
                           userImage != "" &&
                           userImage != "NULL" &&
                           userImage != "-" &&
                           userImage != "N/A";

    bool isValidCompLogo = compLogo != "null" &&
                          compLogo != "" &&
                          compLogo != "NULL" &&
                          compLogo != "-" &&
                          compLogo != "N/A";

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Settings",
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
                      GetInformation();
                    },
                    color: AppTheme.colors.newPrimary,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // User Information Card
                          _buildUserInfoCard(
                            userName,
                            userImage,
                            userEmail,
                            userCNIC,
                            userContact,
                            isValidUserImage,
                          ),

                          SizedBox(height: 16),

                          // Company Information Card
                          _buildCompanyInfoCard(
                            compName,
                            compAddress,
                            compLogo,
                            compCity,
                            compDistrict,
                            compProvince,
                            compType,
                            compStatus,
                            compLandline,
                            isValidCompLogo,
                          ),

                          SizedBox(height: 16),

                          // Action Buttons
                          _buildActionButtons(),

                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(
    String name,
    String image,
    String email,
    String cnic,
    String contact,
    bool isValidImage,
  ) {
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
          // Header
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
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppTheme.colors.newWhite,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User Information",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Your personal account details",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite.withOpacity(0.9),
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Image and Name
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.colors.newPrimary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: isValidImage
                            ? FadeInImage(
                                image: NetworkImage(constants.getImageBaseURL() + image),
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
                          Text(
                            name.isNotEmpty ? name : "Name not available",
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 18,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (email.isNotEmpty && email != "null")
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 14,
                                    color: AppTheme.colors.colorDarkGray,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                        color: AppTheme.colors.colorDarkGray,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
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
                  ],
                ),

                SizedBox(height: 20),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Details
                if (cnic.isNotEmpty && cnic != "null")
                  _buildInfoRow(
                    Icons.badge_outlined,
                    "CNIC",
                    cnic,
                  ),
                if (cnic.isNotEmpty && cnic != "null") SizedBox(height: 12),

                if (contact.isNotEmpty && contact != "null")
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Contact Number",
                    contact,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoCard(
    String name,
    String address,
    String logo,
    String city,
    String district,
    String province,
    String type,
    String status,
    String landline,
    bool isValidLogo,
  ) {
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
          // Header
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
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business,
                    color: AppTheme.colors.newWhite,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Information",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Your company details",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite.withOpacity(0.9),
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Company Logo and Name
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF2196F3).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: isValidLogo
                            ? FadeInImage(
                                image: NetworkImage(constants.getImageBaseURL() + logo),
                                placeholder: AssetImage("archive/images/no_image.jpg"),
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.business,
                                      size: 40,
                                      color: Color(0xFF2196F3),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Icon(
                                  Icons.business,
                                  size: 40,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.isNotEmpty ? name : "Company name not available",
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 18,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (status.isNotEmpty && status != "null")
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == "Working" || status == "Active"
                                      ? Color(0xFF4CAF50).withOpacity(0.1)
                                      : Color(0xFFFF9800).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: status == "Working" || status == "Active"
                                        ? Color(0xFF4CAF50)
                                        : Color(0xFFFF9800),
                                    fontSize: 11,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Company Details
                if (address.isNotEmpty && address != "null")
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    "Address",
                    address,
                  ),
                if (address.isNotEmpty && address != "null") SizedBox(height: 12),

                // Location (City, District, Province)
                if (_buildLocationString(city, district, province).isNotEmpty) ...[
                  _buildInfoRow(
                    Icons.map_outlined,
                    "Location",
                    _buildLocationString(city, district, province),
                  ),
                  SizedBox(height: 12),
                ],

                if (type.isNotEmpty && type != "null")
                  _buildInfoRow(
                    Icons.category_outlined,
                    "Company Type",
                    type,
                  ),
                if (type.isNotEmpty && type != "null") SizedBox(height: 12),

                if (landline.isNotEmpty && landline != "null")
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Landline",
                    landline,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 20,
                    color: AppTheme.colors.newPrimary,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Actions",
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 18,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          _buildActionButton(
            icon: Icons.edit_outlined,
            title: "Edit Profile",
            subtitle: "Update your personal information",
            color: AppTheme.colors.newPrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(),
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    isLoading = true;
                  });
                  GetInformation();
                }
              });
            },
          ),
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          _buildActionButton(
            icon: Icons.lock_outlined,
            title: "Change Password",
            subtitle: "Update your account password",
            color: Color(0xFF2196F3),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePassword(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 15,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.colors.colorDarkGray,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.colors.colorLightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.colors.newPrimary,
          ),
        ),
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
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildLocationString(String city, String district, String province) {
    List<String> parts = [];
    if (city.isNotEmpty && city != "null") parts.add(city);
    if (district.isNotEmpty && district != "null") parts.add(district);
    if (province.isNotEmpty && province != "null") parts.add(province);
    return parts.join(", ");
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
        GetInformation();
      }
    });
  }

  void GetInformation() async {
    try {
      // First get account info and companies list
      List<String> tagsList = [constants.accountInfo, constants.companiesInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
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
              // Get user info from account
              var account = dataObj["account"];
              if (account != null) {
                userName = account["user_name"]?.toString() ?? UserSessions.instance.getUserName ?? "";
                userImage = account["user_image"]?.toString() ?? UserSessions.instance.getUserImage ?? "";
                userEmail = account["user_email"]?.toString() ?? UserSessions.instance.getUserEmail ?? "";
                userCNIC = account["user_cnic"]?.toString() ?? UserSessions.instance.getUserCNIC ?? "";
                userContact = account["user_contact"]?.toString() ?? UserSessions.instance.getUserNumber ?? "";
                userAbout = account["user_about"]?.toString() ?? "";

                // Get company ID from account
                String compId = account["comp_id"]?.toString() ?? UserSessions.instance.getRefID ?? "";
                
                // Get company info from companies list
                var companies = dataObj["companies"];
                if (companies != null && companies is List && compId.isNotEmpty) {
                  for (var comp in companies) {
                    if (comp != null && comp is Map) {
                      String compIdFromList = comp["comp_id"]?.toString() ?? "";
                      if (compIdFromList == compId) {
                        compName = comp["comp_name"]?.toString() ?? "";
                        compAddress = comp["comp_address"]?.toString() ?? "";
                        compLogo = comp["comp_logo"]?.toString() ?? "";
                        compCity = comp["city_name"]?.toString() ?? "";
                        compDistrict = comp["district_name"]?.toString() ?? "";
                        compProvince = comp["state_name"]?.toString() ?? "";
                        compType = comp["comp_type"]?.toString() ?? "";
                        compStatus = comp["comp_status"]?.toString() ?? "";
                        compLandline = comp["comp_landline"]?.toString() ?? "";
                        break;
                      }
                    }
                  }
                }
              }
            }

            setState(() {
              isLoading = false;
            });
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            }
            setState(() {
              isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            isLoading = false;
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
          });
        } catch (e) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
  }
}

