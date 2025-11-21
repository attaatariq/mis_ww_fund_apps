import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/views/interst_distribution_item.dart';
import 'package:wwf_apps/models/InterstDistributionModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/screens/home/employer/annexure2_create.dart';
import 'package:wwf_apps/screens/home/employer/annexure2_create_new.dart';
import 'package:wwf_apps/widgets/standard_header.dart';

import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../widgets/empty_state_widget.dart';

class InterstDistributionList extends StatefulWidget {
  @override
  _InterstDistributionListState createState() => _InterstDistributionListState();
}

class _InterstDistributionListState extends State<InterstDistributionList> {
  List<InterstDistributionModel> list = [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool isError = false;
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
            title: "Interest Distribution Sheet",
            subtitle: list.isNotEmpty
                ? "${list.length} ${list.length == 1 ? 'Record' : 'Records'}"
                : null,
            actionIcon: Icons.add_box_outlined,
            onActionPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Annex3ANew()
              )).then((value) {
                if (value == true) {
                  setState(() {
                    list.clear();
                    isLoading = true;
                  });
                  GetAllAnnexA();
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
                              GetAllAnnexA();
                            },
                            color: AppTheme.colors.newPrimary,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: list.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  InterstDistributionModel annexure = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: InterstDistributionItem(annexure),
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
              errorMessage.isNotEmpty ? errorMessage : "No Interest Distribution Available",
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
                GetAllAnnexA();
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
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              "No Interest Distribution",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Interest distribution records will appear here once available",
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
        GetAllAnnexA();
      }
    });
  }

  void GetAllAnnexA() async {
    try {
      String userId = UserSessions.instance.getUserID;
      String compId = UserSessions.instance.getRefID;
      
      // API endpoint: /companies/annexure_2/{user_id}/{comp_id}
      var url = constants.getApiBaseURL() + 
                constants.companies + 
                "annexure_2/" + 
                userId + "/" + 
                compId;
      
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
            List<dynamic> entitlements = body["Data"] != null ? (body["Data"] is List ? body["Data"] : []) : [];
            
            list.clear();
            
            if (entitlements.isNotEmpty) {
              entitlements.forEach((row) {
                list.add(InterstDistributionModel(
                  anx_id: row["anx_id"]?.toString() ?? "",
                  comp_id: row["comp_id"]?.toString() ?? "",
                  anx_year: row["anx_year"]?.toString() ?? "",
                  anx_financial: row["anx_financial"]?.toString() ?? "",
                  anx_received: row["anx_received"]?.toString() ?? "",
                  anx_dispensed: row["anx_dispensed"]?.toString() ?? "",
                  anx_workers: row["anx_workers"]?.toString() ?? "",
                  anx_transfered: row["anx_transfered"]?.toString() ?? "",
                  anx_bank: row["anx_bank"]?.toString() ?? "",
                  anx_payment: row["anx_payment"]?.toString() ?? "",
                  anx_paid_at: row["anx_paid_at"]?.toString() ?? "",
                  anx_proof: row["anx_proof"]?.toString() ?? "",
                  anx_mode: row["anx_mode"]?.toString() ?? "",
                  anx_number: row["anx_number"]?.toString() ?? "",
                  anx_statement: row["anx_statement"]?.toString() ?? "",
                  comp_name: row["comp_name"]?.toString() ?? "",
                  comp_logo: row["comp_logo"]?.toString() ?? "",
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
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = Strings.instance.somethingWentWrong;
        });
      }
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
  }
}
