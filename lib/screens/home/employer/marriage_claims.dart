import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/MarriageClaimModel.dart';
import 'package:wwf_apps/screens/home/employee/marriage_claim_detail.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../network/api_service.dart';
import '../../../views/marriage_claim_list_item.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../models/ClaimStageModel.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/standard_header.dart';

class MarriageClaimList extends StatefulWidget {
  @override
  _MarriageClaimListState createState() => _MarriageClaimListState();
}

class _MarriageClaimListState extends State<MarriageClaimList> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<MarriageClaimModel> list= [];

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
      backgroundColor: AppTheme.colors.white,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Marriage Claims",
            ),

            isError ? Expanded(
              child: EmptyStates.noClaims(type: 'Marriage'),
            ) : Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 50),
                  itemBuilder: (_, int index) =>
                      MarriageClaimListItem(list[index], constants: constants),
                  itemCount: this.list.length,
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
          GetMarriageClaims();
        });
      }
    });
  }

  // Load claim stages from information API if not already loaded
  Future<void> LoadClaimStagesIfNeeded() async {
    // Only load if claim stages are not already available
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
        // Silently fail - claim stages might be loaded from login
      }
    }
  }

  void GetMarriageClaims() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL()+constants.buildApiUrl(constants.claims+"marriage_claim/", UserSessions.instance.getUserID, additionalPath: "C/"+UserSessions.instance.getRefID);
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            List<dynamic> marriageList= body["Data"] ?? [];
            if(marriageList.length > 0){
              list.clear();
              marriageList.forEach((element) {
                String claim_id= element["claim_id"]?.toString() ?? "";
                String claim_husband= element["claim_husband"]?.toString() ?? "";
                String claim_dated= element["claim_dated"]?.toString() ?? "";
                String beneficiary= element["beneficiary"]?.toString() ?? "";
                String claim_stage= element["claim_stage"]?.toString() ?? "";
                String user_name= element["user_name"]?.toString() ?? "";
                String user_image= element["user_image"]?.toString() ?? "";
                String user_cnic= element["user_cnic"]?.toString() ?? "";
                list.add(MarriageClaimModel(
                  claim_id, 
                  claim_husband, 
                  claim_dated, 
                  beneficiary, 
                  claim_stage,
                  user_name: user_name,
                  user_image: user_image,
                  user_cnic: user_cnic,
                ));
              });

              setState(() {
                isError= false;
              });
            }else{
              setState(() {
                isError= true;
                errorMessage = Strings.instance.notFound;
              });
            }
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
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"]?.toString() ?? "";
          
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
      // Add small delay to ensure dialog is shown before dismissing
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
