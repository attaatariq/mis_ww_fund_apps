import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

TextEditingController emailController= TextEditingController();

class _ForgotPasswordState extends State<ForgotPassword> {
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    ///check new updated version
    constants.CheckForNewUpdate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(190), bottomRight: Radius.circular(190))
              ),

              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  child: Column(
                    children: [
                      Container(
                        height: 120.0,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.asset("assets/images/logo.png",
                            height: 120.0,
                            width: 120,
                            color: AppTheme.colors.newWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),

            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 60),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    child: Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: Icon(Icons.email_outlined, color: AppTheme.colors.newPrimary, size: 18,)
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Container(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: emailController,
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Email",
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

                  SizedBox(height: 50,),

                  InkWell(
                    onTap: (){
                      Vlaidation();
                    },
                    child: Material(
                      elevation: 10,
                      shadowColor: AppTheme.colors.colorLightGray,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary,
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: Center(
                          child: Text("Reset Password",
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
                  ),

                  SizedBox(height: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void Vlaidation() {
    if(emailController.text.toString().isNotEmpty){
      CheckConnectivity();
    }else{
      uiUpdates.ShowToast(Strings.instance.emailMessage);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        ResetPassword()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  ResetPassword() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    Map data = {
      "email": emailController.text.toString(),
    };
    var url = constants.getApiBaseURL()+constants.authentication+"forgot";
    var response = await http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    if(response.statusCode != 500) {
      if (responseCodeModel.status == true) {
        var body = jsonDecode(response.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.resetPasswordSuccess);
          Navigator.pop(context);
        } else {
          uiUpdates.ShowToast(Strings.instance.resetPasswordFailed);
        }
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    }else{
      var body = jsonDecode(response.body);
      String data= body["Data"].toString();
      uiUpdates.ShowToast(data);
    }
  }
}
