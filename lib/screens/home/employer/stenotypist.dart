import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/sector_category_dialog_model.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/utils/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class AddDeo extends StatefulWidget {
  @override
  _AddDeoState createState() => _AddDeoState();
}

FocusNode cnicNode= FocusNode();
FocusNode numberNode= FocusNode();
TextEditingController cnicController= TextEditingController();
TextEditingController numberController= TextEditingController();
TextEditingController fullNameController= TextEditingController();
TextEditingController emailController= TextEditingController();
TextEditingController passwordController= TextEditingController();
TextEditingController confirmPasswordController= TextEditingController();


class _AddDeoState extends State<AddDeo> {

  var cnicMask = new MaskTextInputFormatter(mask: '#####-#######-#',);
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  String selectedSectorID= "", selectedGender= "Male";
  String logoFilePath="", logoFileName="Select Image";
  UIUpdates uiUpdates;
  Constants constants;
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
    uiUpdates= new UIUpdates(context);
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Add DEO",
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
                                          controller: fullNameController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
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
                                          focusNode: numberNode,
                                          controller: numberController,
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
                                          textInputAction: TextInputAction.done,
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
                                          textInputAction: TextInputAction.done,
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
                        onTap: ()
                        {
                          OpenFilePicker();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                          ),
                          child: Center(
                            child: Text(logoFileName,
                              style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
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
                          margin: EdgeInsets.only(top: 15, bottom: 60),
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
                        if(logoFilePath.isNotEmpty)
                        {
                          CheckConnectivity();
                        }else {
                          uiUpdates.ShowToast(Strings.instance.selectImage);
                        }
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
  }

  void CheckConnectivity() {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.CheckConnectivity(context).then((value) => {
      if(value)
        {
          AddDEO()
        }else{
        uiUpdates.DismissProgresssDialog(),
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddDEO() async{
    uiUpdates.HideKeyBoard();
//    var url = constants.getApiBaseURL()+constants.companies+"deo";
    var url = constants.getApiBaseURL()+constants.companies+"stenotypist";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = fullNameController.text.toString();
    request.fields['comp_id'] = UserSessions.instance.getRefID;
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['cnic'] = cnicController.text.toString();
    request.fields['email'] = emailController.text.toString();
    request.fields['contact'] = numberController.text.toString();
    request.fields['gender'] = selectedGender;
    request.fields['sector'] = "8";
    request.fields['role'] = "8";
    request.fields['password'] = passwordController.text.toString();
    request.fields['confirm'] = confirmPasswordController.text.toString();
    if(logoFilePath.isNotEmpty)
      {
        request.files.add(
            http.MultipartFile(
                'image',
                File(logoFilePath).readAsBytes().asStream(),
                File(logoFilePath).lengthSync(),
                filename: logoFilePath.split("/").last
            )
        );
      }else{
      return;
    }

    APIService.addAuthHeaderToMultipartRequest(request);
    var response = await request.send();
    uiUpdates.DismissProgresssDialog();
    final resp = await http.Response.fromStream(response);
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(resp.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.deoAddMessage);
        Navigator.pop(context, true);
      } else {
        uiUpdates.ShowToast(Strings.instance.deoAddFailed);
      }
    } else {
      var body = jsonDecode(resp.body);
      String message = body["Message"].toString();
      uiUpdates.ShowToast(message);
    }
    try {

    }catch(e){
      uiUpdates.ShowToast(e);
    }finally{
      uiUpdates.DismissProgresssDialog();
    }
  }

  void OpenFilePicker() async{
    try {
      // Check and request storage permission using centralized handler
      bool hasPermission = await ensureStoragePermission(context);
      if (!hasPermission) {
        uiUpdates.ShowError("Storage permission is required to select files. Please grant permission in app settings.");
        return;
      }
      
      FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ["pdf", "png", "jpeg", "jpg"]
      );

      if(result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.path != null && file.path.isNotEmpty) {
          setState(() {
            logoFileName= file.name;
            logoFilePath= file.path;
          });
          uiUpdates.ShowSuccess("File selected: ${file.name}");
        } else {
          uiUpdates.ShowError("Failed to get file path. Please try again.");
        }
      } else {
        // User cancelled file picker - no need to show error
      }
    } catch (e) {
      uiUpdates.ShowError("Error selecting file: ${e.toString()}");
    }
  }

  add(){ /// information api call and id deo exist in information api then show that in these above fields and edit it otherwise add deo

  }
}
