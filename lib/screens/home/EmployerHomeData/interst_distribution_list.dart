import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/itemviews/interst_distribution_item.dart';
import 'package:welfare_claims_app/models/InterstDistributionModel.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/annex3A.dart';

import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';

class InterstDistributionList extends StatefulWidget {

  @override
  _InterstDistributionListState createState() => _InterstDistributionListState();
}

class _InterstDistributionListState extends State<InterstDistributionList> {
  List<InterstDistributionModel> list = [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          child: Text("Interest Distribution Sheet",
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

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Annex3A()
                        )).then((value) => {
                          setState(() {})
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.add_box_outlined, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            isError ? Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal),
                  ),
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
                            // Navigator.push(context, MaterialPageRoute(
                            //     builder: (context) => OtherClaimDetail(listOther[index].claim_id)
                            // ));
                          },
                          child: InterstDistributionItem(list[index])),
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
        GetAllAnnexA();
      }
    });
  }

  void GetAllAnnexA() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.companies+"annexure2/"+UserSessions.instance.getUserID+"/"+UserSessions.instance.getToken+"/"+UserSessions.instance.getRefID;
    var response = await http.get(Uri.parse(url));
    print(url);
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        List<dynamic> entitlements= body["Data"];
        if(entitlements.isNotEmpty){
          list.clear();
          entitlements.forEach((row) {
            String anx_id= row["anx_id"].toString();
            String comp_id= row["comp_id"].toString();
            String anx_year= row["anx_year"].toString();
            String anx_statement= row["anx_statement"].toString();
            String anx_received= row["anx_received"].toString();
            String anx_financial= row["anx_financial"].toString();
            String anx_net_profit= row["anx_net_profit"].toString();
            String anx_allocated= row["anx_allocated"].toString();
            String anx_count_cat1= row["anx_count_cat1"].toString();
            String anx_count_cat2= row["anx_count_cat2"].toString();
            String anx_count_cat3= row["anx_count_cat3"].toString();
            String anx_workers= row["anx_workers"].toString();
            String anx_dispense_1= row["anx_dispense_1"].toString();
            String anx_dispense_2= row["anx_dispense_2"].toString();
            String anx_dispense_3= row["anx_dispense_3"].toString();
            String anx_dispensed= row["anx_dispensed"].toString();
            String anx_paid_com= row["anx_paid_com"].toString();
            String anx_paid_bot= row["anx_paid_bot"].toString();
            String anx_interest= row["anx_interest"].toString();
            String anx_invest_co= row["anx_invest_co"].toString();
            String anx_invest_bot= row["anx_invest_bot"].toString();
            String anx_transfered= row["anx_transfered"].toString();
            String anx_mode= row["anx_mode"].toString();
            String anx_number= row["anx_number"].toString();
            String anx_proof= row["anx_proof"].toString();
            String anx_bank= row["anx_bank"].toString();
            String anx_payment= row["anx_payment"].toString();
            String anx_paid_at= row["anx_paid_at"].toString();
            String anx_medium= row["anx_medium"].toString();
            String created_at= row["created_at"].toString();
            list.add(InterstDistributionModel(anx_id, comp_id, anx_year, anx_statement, anx_received, anx_financial, anx_net_profit, anx_allocated, anx_count_cat1, anx_count_cat2, anx_count_cat3, anx_workers, anx_dispense_1, anx_dispense_2, anx_dispense_3, anx_dispensed, anx_paid_com, anx_paid_bot, anx_interest, anx_invest_co, anx_invest_bot, anx_transfered, anx_mode, anx_number, anx_proof, anx_bank, anx_payment, anx_paid_at, anx_medium, created_at));
          });
        }else{
          isError = true;
          errorMessage = Strings.instance.notAvail;
        }
      } else {
        isError = true;
        errorMessage = Strings.instance.notAvail;
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
      }
    } else {
      var body = jsonDecode(response.body);
      String message = body["Data"].toString();
      if(message == constants.expireToken){
        isError = true;
        errorMessage = Strings.instance.notAvail;
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        isError = true;
        errorMessage = message;
      }
    }

    setState(() {});
  }
}
