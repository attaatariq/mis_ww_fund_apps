import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/EmployeeVerificationModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EmployeeVerificationDialog extends StatefulWidget {
  EmployeeVerificationModel model;

  EmployeeVerificationDialog(this.model);

  @override
  _EmployeeVerificationDialogState createState() => _EmployeeVerificationDialogState();
}

TextEditingController remarksController= TextEditingController();

class _EmployeeVerificationDialogState extends State<EmployeeVerificationDialog> {
  int _radioValue = 0;
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 250,
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
          color: AppTheme.colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Container(
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: AppTheme.colors.newPrimary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Identify "+widget.model.user_name,
                        style: TextStyle(
                            color: AppTheme.colors.white,
                            fontSize: 13,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 0.5,
                        width: double.infinity,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: AppTheme.colors.newPrimary,
                                      ),
                                      child: Radio(
                                        value: 0,
                                        activeColor: AppTheme.colors.newPrimary,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 5,),

                                  Text("Yes, In Record",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newPrimary,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Theme(
                                      data: ThemeData(
                                        //here change to your color
                                        unselectedWidgetColor: AppTheme.colors.newPrimary,
                                      ),
                                      child: Radio(
                                        value: 1,
                                        activeColor: AppTheme.colors.newPrimary,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 5,),

                                  Expanded(
                                    child: Text("No Anonymous",
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: AppTheme.colors.newPrimary,
                                          fontSize: 12,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.colors.colorDarkGray, width: 1)
                        ),
                        margin: EdgeInsets.only(top: 20),
                        height: 70,
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextField(
                              controller: remarksController,
                              cursorColor: AppTheme.colors.newPrimary,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.colors.newBlack
                              ),
                              decoration: InputDecoration(
                                hintText: "Remarks",
                                hintStyle: TextStyle(
                                    fontFamily: "AppFont",
                                    color: AppTheme.colors.colorDarkGray
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          Validation();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Verify",
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
      ),
    );
  }

  void Validation() {
    if(remarksController.text.isNotEmpty){
      CheckConnection();
    }else{
      uiUpdates.ShowToast(Strings.instance.remarksReq);
    }
  }

  void CheckConnection() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        ChangeEmployeeStatus()
      }else{
    uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  ChangeEmployeeStatus() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    String status= SetEmployeeStatus();
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "matched": status,
      "remarks": remarksController.text.toString(),
      "emp_id": widget.model.emp_id,
    };
    var url = constants.getApiBaseURL()+constants.companies+"verify";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders(), encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        Navigator.of(context).pop(true);
        uiUpdates.ShowToast(Strings.instance.successComplaint);
      } else {
        uiUpdates.ShowToast(Strings.instance.failedComplaint);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  String SetEmployeeStatus() {
    if(_radioValue == 0){
      return "Yes";
    }else{
      return "No";
    }
  }
}
