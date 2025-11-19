import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/views/wpf_distribution_item.dart';
import 'package:wwf_apps/models/WPFDistributionModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/screens/home/employer/annexure1_create.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../widgets/empty_state_widget.dart';

class WpfDistributionList extends StatefulWidget {
  @override
  _WpfDistributionListState createState() => _WpfDistributionListState();
}

class _WpfDistributionListState extends State<WpfDistributionList> {
  List<WPFDistributionModel> list = [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";

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
                          child: Text("WPF Distribution Sheet",
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
                            builder: (context) => AnnexA()
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
              child: EmptyStateWidget(
                icon: Icons.description_outlined,
                message: 'No WPF Distribution Available',
                description: 'WPF distribution records will appear here once available.',
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
                          child: WPFDistributionItem(list[index])),
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
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL()+constants.buildApiUrl(constants.companies+"annexure_1/", UserSessions.instance.getUserID, additionalPath: UserSessions.instance.getRefID);
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            List<dynamic> entitlements= body["Data"] != null ? body["Data"] : [];
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
            String anx_amount_1= row["anx_amount_1"].toString();
            String anx_amount_2= row["anx_amount_2"].toString();
            String anx_amount_3= row["anx_amount_3"].toString();
            String anx_dispense_1= row["anx_dispense_1"].toString();
            String anx_dispense_2= row["anx_dispense_2"].toString();
            String anx_dispense_3= row["anx_dispense_3"].toString();
            String anx_dispensed= row["anx_dispensed"].toString();
            String anx_transfered= row["anx_transfered"].toString();
            String anx_mode= row["anx_mode"].toString();
            String anx_number= row["anx_number"].toString();
            String anx_proof= row["anx_proof"].toString();
            String anx_bank= row["anx_bank"].toString();
            String anx_payment= row["anx_payment"].toString();
            String anx_paid_at= row["anx_paid_at"].toString();
            String anx_percent= row["anx_percent"].toString();
            String anx_employees= row["anx_employees"].toString();
            String anx_medium= row["anx_medium"].toString();
            String created_at= row["created_at"].toString();
            list.add(WPFDistributionModel(anx_id, comp_id, anx_year, anx_statement, anx_received, anx_financial, anx_net_profit, anx_allocated, anx_count_cat1, anx_count_cat2, anx_count_cat3, anx_workers, anx_amount_1, anx_amount_2, anx_amount_3, anx_dispense_1, anx_dispense_2, anx_dispense_3, anx_dispensed, anx_transfered, anx_mode, anx_number, anx_proof, anx_bank, anx_payment, anx_paid_at, anx_percent, anx_employees, anx_medium, created_at));
          });
              setState(() {
                isError = false;
              });
            }else{
              setState(() {
                isError = true;
                errorMessage = Strings.instance.notAvail;
              });
            }
          } else {
            setState(() {
              isError = true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isError = true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Data"] != null ? body["Data"].toString() : "";
          if(message == constants.expireToken){
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          }else if(message.isNotEmpty && message != "null"){
            uiUpdates.ShowToast(message);
          } else {
            setState(() {
              isError = true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isError = true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = Strings.instance.notAvail;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
