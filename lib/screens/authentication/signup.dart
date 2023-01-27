import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/dialogs/sector_category_dialog_model.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/SignUpDataModel.dart';
import 'package:welfare_claims_app/screens/authentication/verfication.dart';
import 'package:welfare_claims_app/screens/general/location_picker.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

FocusNode cnicNode= FocusNode();
FocusNode numberNode= FocusNode();
TextEditingController cnicController= TextEditingController();
TextEditingController numberController= TextEditingController();
TextEditingController fullNameController= TextEditingController();
TextEditingController emailController= TextEditingController();
TextEditingController passwordController= TextEditingController();
TextEditingController confirmPasswordController= TextEditingController();

class _SignUpState extends State<SignUp> {

  var cnicMask = new MaskTextInputFormatter(mask: '#####-#######-#',);
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  String selectedSectorCategory= "";
  String selectedSectorID= "", selectedGender= "";
  Constants constants;
  UIUpdates uiUpdates;
  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          selectedGender= "Male";
          break;
        case 1:
          selectedGender= "Female";
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSectorCategory= "Select Category";
    selectedGender= "Male";
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
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      OpenSectorCategoryDialog(context).then((value) {
                        HandelSeledSector(value);
                      });
                    },
                    child: Container(
                      height: 45,
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: Icon(Icons.menu_rounded, color: AppTheme.colors.newPrimary, size: 18,)
                                ),

                                SizedBox(width: 10,),

                                Expanded(
                                  child: Container(
                                      height: 35,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(selectedSectorCategory,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: selectedSectorCategory == "Select Category" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                                                  fontSize: 14,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ),

                                          Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.colors.newPrimary, size: 18,)
                                        ],
                                      )
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
                                  child: Icon(Icons.person_outline, color: AppTheme.colors.newPrimary, size: 18,)
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Container(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: fullNameController,
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Full Name",
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
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
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
                                  child: Icon(Icons.phone_android, color: AppTheme.colors.newPrimary, size: 18,)
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Container(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      focusNode: numberNode,
                                      controller: numberController,
                                      inputFormatters: [numberMask],
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Contact",
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
                                  child: Icon(Icons.person_pin_outlined, color: AppTheme.colors.newPrimary, size: 18,)
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Container(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      focusNode: cnicNode,
                                      controller: cnicController,
                                      inputFormatters: [cnicMask],
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "CNIC No",
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
                                      controller: passwordController,
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Password",
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
                                      controller: confirmPasswordController,
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.done,
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

                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: AppTheme.colors.newPrimary,
                            toggleableActiveColor: AppTheme.colors.newPrimary
                        ), //set the dark theme or write your own theme
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Male',
                                  style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 14,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Female',
                                  style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 14,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),

                  SizedBox(height: 20,),

                  InkWell(
                    onTap: (){
                      Validation();
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
                          child: Text("Next",
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
      )
    );
  }

  Future<String> OpenSectorCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SectorCategoryDialogModel(),
          );
        }
    );
  }

  void Validation() {
    if(selectedSectorCategory != "Select Category")
    {
      if(fullNameController.text.isNotEmpty)
        {
          if(emailController.text.isNotEmpty)
          {
            if(constants.IsValidEmail(emailController.text.toString()))
              {
                if(numberController.text.isNotEmpty)
                {
                  if(numberController.text.toString().length == 11)
                    {
                      if(cnicController.text.isNotEmpty)
                      {
                        if(cnicController.text.toString().length == 15)
                        {
                          if(passwordController.text.isNotEmpty)
                          {
                            if(confirmPasswordController.text.isNotEmpty)
                            {
                              if(passwordController.text.toString() == confirmPasswordController.text.toString())
                              {
                                CheckConnectivity();
                              }else {
                                uiUpdates.ShowToast(Strings.instance.passwordMatchMessage);
                              }
                            }else{
                              uiUpdates.ShowToast(Strings.instance.confirmPasswordMessage);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.passwordMessage);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.invalidCNICMessage);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.cnicMessage);
                      }
                    }else{
                    uiUpdates.ShowToast(Strings.instance.invalidNumberMessage);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.numberMessage);
                }
              }else{
              uiUpdates.ShowToast(Strings.instance.invalidEmailMessage);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.emailMessage);
          }
        }else{
        uiUpdates.ShowToast(Strings.instance.fullnameMessage);
      }
    }else {
      uiUpdates.ShowToast(Strings.instance.companyCategoryMessage);
    }
  }

  void CheckConnectivity() {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.CheckConnectivity(context).then((value) => {
      if(value)
        {
          SendVerificationCodes()
        }else{
        uiUpdates.DismissProgresssDialog(),
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  SendVerificationCodes() async{
    uiUpdates.HideKeyBoard();
    Map data = {
      "email": emailController.text.toString(),
      "contact": numberController.text.toString(),
    };

    var url = constants.getApiBaseURL()+constants.authentication+"sendcode";
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
        String emailCode= body["Data"]["email_code"].toString();
        String otpCode= body["Data"]["phone_code"].toString();
        SignupDataModel signupDataModel= new SignupDataModel(fullNameController.text.toString(), cnicController.text.toString(),
            emailController.text.toString(), numberController.text.toString(), selectedGender, selectedSectorID,
            passwordController.text.toString(), emailCode, otpCode);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Verification(signupDataModel)
        ));
      }else{
        uiUpdates.ShowToast(message);
      }
    }else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void HandelSeledSector(String value) {
    if(value != null && value != "") {
      selectedSectorCategory = value;
      setState(() {
        if (selectedSectorCategory == constants.selectorCategoryFirstName) {
          selectedSectorID = "1";
        } else
        if (selectedSectorCategory == constants.selectorCategorySecondName) {
          selectedSectorID = "2";
        } else {
          selectedSectorID = "3";
        }
      });
    }
  }
}
