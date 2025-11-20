import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/EstateClaimModel.dart';
import 'package:wwf_apps/screens/home/employee/estate_claim_detail.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../network/api_service.dart';
import '../../../views/estate_claim_list_item.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../models/ClaimStageModel.dart';
import '../../../widgets/standard_header.dart';
import '../../../widgets/empty_state_widget.dart';

class EstateClaimList extends StatefulWidget {
  @override
  _EstateClaimListState createState() => _EstateClaimListState();
}

class _EstateClaimListState extends State<EstateClaimList> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<EstateClaimModel> list= [];

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
      backgroundColor: AppTheme.colors.white,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Estate Claims",
            ),

            isError ? Expanded(
              child: EmptyStates.noClaims(type: 'Estate'),
            ) : Flexible(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isError = false;
                  });
                  await Future.delayed(Duration(milliseconds: 500));
                  CheckTokenExpiry();
                },
                color: AppTheme.colors.newPrimary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 50),
                    itemBuilder: (_, int index) =>
                        EstateClaimListItem(list[index], constants: constants),
                    itemCount: this.list.length,
                  ),
                ),
              ),
            )
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
        // Load claim stages before loading claims
        LoadClaimStagesIfNeeded().then((_) {
          GetEstateClaims();
        });
      }
    });
  }

  // Load claim stages from information API if not already loaded
  Future<void> LoadClaimStagesIfNeeded() async {
    if (!ClaimStagesData.instance.hasStages()) {
      try {
        List<String> tagsList = [constants.accountInfo];
        Map data = {
          "user_id": UserSessions.instance.getUserID,
          "api_tags": jsonEncode(tagsList).toString(),
        };
        var url = constants.getApiBaseURL() + constants.authentication + "information";
        var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
        ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
        if (responseCodeModel.status == true) {
          var body = jsonDecode(response.body);
          String code = body["Code"]?.toString() ?? "0";
          if (code == "1") {
            var dataObj = body["Data"];
            ClaimStagesData.loadFromInformationResponse(dataObj);
          }
        }
      } catch (e) {
        // Silently fail
      }
    }
  }

  void GetEstateClaims() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      // Format: /claims/estate_claim/{user_id}/C/{comp_id}
      String userId = UserSessions.instance.getUserID;
      String compId = UserSessions.instance.getRefID; // comp_id for employer
      var url = constants.getApiBaseURL() + constants.claims + "estate_claim/" + userId + "/C/" + compId;
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var data= body["Data"];
            if(data != null) {
              List<dynamic> estateList = data is List ? data : [];
              list.clear();
              
              estateList.forEach((estateData) {
                String claim_id = estateData["claim_id"]?.toString() ?? "";
                String claim_scheme = estateData["claim_scheme"]?.toString() ?? "-";
                String scheme_name = estateData["scheme_name"]?.toString() ?? "-";
                String claim_balloting = estateData["claim_balloting"]?.toString() ?? "-";
                String claim_quota = estateData["claim_quota"]?.toString() ?? "-";
                String claim_dated = estateData["claim_dated"]?.toString() ?? "-";
                String claim_location = estateData["claim_location"]?.toString() ?? "-";
                String claim_abode = estateData["claim_abode"]?.toString() ?? "-";
                String claim_number = estateData["claim_number"]?.toString() ?? "-";
                String claim_floor = estateData["claim_floor"]?.toString() ?? "-";
                String claim_street = estateData["claim_street"]?.toString() ?? "-";
                String claim_block = estateData["claim_block"]?.toString() ?? "-";
                String claim_amount = estateData["claim_amount"]?.toString() ?? "-";
                String claim_payment = estateData["claim_payment"]?.toString() ?? "-";
                String claim_balance = estateData["claim_balance"]?.toString() ?? "-";
                String claim_impound = estateData["claim_impound"]?.toString() ?? "-";
                
                // Optional user fields
                String user_name = estateData["user_name"]?.toString() ?? "";
                String user_image = estateData["user_image"]?.toString() ?? "";
                String user_cnic = estateData["user_cnic"]?.toString() ?? "";
                String user_gender = estateData["user_gender"]?.toString() ?? "";
                String emp_id = estateData["emp_id"]?.toString() ?? "";
                
                list.add(new EstateClaimModel(
                  claim_id,
                  claim_scheme,
                  scheme_name,
                  claim_balloting,
                  claim_quota,
                  claim_dated,
                  claim_location,
                  claim_abode,
                  claim_number,
                  claim_floor,
                  claim_street,
                  claim_block,
                  claim_amount,
                  claim_payment,
                  claim_balance,
                  claim_impound,
                  user_name: user_name,
                  user_image: user_image,
                  user_cnic: user_cnic,
                  user_gender: user_gender,
                  emp_id: emp_id,
                ));
              });

              setState(() {
                isError= false;
              });
            } else {
              setState(() {
                isError= true;
                errorMessage = Strings.instance.notFound;
              });
            }
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
}

