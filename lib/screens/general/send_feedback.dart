import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class SendFeedback extends StatefulWidget {
  @override
  _SendFeedbackState createState() => _SendFeedbackState();
}

TextEditingController feedBackController= new TextEditingController();

class _SendFeedbackState extends State<SendFeedback> {
  int selectedPosition= 0;
  String selectedFeedback="", feedbackType="";
  Constants constants;
  UIUpdates uiUpdates;

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
                      child: Text("Feedback",
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
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Text(
                      "How was your experience with MIS?",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 14,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
                              SelectedFeedback(1);
                            },
                            child: Container(
                              height: 80,
                              color: selectedPosition != 1 ? AppTheme.colors.colorExelent : AppTheme.colors.newBlack,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/exelent_smile.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newWhite,
                                  ),

                                  SizedBox(height: 10,),

                                  Text(
                                    "Excellent",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
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
                              SelectedFeedback(2);
                            },
                            child: Container(
                              height: 80,
                              color: selectedPosition != 2 ? AppTheme.colors.colorGood : AppTheme.colors.newBlack,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/good_smile.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newWhite,
                                  ),

                                  SizedBox(height: 10,),

                                  Text(
                                    "Good",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
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
                              SelectedFeedback(3);
                            },
                            child: Container(
                              height: 80,
                              color: selectedPosition != 3 ? AppTheme.colors.colorBad : AppTheme.colors.newBlack,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/sad.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newWhite,
                                  ),

                                  SizedBox(height: 10,),

                                  Text(
                                    "Bad",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
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
                              SelectedFeedback(4);
                            },
                            child: Container(
                              height: 80,
                              color: selectedPosition != 4 ? AppTheme.colors.colorPoor : AppTheme.colors.newBlack,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/poor.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newWhite,
                                  ),

                                  SizedBox(height: 10,),

                                  Text(
                                    "Poor",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newWhite,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 30,),

                    Text(
                      "How you will describe it?",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 14,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    SizedBox(height: 10,),

                    Container(
                      height: 250,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom :10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: feedBackController,
                          cursorColor: AppTheme.colors.newPrimary,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.colors.newBlack
                          ),
                          decoration: InputDecoration(
                            hintMaxLines: 2,
                            hintText: "Have feedback? Your feedback help us to improve. We'd love to hear it.",
                            hintStyle: TextStyle(
                                fontFamily: "AppFont",
                                color: AppTheme.colors.colorDarkGray
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Validation();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 60),
                        height: 45,
                        color: AppTheme.colors.newPrimary,
                        child: Center(
                          child: Text("Send Feedback",
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
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

  void Validation() {
    if(selectedPosition != 0){
      if(feedBackController.text.isNotEmpty){
        SendFeedbackToAdmin();
      }else{
        uiUpdates.ShowToast("Please describe your feedback");
      }
    }else{
      uiUpdates.ShowToast("Please select your feedback");
    }
  }

  void SelectedFeedback(int position) {
    selectedPosition = position;
    if(position == 1){
      selectedFeedback= "Excellent";
    }else if(position == 2){
      selectedFeedback= "Good";
    }else if(position == 3){
      selectedFeedback= "Bad";
    }else if(position == 4){
      selectedFeedback= "Poor";
    }
    setState(() {
    });
  }

  void SendFeedbackToAdmin() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    SetFeedbackType(UserSessions.instance.getUserSector, UserSessions.instance.getUserRole, UserSessions.instance.getUserAccount);
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "comp_id": UserSessions.instance.getRefID,
      "feed_type": feedbackType,
      "feed_quality": selectedFeedback,
      "feed_message": feedBackController.text.toString(),
    };
    print(data.toString());
    var url = constants.getApiBaseURL()+constants.assessments+"feedback";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders(), encoding: Encoding.getByName("UTF-8"));
    print(response.body+" : "+response.statusCode.toString());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.successFeedback);
      } else {
        uiUpdates.ShowToast(Strings.instance.failedFeedback);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void SetFeedbackType(String user_sector, String user_role, String user_account) {
    if(user_sector == "7" && user_role == "6"){ // wwf employee
     feedbackType= "Employee";
    }else if(user_sector == "8" && user_role == "9"){ // company worker
      feedbackType= "Worker";
    }else if(user_sector == "8" && user_role == "7"){ //CEO company
      feedbackType= "Company";
    }else if(user_sector == "8" && user_role == "8"){ //DEO company
      feedbackType= "Company";
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}
