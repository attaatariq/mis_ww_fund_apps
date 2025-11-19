import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/fee_claim_list_item.dart';
import 'package:wwf_apps/views/other_claim_list_item.dart';
import 'package:wwf_apps/models/FeeClaimModel.dart';
import 'package:wwf_apps/models/OtherClaimModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/home/employee/create_fee_claim.dart';
import 'package:wwf_apps/screens/home/employee/fee_claim_detail.dart';
import 'package:wwf_apps/screens/home/employee/other_claim_detail.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/network/api_service.dart';

import 'create_other_claim.dart';

class EducationClaimList extends StatefulWidget {
  @override
  _EducationClaimListState createState() => _EducationClaimListState();
}

class _EducationClaimListState extends State<EducationClaimList> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isErrorFee= false, isErrorOthers= false, isEducationClaimSelected= true;
  String errorMessageFee="", errorMessageOthers="";
  List<FeeClaimModel> listFee= [];
  List<OtherClaimModel> listOther= [];

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
      backgroundColor: AppTheme.colors.newWhite,
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
                      child: Text("Education Claims",
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

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      CheckEducationDetail(true);
                    },
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newPrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppTheme.colors.newWhite, size: 15,),

                          SizedBox(width: 5,),

                          Text("Create Fee Claim",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      CheckEducationDetail(false);
                    },
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.only(left: 5, right: 20, top: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newPrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppTheme.colors.newWhite, size: 15,),

                          SizedBox(width: 5,),

                          Text("Create Other Claim",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 15,),

            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        isEducationClaimSelected= true;
                      });
                    },
                    child: Container(
                      height: 35,
                      width: 120,
                      decoration: BoxDecoration(
                        color: isEducationClaimSelected ? AppTheme.colors.colorLightGray : AppTheme.colors.newWhite,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        border: isEducationClaimSelected ? Border.all(color: AppTheme.colors.colorDarkGray, width: 1) : null
                      ),
                      child: Center(
                        child: Text("Fee Claim",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),),
                      )
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        isEducationClaimSelected= false;
                      });
                    },
                    child: Container(
                      height: 35,
                      width: 120,
                      decoration: BoxDecoration(
                          color: !isEducationClaimSelected ? AppTheme.colors.colorLightGray : AppTheme.colors.newWhite,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                          border: !isEducationClaimSelected ? Border.all(color: AppTheme.colors.colorDarkGray, width: 1) : null
                      ),
                        child: Center(
                          child: Text("Other Claim",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),),
                        )
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: 1,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: AppTheme.colors.colorDarkGray,
              ),
            ),
            
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newWhite,
                ),

                child: isEducationClaimSelected ? Column(
                  children: [
                    isErrorFee ? Expanded(
                      child: EmptyStates.noClaims(type: 'Fee'),
                    ) : Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (_, int index) =>
                              InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => FeeClaimDetail(listFee[index].claim_id)
                                    ));
                                  },
                                  child: FeeClaimListItem(constants, listFee[index])),
                          itemCount: this.listFee.length,
                        ),
                      ),
                    )
                  ],
                ) : Column(
                  children: [
                    isErrorOthers ? Expanded(
                      child: EmptyStates.noClaims(type: 'Other Education'),
                    ) : Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (_, int index) =>
                              InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => OtherClaimDetail(listOther[index].claim_id)
                                    ));
                                  },
                                  child: OtherClaimListItem(constants, listOther[index])),
                          itemCount: this.listOther.length,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void GetCEducationClaims() async{
    try {
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "fee_claim/", 
          UserSessions.instance.getUserID, 
          additionalPath: "E/${UserSessions.instance.getRefID}");
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            /// fee claims
            List<dynamic> entitlements = body["Data"] ?? [];
            if(entitlements.length > 0)
            {
              listFee.clear();
              entitlements.forEach((row) {
                String claim_id= row["claim_id"]?.toString() ?? "";
                String for_whom= row["for_whom"]?.toString() ?? "";
                String child_id= row["child_id"]?.toString() ?? "";
                String child_name= row["child_name"]?.toString() ?? "";
                String claim_started= row["claim_started"]?.toString() ?? "";
                String claim_ended= row["claim_ended"]?.toString() ?? "";
                String claim_amount= row["claim_amount"]?.toString() ?? "";
                String other_charges= row["other_charges"]?.toString() ?? "";
                String tuition_fee= row["tuition_fee"]?.toString() ?? "";
                String claim_payment= row["claim_payment"]?.toString() ?? "";
                String claim_stage= row["claim_stage"]?.toString() ?? "";
                String created_at= row["created_at"]?.toString() ?? "";
                listFee.add(new FeeClaimModel(claim_id, for_whom, child_id, child_name, claim_started, claim_ended, claim_amount, other_charges, tuition_fee, claim_payment, claim_stage, created_at));
              });

              isErrorFee= false;
            }else
            {
              isErrorFee= true;
              errorMessageFee = Strings.instance.notFound;
            }

            /// others claims - Currently always empty, will be populated when available
            List<dynamic> entitlementsOthers = [];
            if(entitlementsOthers.length > 0)
            {
              listOther.clear();
              entitlementsOthers.forEach((row) {
                String claim_id= row["claim_id"]?.toString() ?? "";
                String for_whom= row["for_whom"]?.toString() ?? "";
                String child_name= row["child_name"]?.toString() ?? "";
                String child_id= row["child_id"]?.toString() ?? "";
                String claim_year= row["claim_year"]?.toString() ?? "";
                String claim_biannual= row["claim_biannual"]?.toString() ?? "";
                String claim_amount= row["claim_amount"]?.toString() ?? "";
                String claim_excluded= row["claim_excluded"]?.toString() ?? "";
                String claim_payment= row["claim_payment"]?.toString() ?? "";
                String claim_stage= row["claim_stage"]?.toString() ?? "";
                String created_at= row["created_at"]?.toString() ?? "";
                listOther.add(new OtherClaimModel(claim_id, for_whom, child_name, child_id, claim_year, claim_biannual, claim_amount, claim_excluded, claim_payment, claim_stage, created_at));
              });

              isErrorOthers= false;
            }else
            {
              isErrorOthers= true;
              errorMessageOthers = Strings.instance.notFound;
            }

            setState(() {
            });
          } else {
            String message = body["Message"]?.toString() ?? "";
            if(message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            }
            setState(() {
              isErrorFee= true;
              errorMessageFee = Strings.instance.notFound;
              isErrorOthers= true;
              errorMessageOthers = Strings.instance.notFound;
            });
          }
        } catch (e) {
          setState(() {
            isErrorFee= true;
            errorMessageFee = Strings.instance.notFound;
            isErrorOthers= true;
            errorMessageOthers = Strings.instance.notFound;
          });
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
        setState(() {
          isErrorFee= true;
          errorMessageFee = Strings.instance.notFound;
          isErrorOthers= true;
          errorMessageOthers = Strings.instance.notFound;
        });
      }
    } catch (e) {
      setState(() {
        isErrorFee= true;
        errorMessageFee = Strings.instance.notFound;
        isErrorOthers= true;
        errorMessageOthers = Strings.instance.notFound;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
    // Note: No progress dialog for this method as it was commented out
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        if(UserSessions.instance.getEmployeeID == ""){
          GetCEducationClaims();
        }
      }
    });
  }

  void CheckEducationDetail(bool isFromFee) async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "edu_check/", 
          UserSessions.instance.getUserID, 
          additionalPath: "emp_id--" + UserSessions.instance.getRefID);
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
            if(data != null){
              String edu_living= data["edu_living"]?.toString() ?? "0";
              String edu_mess= data["edu_mess"]?.toString() ?? "0";
              String edu_transport= data["edu_transport"]?.toString() ?? "0";
              String edu_nature= data["edu_nature"]?.toString() ?? "";
              String edu_level= data["edu_level"]?.toString() ?? "";
              String stip_amount= data["stip_amount"]?.toString() ?? "0";

              if(isFromFee) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CreateFeeClaim(
                            edu_living, edu_mess, edu_transport, edu_nature,
                            edu_level, stip_amount)
                ));
              }else{
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CreateOtherClaim(
                            edu_living, edu_mess, edu_transport, edu_nature,
                            edu_level, stip_amount)
                ));
              }
            }else{
              // Navigate anyway with default values - allows adding child claims
              String defaultValue = "0";
              String defaultString = "";
              if(isFromFee) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CreateFeeClaim(
                            defaultValue, defaultValue, defaultValue, defaultString,
                            defaultString, defaultValue)
                ));
              }else{
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CreateOtherClaim(
                            defaultValue, defaultValue, defaultValue, defaultString,
                            defaultString, defaultValue)
                ));
              }
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if(message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            } else {
              // Navigate anyway with default values
              String defaultValue = "0";
              String defaultString = "";
              if(isFromFee) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CreateFeeClaim(
                            defaultValue, defaultValue, defaultValue, defaultString,
                            defaultString, defaultValue)
                ));
              }else{
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CreateOtherClaim(
                            defaultValue, defaultValue, defaultValue, defaultString,
                            defaultString, defaultValue)
                ));
              }
            }
          }
        } catch (e) {
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    } catch (e) {
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      uiUpdates.DismissProgresssDialog();
    }
  }
}
