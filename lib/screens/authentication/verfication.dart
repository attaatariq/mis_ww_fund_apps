import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/SignUpDataModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Verification extends StatefulWidget {
  SignupDataModel signupDataModel;

  Verification(this.signupDataModel);

  @override
  _VerificationState createState() => _VerificationState();
}

TextEditingController emailCodeController= TextEditingController();
TextEditingController otpCodeController= TextEditingController();

class _VerificationState extends State<Verification> {
  var verificationMarsk = new MaskTextInputFormatter(mask: '######',);
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
        child: ListView(
          padding: EdgeInsets.all(0),
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
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 30),
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
                                Container(
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: Icon(Icons.lock_outline, color: AppTheme.colors.newPrimary, size: 18,)
                                ),

                                SizedBox(width: 10,),

                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextField(
                                        inputFormatters: [verificationMarsk],
                                        controller: emailCodeController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Email Verification Code",
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
                                Container(
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: Icon(Icons.lock_outline, color: AppTheme.colors.newPrimary, size: 18,)
                                ),

                                SizedBox(width: 10,),

                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextField(
                                        inputFormatters: [verificationMarsk],
                                        controller: otpCodeController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Number Verification Code",
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
                        margin: EdgeInsets.only(top: 50, bottom: 60),
                        height: 45,
                        color: AppTheme.colors.newPrimary,
                        child: Center(
                          child: Text("Sign Up",
                            style: TextStyle(
                                color: AppTheme.colors.white,
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
    if(emailCodeController.text.isNotEmpty)
    {
      if(emailCodeController.text.toString().length == 6)
        {
          if(otpCodeController.text.isNotEmpty)
          {
            if(otpCodeController.text.toString().length == 6)
            {
              if(widget.signupDataModel.emailVerificationCode == emailCodeController.text.toString())
                {
                  if(widget.signupDataModel.numberVerificationCode == otpCodeController.text.toString()) {
                    SignupUser();
                  }else{
                    uiUpdates.ShowToast(Strings.instance.invalidNumberVerificationCode);
                  }
                }else{
                uiUpdates.ShowToast(Strings.instance.invalidEmailVerificationCode);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.invalidNumberVerificationCode);
            }
          }else {
            uiUpdates.ShowToast(Strings.instance.missingNumberVerificationCode);
          }
        }else
          {
            uiUpdates.ShowToast(Strings.instance.invalidEmailVerificationCode);
          }
    }else {
      uiUpdates.ShowToast(Strings.instance.missingEmailVerificationCode);
    }
  }

  void SignupUser() async{
    uiUpdates.HideKeyBoard();
    Map data = {
      "name": widget.signupDataModel.name,
      "cnic": widget.signupDataModel.cnic,
      "email": widget.signupDataModel.email,
      "contact": widget.signupDataModel.contact,
      "gender": widget.signupDataModel.gender,
      "sector": widget.signupDataModel.sector,
      "password": widget.signupDataModel.password,
      "confirm": widget.signupDataModel.password
    };
    print(data);
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"signup";
    var response = await http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if(responseCodeModel.status == true)
    {
      var body = jsonDecode(response.body);
      String code= body["Code"].toString();
      String message= body["Message"].toString();
      if(code == "1")
      {
        uiUpdates.ShowToast(message);
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
              (route) => false,
        );
      }else{
        uiUpdates.ShowToast(message);
      }
    }else{
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
}
