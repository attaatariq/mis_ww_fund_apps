import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/pay_installment_dialog_model.dart';
import 'package:welfare_claims_app/itemviews/installment_item.dart';
import 'package:welfare_claims_app/models/EstateClaimModel.dart';
import 'package:welfare_claims_app/models/InstallmentModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EstateClaim extends StatefulWidget {
  @override
  _EstateClaimState createState() => _EstateClaimState();
}

class _EstateClaimState extends State<EstateClaim> {
  String claim_balloting="-", claim_scheme="-", claim_location="-", claim_quota="-", claim_dated="-", claim_abode="-", claim_number="-", claim_floor="-",
      claim_street="-", claim_block="-", claim_impound="-", claim_amount="-", claim_payment="-", claim_balance="-", created_at="";
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<InstallmentModel> list= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetEstateClaim();
  }

  void parentFunction()
  {
    GetEstateClaim();
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
                      child: Text("Estate Claim",
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

            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.newPrimary,
                                  borderRadius: BorderRadius.circular(50),
                                ),

                                child: Center(
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/estate_claim.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newWhite,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10,),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    claim_scheme,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 13,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Text(
                                    "Baloting Date ("+claim_balloting+")",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.colorDarkGray,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Marit / Quota",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 8,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),

                                      Text(
                                        claim_quota,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.newBlack,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 1,
                                  color: AppTheme.colors.colorDarkGray,
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Allotment Date",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 8,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),

                                      Text(
                                        claim_dated,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.newBlack,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Possession Date",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 8,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),

                                      Text(
                                        claim_impound,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.newBlack,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 1,
                                  color: AppTheme.colors.colorDarkGray,
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Create Date",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 8,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),

                                      Text(
                                        created_at != "" ? constants.GetFormatedDateWithoutTime(created_at) : "-",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.newBlack,
                                            fontSize: 12,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10,),

                          Text(
                            "Address / Location",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.colorDarkGray,
                                fontSize: 8,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),

                          Text(
                            claim_abode+" "+claim_number+", Floor "+claim_floor+", Street "+claim_street+", Block "+claim_block+", "+claim_location,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 13,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newPrimary.withAlpha(200),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "(Account)",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15,),

                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            "Total Amount",
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.normal
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            claim_amount+" PKR",
                                            maxLines: 1,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 12,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(height: 3,),

                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            "Amount Paid",
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.normal
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            claim_payment+" PKR",
                                            maxLines: 1,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 12,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(height: 6,),

                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.newWhite
                                  ),
                                ),

                                SizedBox(height: 6,),

                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            "Remaining Balance",
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.normal
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            claim_balance+" PKR",
                                            maxLines: 1,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 12,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Installments ("+list.length.toString()+")",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 13,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    isError ? Expanded(
                      child: Center(
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.colors.white,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ) : Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (_, int index) =>
                              InstallmentItem(list[index], parentFunction),
                          itemCount: this.list.length,
                        ),
                      ),
                    ),
                  ],
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
      }
    });
  }

  void GetEstateClaim() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.claims +
        "estateclaims/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var allotments= data["Allotment"];
        claim_balloting= allotments["claim_balloting"];
        claim_scheme= allotments["claim_scheme"];
        claim_location= allotments["claim_location"];
        claim_quota= allotments["claim_quota"];
        claim_dated= allotments["claim_dated"];
        claim_abode= allotments["claim_abode"];
        claim_number= allotments["claim_number"];
        claim_floor= allotments["claim_floor"];
        claim_street= allotments["claim_street"];
        claim_block= allotments["claim_block"];
        claim_impound= allotments["claim_impound"];
        claim_amount= allotments["claim_amount"];
        claim_payment= allotments["claim_payment"];
        claim_balance= allotments["claim_balance"];
        created_at= allotments["created_at"];

        ///instalemnts
        List<dynamic> entitlements = data["installments"];
        if(entitlements.length > 0)
        {
          list.clear();
          entitlements.forEach((row) {
            String ins_id= row["ins_id"].toString();
            String ins_number= row["ins_number"].toString();
            String ins_amount= row["ins_amount"].toString();
            String ins_payment= row["ins_payment"].toString();
            String ins_balance= row["ins_balance"].toString();
            String ins_duedate= row["ins_duedate"].toString();
            String deposited_at= row["deposited_at"].toString();
            String ins_bank_name= row["ins_bank_name"].toString();
            String ins_challan_no= row["ins_challan_no"].toString();
            String ins_challan= row["ins_challan"].toString();
            String ins_remarks= row["ins_remarks"].toString();
            String created_at= row["created_at"].toString();
            list.add(new InstallmentModel(ins_id, ins_number, ins_amount, ins_payment, ins_balance, ins_duedate, deposited_at, ins_bank_name, ins_challan_no, ins_challan, ins_remarks, created_at));
          });

          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= false;
          });
        }else
        {
          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= true;
            errorMessage = "Installment Not Available";
          });
        }
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
}
