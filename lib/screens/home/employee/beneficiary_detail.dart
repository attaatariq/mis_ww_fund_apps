import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/screens/home/employee/add_beneficiary.dart';
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../network/api_service.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../widgets/standard_header.dart';
import '../../../widgets/empty_state_widget.dart';

class BeneficiaryDetail extends StatefulWidget {
  @override
  _BeneficiaryDetailState createState() => _BeneficiaryDetailState();
}

class _BeneficiaryDetailState extends State<BeneficiaryDetail> {
  List<Map<String, String>> beneficiariesList = [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isError = false;
  String errorMessage = "";
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
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
            title: "Beneficiaries",
            subtitle: beneficiariesList.isNotEmpty
                ? "${beneficiariesList.length} ${beneficiariesList.length == 1 ? 'Beneficiary' : 'Beneficiaries'}"
                : null,
            actionIcon: Icons.add_box_outlined,
            onActionPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddBeneficiary()
              )).then((value) {
                setState(() {});
                if (value) {
                  beneficiariesList.clear();
                  CheckTokenExpiry();
                }
              });
            },
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? _buildErrorState()
                    : beneficiariesList.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              beneficiariesList.clear();
                              await Future.delayed(Duration(milliseconds: 500));
                              CheckTokenExpiry();
                            },
                            color: AppTheme.colors.newPrimary,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: beneficiariesList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, String> beneficiary = entry.value;
                                  return _buildBeneficiaryCard(beneficiary, index);
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
              Icons.person_outline,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              "No Beneficiaries Added",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Add a beneficiary to get started",
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

  Widget _buildBeneficiaryCard(Map<String, String> beneficiary, int index) {
    String name = beneficiary["name"] ?? Strings.instance.notAvail;
    String image = beneficiary["image"] ?? "";
    String cnic = beneficiary["cnic"] ?? Strings.instance.notAvail;
    String number = beneficiary["number"] ?? Strings.instance.notAvail;
    String identity = beneficiary["identity"] ?? Strings.instance.notAvail;
    String relation = beneficiary["relation"] ?? Strings.instance.notAvail;
    String guardian = beneficiary["guardian"] ?? Strings.instance.notAvail;
    String nature = beneficiary["nature"] ?? Strings.instance.notAvail;
    String bank = beneficiary["bank"] ?? Strings.instance.notAvail;
    String accountTitle = beneficiary["accountTitle"] ?? Strings.instance.notAvail;
    String accountNumber = beneficiary["accountNumber"] ?? Strings.instance.notAvail;
    String address = beneficiary["address"] ?? Strings.instance.notAvail;

    bool isValidImage = image != "null" && 
                       image != "" && 
                       image != "NULL" &&
                       image != "-" &&
                       image != "N/A";

    Color relationColor = _getRelationColor(relation);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: relationColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: relationColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  relationColor,
                  relationColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Image
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.colors.newWhite.withOpacity(0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
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
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          relation,
                          style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w600,
                          ),
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
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                _buildSectionHeader("Personal Information", Icons.person, relationColor),
                SizedBox(height: 12),
                
                _buildInfoRow("CNIC", cnic, "Contact", number),
                SizedBox(height: 10),
                _buildInfoRow("Identity Type", identity, "Nature", nature),
                
                if (guardian != Strings.instance.notAvail && guardian != "-" && guardian != "null" && guardian.isNotEmpty)
                  SizedBox(height: 10),
                if (guardian != Strings.instance.notAvail && guardian != "-" && guardian != "null" && guardian.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: relationColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: relationColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          size: 16,
                          color: relationColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Guardian",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 10,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                guardian,
                                style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 12,
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
                  ),

                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Bank Information Section
                _buildSectionHeader("Bank Information", Icons.account_balance, relationColor),
                SizedBox(height: 12),
                
                _buildInfoRow("Bank Name", bank, "Account Nature", nature),
                SizedBox(height: 10),
                _buildInfoRow("Account Title", accountTitle, "Account Number", accountNumber),

                if (address != Strings.instance.notAvail && address != "-" && address != "null" && address.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                  SizedBox(height: 16),
                  
                  // Address Section
                  _buildSectionHeader("Address", Icons.location_on, relationColor),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.colorLightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      address,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 14,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(label1, value1),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildInfoItem(label2, value2),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    if (value == Strings.instance.notAvail || value == "-" || value == "null" || value.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorLightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 10,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 12,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getRelationColor(String relation) {
    if (relation == null || relation.isEmpty) return AppTheme.colors.newPrimary;
    
    String lowerRelation = relation.toLowerCase();
    if (lowerRelation.contains("son")) {
      return Color(0xFF2196F3); // Blue for Son
    } else if (lowerRelation.contains("daughter")) {
      return Color(0xFFE91E63); // Pink for Daughter
    } else if (lowerRelation.contains("widow")) {
      return Color(0xFF9C27B0); // Purple for Widow
    }
    return AppTheme.colors.newPrimary;
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
      List<String> tagsList = [constants.accountInfo, constants.inheritorInfo];
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
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var dataBody = body["Data"];
            if (dataBody != null) {
              var account = dataBody["account"];
              if (account != null) {
                var inheritors = account["inheritors"];
                
                beneficiariesList.clear();
                
                // Handle both single object and array
                if (inheritors != null) {
                  if (inheritors is List) {
                    // Multiple beneficiaries
                    inheritors.forEach((item) {
                      if (item != null) {
                        beneficiariesList.add({
                          "name": item["bene_name"]?.toString() ?? Strings.instance.notAvail,
                          "image": item["bene_upload"]?.toString() ?? "",
                          "cnic": item["bene_cnic"]?.toString() ?? Strings.instance.notAvail,
                          "number": item["bene_contact"]?.toString() ?? Strings.instance.notAvail,
                          "identity": item["bene_identity"]?.toString() ?? Strings.instance.notAvail,
                          "relation": item["bene_relation"]?.toString() ?? Strings.instance.notAvail,
                          "guardian": item["bene_guardian"]?.toString() ?? Strings.instance.notAvail,
                          "nature": item["bene_nature"]?.toString() ?? Strings.instance.notAvail,
                          "bank": item["bene_bank"]?.toString() ?? Strings.instance.notAvail,
                          "accountTitle": item["bene_title"]?.toString() ?? Strings.instance.notAvail,
                          "accountNumber": item["bene_account"]?.toString() ?? Strings.instance.notAvail,
                          "address": item["bene_address"]?.toString() ?? Strings.instance.notAvail,
                        });
                      }
                    });
                  } else if (inheritors is Map) {
                    // Single beneficiary
                    beneficiariesList.add({
                      "name": inheritors["bene_name"]?.toString() ?? Strings.instance.notAvail,
                      "image": inheritors["bene_upload"]?.toString() ?? "",
                      "cnic": inheritors["bene_cnic"]?.toString() ?? Strings.instance.notAvail,
                      "number": inheritors["bene_contact"]?.toString() ?? Strings.instance.notAvail,
                      "identity": inheritors["bene_identity"]?.toString() ?? Strings.instance.notAvail,
                      "relation": inheritors["bene_relation"]?.toString() ?? Strings.instance.notAvail,
                      "guardian": inheritors["bene_guardian"]?.toString() ?? Strings.instance.notAvail,
                      "nature": inheritors["bene_nature"]?.toString() ?? Strings.instance.notAvail,
                      "bank": inheritors["bene_bank"]?.toString() ?? Strings.instance.notAvail,
                      "accountTitle": inheritors["bene_title"]?.toString() ?? Strings.instance.notAvail,
                      "accountNumber": inheritors["bene_account"]?.toString() ?? Strings.instance.notAvail,
                      "address": inheritors["bene_address"]?.toString() ?? Strings.instance.notAvail,
                    });
                  }
                }
                
                setState(() {
                  isLoading = false;
                  isError = beneficiariesList.isEmpty;
                  errorMessage = beneficiariesList.isEmpty ? Strings.instance.notAvail : "";
                });
                uiUpdates.DismissProgresssDialog();
              } else {
                setState(() {
                  isLoading = false;
                  isError = true;
                  errorMessage = Strings.instance.notAvail;
                });
                uiUpdates.DismissProgresssDialog();
              }
            } else {
              setState(() {
                isLoading = false;
                isError = true;
                errorMessage = Strings.instance.notAvail;
              });
              uiUpdates.DismissProgresssDialog();
            }
          } else {
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = Strings.instance.failedToGetInfo;
            });
            uiUpdates.DismissProgresssDialog();
            uiUpdates.ShowError(Strings.instance.failedToGetInfo);
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
}
