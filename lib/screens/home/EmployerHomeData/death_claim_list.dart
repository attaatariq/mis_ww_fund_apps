import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../colors/app_colors.dart';
import '../../../constants/Constants.dart';
import '../../../itemviews/death_calim_list_item.dart';
import '../../../models/DeathClaimModel.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';

class DeathClaimList extends StatefulWidget {
  @override
  _DeathClaimListState createState() => _DeathClaimListState();
}

class _DeathClaimListState extends State<DeathClaimList> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<DeathClaimModel> list= [];

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
                          child: Text("Death Claims",
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
                  ],
                ),
              ),
            ),

            isError ? Expanded(
              child: Center(
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
            ) : Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 50),
                  itemBuilder: (_, int index) =>
                      DeathClaimListItem(list[index]),
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
        GetDeathClaims();
      }
    });
  }

  void GetDeathClaims() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.claims+"deceased_claim/"+UserSessions.instance.getUserID+"/"+UserSessions.instance.getToken+"/C/"+UserSessions.instance.getRefID;
    print(url);
    var response = await http.get(Uri.parse(url));
    uiUpdates.DismissProgresssDialog();
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        List<dynamic> marriageList= body["Data"];
        if(marriageList.length > 0){
          marriageList.forEach((element) {
            String claim_id= element["claim_id"].toString();
            String claim_dated= element["claim_dated"].toString();
            String claim_amount= element["claim_amount"].toString();
            String claim_payment= element["claim_payment"].toString();
            String claim_stage= element["claim_stage"].toString();
            String bene_name= element["bene_name"].toString();
            String bene_relation= element["bene_relation"].toString();
            list.add(DeathClaimModel(claim_id, claim_dated, claim_amount, claim_payment, claim_stage, bene_name, bene_relation));
          });

          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= false;
          });
        }else{
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      } else {
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
        setState(() {
          isError= true;
          errorMessage = Strings.instance.notAvail;
        });
      }
    } else {
      var body = jsonDecode(response.body);
      String message = body["Message"].toString();
      if(message == constants.expireToken){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        if(message!="null"){
          uiUpdates.ShowToast(message);
        }else{
          if(body["Data"].toString()=="[]")
          {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }

        }
      }
    }
  }
}
