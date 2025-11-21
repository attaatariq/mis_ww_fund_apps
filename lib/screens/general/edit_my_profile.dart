import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/utils/permission_handler.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

TextEditingController nameController= new TextEditingController();
TextEditingController numberController= new TextEditingController();
TextEditingController aboutController= new TextEditingController();

class _EditProfileState extends State<EditProfile> {
  UIUpdates uiUpdates;
  Constants constants;
  var bytes;
  String selectedFilePath="", selectedFileName="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUpdates= new UIUpdates(context);
    constants= new Constants();
    SetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StandardHeader(
              title: "Edit Profile",
            ),

            Container(
              margin: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        OpenFilePicker();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: bytes == null ? 
                                  (UserSessions.instance.getUserImage != "null" && 
                                   UserSessions.instance.getUserImage != "" && 
                                   UserSessions.instance.getUserImage != "NULL" &&
                                   UserSessions.instance.getUserImage != "-" &&
                                   UserSessions.instance.getUserImage != "N/A" ? FadeInImage(
                                    image: NetworkImage(constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                                    placeholder: AssetImage("archive/images/no_image.jpg"),
                                    fit: BoxFit.fill,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset("archive/images/no_image.jpg",
                                        height: 100.0,
                                        width: 100,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                  ) : Image.asset("archive/images/no_image.jpg",
                                    height: 100.0,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  )) : new Image.memory(bytes,
                                fit: BoxFit.cover),
                              ),
                            ),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 5, bottom: 10),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.newPrimary,
                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Icon(Icons.edit, color: AppTheme.colors.white, size: 8,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 25),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: nameController,
                          cursorColor: AppTheme.colors.newPrimary,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.colors.newBlack
                          ),
                          decoration: InputDecoration(
                            hintMaxLines: 2,
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontFamily: "AppFont",
                                color: AppTheme.colors.colorDarkGray
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 25),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: numberController,
                          cursorColor: AppTheme.colors.newPrimary,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.colors.newBlack
                          ),
                          decoration: InputDecoration(
                            hintMaxLines: 2,
                            hintText: "Number",
                            hintStyle: TextStyle(
                                fontFamily: "AppFont",
                                color: AppTheme.colors.colorDarkGray
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 200,
                      margin: EdgeInsets.only(top: 25),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: aboutController,
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
                            hintText: "About",
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
                          child: Text("Save",
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
          try {
            File selectedImage = File(file.path);
            bytes = selectedImage.readAsBytesSync();
            setState(() {
              selectedFileName = file.name;
              selectedFilePath = file.path;
            });
            uiUpdates.ShowToast("File selected: ${file.name}");
          } catch (e) {
            uiUpdates.ShowToast("Error reading file: ${e.toString()}");
          }
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

  void Validation() {
    if(nameController.text.isNotEmpty){
      if(numberController.text.isNotEmpty){
        if(aboutController.text.isNotEmpty){
          if(selectedFilePath.isNotEmpty){
            CheckConnectivity();
          }else{
            uiUpdates.ShowToast(Strings.instance.selectProfile);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.cpaboutMessage);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.numberMessage);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.nameNotEmpty);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        SaveProfile()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  SaveProfile() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "name": nameController.text.toString(),
      "image": selectedFilePath,
      "contact": numberController.text.toString(),
      "about": aboutController.text.toString(),
    };
    var url = constants.getApiBaseURL()+constants.authentication+"profile";
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

  void SetData() {
    nameController.text= UserSessions.instance.getUserName;
    numberController.text= UserSessions.instance.getUserNumber;
    aboutController.text= UserSessions.instance.getUserAbout;
  }
}
