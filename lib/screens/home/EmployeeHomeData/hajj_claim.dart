import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/ImageViewer/ImageViewer.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/hajj_claim_item.dart';
import 'package:welfare_claims_app/models/HajjClaimModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:welfare_claims_app/widgets/empty_state_widget.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:http/http.dart' as http;

class HajjClaim extends StatefulWidget {
  @override
  _HajjClaimState createState() => _HajjClaimState();
}

class _HajjClaimState extends State<HajjClaim> {
  Constants constants;
  UIUpdates uiUpdates;
  String reciptDocURL="";
  bool isError= false;
  List<HajjClaimModel> list = [];
  String errorMessage="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
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
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Hajj Claim",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            isError ? Expanded(
              child: EmptyStates.noClaims(type: 'Hajj'),
            ) : Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (_, int index) =>
                      HajjClaimItem(constants, list[index]),
                  itemCount: this.list.length,
                ),
              ),
            ),

            SizedBox(height: 40,)
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
        GetHajjClaim();
      }
    });
  }

  void GetHajjClaim() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "hajj_claim/", 
          UserSessions.instance.getUserID, 
          additionalPath: "C/4");
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
            if(claims.length > 0){
              list.clear();
              claims.forEach((element) {
                String claim_year= element["claim_year"]?.toString() ?? "";
                String claim_receipt= element["claim_receipt"]?.toString() ?? "";
                String claim_amount= element["claim_amount"]?.toString() ?? "";
                String created_at= element["created_at"]?.toString() ?? "";
                String user_name= element["user_name"]?.toString() ?? "";
                String comp_name= element["comp_name"]?.toString() ?? "";
                String emp_about= element["emp_about"]?.toString() ?? "";
                list.add(new HajjClaimModel(claim_year, claim_receipt, claim_amount, created_at, user_name, comp_name, emp_about));
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
            String message = body["Data"]?.toString() ?? Strings.instance.notAvail;
            setState(() {
              isError= true;
              errorMessage = message;
            });
          }
        } catch (e) {
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
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
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      // Add small delay to ensure dialog is shown before dismissing
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
