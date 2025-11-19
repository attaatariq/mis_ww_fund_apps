import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/complaint_type_dialog_model.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

TextEditingController complaintController= new TextEditingController();

class _AddComplaintState extends State<AddComplaint> {
  Constants constants;
  UIUpdates uiUpdates;
  String feedbackType="";
  String selectComplaintType= Strings.instance.selectedComplaintType;

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
                      child: Text("Send Complaint",
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
                    InkWell(
                      onTap: (){
                        OpenComplaintTypeDialog(context).then((value) => {
                          if(value != null){
                            setState(() {
                              selectComplaintType= value;
                            })
                          }
                        });
                      },
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.colors.colorDarkGray),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10),
                                child: Text(
                                  selectComplaintType,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: selectComplaintType != Strings.instance.selectedComplaintType ? AppTheme.colors.newBlack : AppTheme.colors.colorDarkGray,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right : 10.0),
                              child: Icon(Icons.arrow_drop_down, color: AppTheme.colors.colorDarkGray, size: 20,),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),

                    Container(
                      height: 250,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom :10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: complaintController,
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
                            hintText: "Complaint Content",
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
                          child: Text("Send Message",
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }

  void Validation() {
    if(selectComplaintType != Strings.instance.selectedComplaintType){
      if(complaintController.text.isNotEmpty){
        SendMessageToAdmin();
      }else{
        uiUpdates.ShowToast("Please elaborate your issue");
      }
    }else{
      uiUpdates.ShowToast("Please select complaint type");
    }
  }

  Future<String> OpenComplaintTypeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: ComplaintTypeDialogModel(constants.GetComplaintTypes()),
          );
        }
    );
  }

  void SendMessageToAdmin() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    SetFeedbackType(UserSessions.instance.getUserSector, UserSessions.instance.getUserRole, UserSessions.instance.getUserAccount);
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "com_type": feedbackType,
      "comp_id": UserSessions.instance.getRefID,
      "com_subject": selectComplaintType,
      "com_message": complaintController.text.toString(),
    };
    var url = constants.getApiBaseURL()+constants.assessments+"complaint";
    var response = await http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.successComplaint);
      } else {
        uiUpdates.ShowToast(Strings.instance.failedComplaint);
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
}
