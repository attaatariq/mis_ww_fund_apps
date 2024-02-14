import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/faq_list_item.dart';
import 'package:welfare_claims_app/models/FaqModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class FAQs extends StatefulWidget {
  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<FaqModel> list= [];
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey= GlobalKey<RefreshIndicatorState>();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetFaqs(false);
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
                      child: Text("FAQ's",
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
                  children: [
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
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: RefreshIndicator(
                          color: AppTheme.colors.newPrimary,
                          key: refreshKey,
                          onRefresh: () async{
                            await GetFaqs(true);
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemBuilder: (_, int index) =>
                                InkWell(
                                  onTap: (){
                                    OpenCloseFaq(index);
                                  },
                                    child: FaqListItem(list[index])),
                            itemCount: this.list.length,
                          ),
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

  GetFaqs(bool isRefresh) async {
    if(!isRefresh) {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    }
    var url = constants.getApiBaseURL() + constants.assessments +
        "faqs/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    print(url+response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        List<dynamic> entitlements = data;
        if(entitlements.length > 0)
        {
          list.clear();
          entitlements.forEach((row) {
            String faq_question= row["faq_question"].toString();
            String faq_answer= row["faq_answer"].toString();
            String created_at= row["created_at"].toString();
            list.add(new FaqModel(faq_question, faq_answer, created_at, false));
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
            errorMessage = "FAQ's Not Available";
          });
        }
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      if(responseCodeModel.message!="null") {
        uiUpdates.ShowToast(responseCodeModel.message);
      }else{
        setState(() {
          isError= true;
          errorMessage = "FAQ's Not Available";
        });
      }    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }

  void OpenCloseFaq(int index) {
    if(list[index].isOpen){
      list[index].isOpen = false;
    }else{
      list[index].isOpen = true;
    }

    setState(() {
    });
  }
}
