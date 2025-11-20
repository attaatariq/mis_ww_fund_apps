import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/pay_installment_dialog_model.dart';
import 'package:wwf_apps/views/installment_item.dart';
import 'package:wwf_apps/models/EstateClaimModel.dart';
import 'package:wwf_apps/models/InstallmentModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';

class EstateClaim extends StatefulWidget {
  @override
  _EstateClaimState createState() => _EstateClaimState();
}

class _EstateClaimState extends State<EstateClaim> {
  String claim_balloting="-", claim_scheme="-", scheme_name="-", claim_location="-", claim_quota="-", claim_dated="-", claim_abode="-", claim_number="-", claim_floor="-",
      claim_street="-", claim_block="-", claim_impound="-", claim_amount="-", claim_payment="-", claim_balance="-", created_at="";
  String claim_id = ""; // Store claim ID for fetching installments
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  bool hasEstateData = false;
  bool hasInstallmentError = false;
  String installmentErrorMessage = "";
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
                    hasEstateData ? Container(
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
                                        "archive/images/estate.png"),
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
                                    scheme_name != "-" ? scheme_name : claim_scheme,
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
                    ) : Container(),

                    hasEstateData ? SizedBox(height: 20,) : Container(),

                    hasEstateData ? Padding(
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
                    ) : Container(),

                    !hasEstateData ? Expanded(
                      child: EmptyStates.noClaims(type: 'Estate'),
                    ) : hasInstallmentError ? Expanded(
                      child: EmptyStateWidget(
                        icon: Icons.receipt_long_outlined,
                        message: 'No Installments Available',
                        description: 'There are no installments for this estate claim.',
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
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      // Format: /claims/estate_claim/{user_id}/E/{emp_id}
      String userId = UserSessions.instance.getUserID;
      String empId = UserSessions.instance.getEmployeeID;
      var url = constants.getApiBaseURL() + constants.claims + "estate_claim/" + userId + "/E/" + empId;
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
            // API returns an array - employee gets first item (single claim)
            if(data != null) {
              List<dynamic> estateList = data is List ? data : [];
              if(estateList.isNotEmpty) {
                var estateData = estateList[0]; // Get first claim for employee
                
                claim_balloting= estateData["claim_balloting"]?.toString() ?? "-";
                claim_scheme= estateData["claim_scheme"]?.toString() ?? "-";
                scheme_name= estateData["scheme_name"]?.toString() ?? "-";
                claim_location= estateData["claim_location"]?.toString() ?? "-";
                claim_quota= estateData["claim_quota"]?.toString() ?? "-";
                claim_dated= estateData["claim_dated"]?.toString() ?? "-";
                claim_abode= estateData["claim_abode"]?.toString() ?? "-";
                claim_number= estateData["claim_number"]?.toString() ?? "-";
                claim_floor= estateData["claim_floor"]?.toString() ?? "-";
                claim_street= estateData["claim_street"]?.toString() ?? "-";
                claim_block= estateData["claim_block"]?.toString() ?? "-";
                claim_impound= estateData["claim_impound"]?.toString() ?? "-";
                claim_amount= estateData["claim_amount"]?.toString() ?? "-";
                claim_payment= estateData["claim_payment"]?.toString() ?? "-";
                claim_balance= estateData["claim_balance"]?.toString() ?? "-";
                claim_id = estateData["claim_id"]?.toString() ?? "";
                created_at= ""; // Not in API response

                setState(() {
                  hasEstateData = true;
                  isError= false;
                });
                
                // Now fetch installments from estate_detail API
                if (claim_id.isNotEmpty) {
                  GetEstateInstallments(claim_id);
                } else {
                  setState(() {
                    hasEstateData = true;
                    hasInstallmentError = true;
                    installmentErrorMessage = Strings.instance.notFound;
                  });
                }
              } else {
                setState(() {
                  hasEstateData = false;
                  isError= true;
                  errorMessage = Strings.instance.notFound;
                });
              }
            } else {
              setState(() {
                hasEstateData = false;
                isError= true;
                errorMessage = Strings.instance.notFound;
              });
            }
          } else {
            setState(() {
              hasEstateData = false;
              isError= true;
              errorMessage = Strings.instance.notFound;
            });
          }
        } catch (e) {
          setState(() {
            hasEstateData = false;
            isError= true;
            errorMessage = Strings.instance.notFound;
          });
        }
      } else {
        if(responseCodeModel.message != null && responseCodeModel.message != "null") {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
        setState(() {
          hasEstateData = false;
          isError= true;
          errorMessage = Strings.instance.notFound;
        });
      }
    } catch (e) {
      setState(() {
        hasEstateData = false;
        isError= true;
        errorMessage = Strings.instance.notFound;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      // Add small delay to ensure dialog is shown before dismissing
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }

  void GetEstateInstallments(String claimId) async {
    try {
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "estate_detail/", 
          UserSessions.instance.getUserID,
          additionalPath: claimId);
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
          
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var data = body["Data"];
            if(data != null) {
              List<dynamic> instalments = data["instalments"] != null ? data["instalments"] : [];
              if(instalments.length > 0) {
                list.clear();
                instalments.forEach((row) {
                  String ins_id= row["ins_id"]?.toString() ?? "";
                  String ins_number= row["ins_number"]?.toString() ?? "";
                  String ins_amount= row["ins_amount"]?.toString() ?? "";
                  String ins_payment= row["ins_payment"]?.toString() ?? "";
                  String ins_balance= row["ins_balance"]?.toString() ?? "";
                  String ins_duedate= row["ins_duedate"]?.toString() ?? "";
                  String deposited_at= row["deposited_at"]?.toString() ?? "";
                  String ins_bank_name= row["ins_bank_name"]?.toString() ?? "";
                  String ins_challan_no= row["ins_challan_no"]?.toString() ?? "";
                  String ins_challan= row["ins_challan"]?.toString() ?? "";
                  String ins_remarks= row["ins_remarks"]?.toString() ?? "";
                  String created_at= row["created_at"]?.toString() ?? "";
                  list.add(new InstallmentModel(ins_id, ins_number, ins_amount, ins_payment, ins_balance, ins_duedate, deposited_at, ins_bank_name, ins_challan_no, ins_challan, ins_remarks, created_at));
                });

                setState(() {
                  hasInstallmentError = false;
                });
              } else {
                setState(() {
                  hasInstallmentError = true;
                  installmentErrorMessage = Strings.instance.notFound;
                });
              }
            } else {
              setState(() {
                hasInstallmentError = true;
                installmentErrorMessage = Strings.instance.notFound;
              });
            }
          } else {
            setState(() {
              hasInstallmentError = true;
              installmentErrorMessage = Strings.instance.notFound;
            });
          }
        } catch (e) {
          setState(() {
            hasInstallmentError = true;
            installmentErrorMessage = Strings.instance.notFound;
          });
        }
      } else {
        setState(() {
          hasInstallmentError = true;
          installmentErrorMessage = Strings.instance.notFound;
        });
      }
    } catch (e) {
      setState(() {
        hasInstallmentError = true;
        installmentErrorMessage = Strings.instance.notFound;
      });
    }
  }
}
