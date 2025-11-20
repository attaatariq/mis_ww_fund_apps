import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/HajjClaimModel.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../network/api_service.dart';
import '../../../views/hajj_claim_item.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../widgets/empty_state_widget.dart';

class HajjClaimList extends StatefulWidget {
  @override
  _HajjClaimListState createState() => _HajjClaimListState();
}

class _HajjClaimListState extends State<HajjClaimList> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<HajjClaimModel> list= [];

  @override
  void initState() {
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
                        "Hajj Claims",
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
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      CheckTokenExpiry();
                    },
                    color: AppTheme.colors.newPrimary,
                    child: list.isEmpty
                        ? Center(
                            child: EmptyStates.noClaims(type: 'Hajj'),
                          )
                        : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
                                ...list.map((claim) => HajjClaimItem(constants, claim)).toList(),
                              ],
                            ),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        GetHajjClaims();
      }
    });
  }

  void GetHajjClaims() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      // Format: /claims/hajj_claim/{user_id}/C/{comp_id}
      String userId = UserSessions.instance.getUserID;
      String compId = UserSessions.instance.getRefID; // comp_id for employer
      
      // If comp_id is empty or "null", try to fetch from information API
      if (compId.isEmpty || compId == "" || compId == "null") {
        compId = await _fetchCompanyID();
      }
      
      if (compId.isEmpty || compId == "" || compId == "null") {
        setState(() {
          isError = true;
          errorMessage = "Company ID not found. Please try again.";
        });
        uiUpdates.DismissProgresssDialog();
        return;
      }
      
      var url = constants.getApiBaseURL() + constants.claims + "hajj_claim/" + userId + "/C/" + compId;
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            List<dynamic> claims= body["Data"] ?? [];
            list.clear();
            
            claims.forEach((element) {
              String claim_year= element["claim_year"]?.toString() ?? "";
              String claim_receipt= element["claim_receipt"]?.toString() ?? "";
              String claim_amount= element["claim_amount"]?.toString() ?? "";
              String created_at= element["created_at"]?.toString() ?? "";
              String user_name= element["user_name"]?.toString() ?? "";
              String comp_name= element["comp_name"]?.toString() ?? "";
              list.add(new HajjClaimModel(claim_year, claim_receipt, claim_amount, created_at, user_name, comp_name));
            });

            setState(() {
              isError= false;
            });
          } else {
            String message = body["Message"] != null ? body["Message"].toString() : "";
            if(message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            } else {
              uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
            }
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notFound;
            });
          }
        } catch (e) {
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notFound;
          });
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        }
      } else {
        if(responseCodeModel.message != null && responseCodeModel.message != "null") {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
        setState(() {
          isError= true;
          errorMessage = Strings.instance.notFound;
        });
      }
    } catch (e) {
      setState(() {
        isError= true;
        errorMessage = Strings.instance.notFound;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
  
  Future<String> _fetchCompanyID() async {
    try {
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String code = body["Code"]?.toString() ?? "0";
        if (code == "1" || body["Code"] == 1) {
          var dataObj = body["Data"];
          var account = dataObj["account"];
          if (account != null && account["comp_id"] != null) {
            String compId = account["comp_id"].toString();
            if (compId.isNotEmpty && compId != "null") {
              UserSessions.instance.setRefID(compId);
              return compId;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail
    }
    return "";
  }
}

