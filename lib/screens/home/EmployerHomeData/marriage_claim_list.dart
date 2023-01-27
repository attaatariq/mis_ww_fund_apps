import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/models/MarriageClaimModel.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/marriage_claim_detail.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../itemviews/marriage_claim_list_item.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';

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
                          child: Text("Marriage Claims",
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
                  padding: EdgeInsets.all(0),
                  itemBuilder: (_, int index) =>
                      MarriageClaimListItem(list[index]),
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
        GetMarriageClaims();
      }
    });
  }

  void GetMarriageClaims() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.claims+"marriage_claim/"+UserSessions.instance.getUserID+"/"+UserSessions.instance.getToken+"/C/"+UserSessions.instance.getRefID;
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
            String claim_husband= element["claim_husband"].toString();
            String claim_dated= element["claim_dated"].toString();
            String claim_category= element["claim_category"].toString();
            String claim_stage= element["claim_stage"].toString();
            list.add(MarriageClaimModel(claim_id, claim_husband, claim_dated, claim_category, claim_stage));
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
        uiUpdates.ShowToast(message);
      }
    }
  }
}
