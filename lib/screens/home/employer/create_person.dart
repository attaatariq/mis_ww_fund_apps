import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/auth/signup.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class AddContactPerson extends StatefulWidget {
  @override
  _AddContactPersonState createState() => _AddContactPersonState();
}

TextEditingController nameController= TextEditingController();
TextEditingController designitationController= TextEditingController();
TextEditingController emailController= TextEditingController();
TextEditingController contactNoController= TextEditingController();
TextEditingController faxNoController= TextEditingController();

class _AddContactPersonState extends State<AddContactPerson> {
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  UIUpdates uiUpdates;
  Constants constants;
  String selectedGender= "Male";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUpdates= new UIUpdates(context);
    constants= new Constants();
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Add Contact Person",
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                child: SingleChildScrollView(
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
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: nameController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Person Name",
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
                                          controller: designitationController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Designation",
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
                                          controller: emailController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
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
                                          controller: contactNoController,
                                          inputFormatters: [numberMask],
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Contact No",
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
                                          controller: faxNoController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Fax No",
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

                      InkWell(
                        onTap: (){
                          Validation();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 50, bottom: 60),
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Add",
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
              ),
            )
          ],
        ),
      ),
    );
  }

  void Validation() {
    if(nameController.text.isNotEmpty){
      if(designitationController.text.isNotEmpty){
        if(emailController.text.isNotEmpty){
          if(constants.IsValidEmail(emailController.text.toString())){
            if(contactNoController.text.isNotEmpty){
              if(contactNoController.text.length == 11){
                if(faxNoController.text.isNotEmpty){
                  CheckConnectivity();
                }else{
                  uiUpdates.ShowToast(Strings.instance.cFaxNoMessage);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.numberMessage);
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
        uiUpdates.ShowToast(Strings.instance.cpdesignationMessage);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.cppersonNameMessage);
    }
  }

  void CheckConnectivity() {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.CheckConnectivity(context).then((value) => {
      if(value)
        {
          AddContactPerson_()
        }else
          {
            uiUpdates.DismissProgresssDialog(),
            uiUpdates.ShowToast(Strings.instance.internetNotConnected)
          }
    });
  }

  AddContactPerson_() async{
    uiUpdates.HideKeyBoard();
    Map data = {
      "comp_id": UserSessions.instance.getRefID,
      "user_id": UserSessions.instance.getUserID,
      "person_name": nameController.text.toString(),
      "person_about": designitationController.text.toString(),
      "person_email": emailController.text.toString(),
      "person_contact": contactNoController.text.toString(),
      "person_faxno": faxNoController.text.toString(),
      "person_gender": selectedGender.toString(),
    };

    var url = constants.getApiBaseURL()+constants.companies+"person";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders(), encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    if(responseCodeModel.status == true)
    {
      var body = jsonDecode(response.body);
      String code= body["Code"].toString();
      String message= body["Message"].toString();
      if(code == "1")
      {
        uiUpdates.ShowToast(message);
        Navigator.pop(context, true);
      }else{
        uiUpdates.ShowToast(message);
      }
    }else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
}
