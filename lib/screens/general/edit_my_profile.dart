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
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          child: Text("Edit",
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
                  ],
                ),
              ),
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
                                child: bytes == null ? UserSessions.instance.getUserImage != "null" ? FadeInImage(
                                  image: NetworkImage(constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                                  placeholder: AssetImage("archive/images/no_image.jpg"),
                                  fit: BoxFit.fill,
                                ) : Image.asset("archive/images/no_image.jpg",
                                  height: 100.0,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ) : new Image.memory(bytes,
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
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied || status.isLimited || status.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf", "png", "jpeg", "jpg"]
    );

    if(result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFileName = file.name;
        selectedFilePath = file.path;
        File selectedImage = File(file.path);
        bytes = selectedImage.readAsBytesSync();
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
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
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void SetData() {
    nameController.text= UserSessions.instance.getUserName;
    numberController.text= UserSessions.instance.getUserNumber;
    aboutController.text= UserSessions.instance.getUserAbout;
  }
}
