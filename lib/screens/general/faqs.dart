import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/faq_list_item.dart';
import 'package:welfare_claims_app/models/FaqModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/widgets/empty_state_widget.dart';
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
                      child: EmptyStateWidget(
                        icon: Icons.help_outline,
                        message: 'No FAQs Available',
                        description: 'Frequently asked questions will appear here once available.',
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
    try {
      if(!isRefresh) {
        uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      }
      var url = constants.getApiBaseURL() + constants.assessments +
          "faqs/" + UserSessions.instance.getUserID + "/" +
          UserSessions.instance.getToken;
      var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            var data= body["Data"];
            List<dynamic> entitlements = data != null ? data : [];
            if(entitlements.length > 0)
            {
              list.clear();
              entitlements.forEach((row) {
                String faq_question= row["faq_question"] != null ? row["faq_question"].toString() : "";
                String faq_answer= row["faq_answer"] != null ? row["faq_answer"].toString() : "";
                String created_at= row["created_at"] != null ? row["created_at"].toString() : "";
                list.add(new FaqModel(faq_question, faq_answer, created_at, false));
              });

              setState(() {
                isError= false;
              });
            }else
            {
              setState(() {
                isError= true;
                errorMessage = Strings.instance.notAvail;
              });
            }
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          print('JSON parsing error: $e');
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"] != null ? body["Message"].toString() : "";
          
          if(message == constants.expireToken){
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          }else if(message.isNotEmpty && message != "null"){
            uiUpdates.ShowToast(message);
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          print('Error parsing error response: $e');
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      print('Network or request error: $e');
      setState(() {
        isError= true;
        errorMessage = Strings.instance.notAvail;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
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
