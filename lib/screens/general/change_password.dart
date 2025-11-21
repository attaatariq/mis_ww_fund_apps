import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/standard_header.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

TextEditingController oldPassController= new TextEditingController();
TextEditingController newPassController= new TextEditingController();
TextEditingController confirmPassController= new TextEditingController();

class _ChangePasswordState extends State<ChangePassword> {
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Change Password",
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 45,
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: oldPassController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.text,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Old Password",
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
                              ],
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 45,
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: newPassController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.text,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "New Password",
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
                              ],
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 45,
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: confirmPassController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.text,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Confirm Password",
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
                              ],
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),
                          )
                        ],
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
                          child: Text("Change",
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

  void Validation() async{
    if(oldPassController.text.toString().isNotEmpty){
      if(newPassController.text.toString().isNotEmpty){
        if(confirmPassController.text.toString().isNotEmpty){
          if(confirmPassController.text.toString() == newPassController.text.toString()){
            if(oldPassController.text.toString() == newPassController.text.toString()) {
              CheckConnectivity();
            }else{
              uiUpdates.ShowToast(Strings.instance.oldPasswordMatch);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.confirmPassNotMatch);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.confirmPassReq);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.newPassReq);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.oldPassReq);
    }
  }

  void ChangePasswordFun() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "previous": oldPassController.text.toString(),
      "password": newPassController.text.toString(),
      "confirm": confirmPassController.text.toString(),
    };
    var url = constants.getApiBaseURL()+constants.authentication+"change";
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
      uiUpdates.ShowError(responseCodeModel.message);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        ChangePasswordFun()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }
}
