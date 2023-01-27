import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/fee_claim_list_item.dart';
import 'package:welfare_claims_app/itemviews/other_claim_list_item.dart';
import 'package:welfare_claims_app/models/FeeClaimModel.dart';
import 'package:welfare_claims_app/models/OtherClaimModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/create_fee_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/fee_claim_detail.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/other_claim_detail.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

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
                      child: Center(
                        child: Text(
                          errorMessageFee,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal),
                        ),
                      ),
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
                      child: Center(
                        child: Text(
                          errorMessageOthers,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal),
                        ),
                      ),
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
    //uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.claims +
        "edu_claims/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken;
    print(url);
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];

        /// fee claims
        List<dynamic> entitlements = data["Fee"];
        if(entitlements.length > 0)
        {
          listFee.clear();
          entitlements.forEach((row) {
            String claim_id= row["claim_id"].toString();
            String for_whom= row["for_whom"].toString();
            String child_id= row["child_id"].toString();
            String child_name= row["child_name"].toString();
            String claim_started= row["claim_started"].toString();
            String claim_ended= row["claim_ended"].toString();
            String claim_amount= row["claim_amount"].toString();
            String other_charges= row["other_charges"].toString();
            String tuition_fee= row["tuition_fee"].toString();
            String claim_payment= row["claim_payment"].toString();
            String claim_stage= row["claim_stage"].toString();
            String created_at= row["created_at"].toString();
            listFee.add(new FeeClaimModel(claim_id, for_whom, child_id, child_name, claim_started, claim_ended, claim_amount, other_charges, tuition_fee, claim_payment, claim_stage, created_at));
          });

          isErrorFee= false;
        }else
        {
          isErrorFee= true;
          errorMessageFee = "Fee Claims Not Available";
        }

        /// others claims
        List<dynamic> entitlementsOthers = data["Other"];
        if(entitlementsOthers.length > 0)
        {
          listOther.clear();
          entitlementsOthers.forEach((row) {
            String claim_id= row["claim_id"].toString();
            String for_whom= row["for_whom"].toString();
            String child_name= row["child_name"].toString();
            String child_id= row["child_id"].toString();
            String claim_year= row["claim_year"].toString();
            String claim_biannual= row["claim_biannual"].toString();
            String claim_amount= row["claim_amount"].toString();
            String claim_excluded= row["claim_excluded"].toString();
            String claim_payment= row["claim_payment"].toString();
            String claim_stage= row["claim_stage"].toString();
            String created_at= row["created_at"].toString();
            listOther.add(new OtherClaimModel(claim_id, for_whom, child_name, child_id, claim_year, claim_biannual, claim_amount, claim_excluded, claim_payment, claim_stage, created_at));
          });

          isErrorOthers= false;
        }else
        {
          isErrorOthers= true;
          errorMessageOthers = "Other Claims Not Available";
        }

        setState(() {
        });
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
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
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.claims +
        "edu_check/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken + "/emp_id--" +UserSessions.instance.getRefID;
    print(url);
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      uiUpdates.DismissProgresssDialog();
      if (code == "1") {
        var data= body["Data"];
        if(data != null){
          String edu_living= data["edu_living"].toString();
          String edu_mess= data["edu_mess"].toString();
          String edu_transport= data["edu_transport"].toString();
          String edu_nature= data["edu_nature"].toString();
          String edu_level= data["edu_level"].toString();
          String stip_amount= data["stip_amount"].toString();

          if(isFromFee) {
            uiUpdates.DismissProgresssDialog();
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    CreateFeeClaim(
                        edu_living, edu_mess, edu_transport, edu_nature,
                        edu_level, stip_amount)
            ));
          }else{
            uiUpdates.DismissProgresssDialog();
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    CreateOtherClaim(
                        edu_living, edu_mess, edu_transport, edu_nature,
                        edu_level, stip_amount)
            ));
          }
        }else{
          uiUpdates.DismissProgresssDialog();
          uiUpdates.ShowToast(Strings.instance.please_add_education_first);
        }
      } else {
        uiUpdates.DismissProgresssDialog();
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.please_add_education_first);
    }
  }
}
