import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/child_dialog_model.dart';
import 'package:wwf_apps/dialogs/education_level_dialog_model.dart';
import 'package:wwf_apps/dialogs/education_nature_dialog_model.dart';
import 'package:wwf_apps/dialogs/living_dialog_model.dart';
import 'package:wwf_apps/dialogs/schools_dialog_model.dart';
import 'package:wwf_apps/models/ChildModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/models/SchoolModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/utils/permission_handler.dart';
import 'package:http/http.dart' as http;

class AddChildEducation extends StatefulWidget {
  @override
  _AddChildEducationState createState() => _AddChildEducationState();
}

TextEditingController degreeController= TextEditingController();
TextEditingController classController= TextEditingController();
TextEditingController placeNameController= TextEditingController();
TextEditingController placeAddressController= TextEditingController();
TextEditingController placeContactController= TextEditingController();
TextEditingController fileNoController= TextEditingController();

class _AddChildEducationState extends State<AddChildEducation> {
  String studentCardFilePath="", studentCardFileName="Select Student Card", affiliateFilePath="", affiliateFileName="Select Affiliate";
  String challanFilePath="", challanFileName="Select Challan", resultCardFilePath="", resultCardFileName="Select Result Card";
  String selectedNature= Strings.instance.selectEducationType, selectedLevel= Strings.instance.selectLevel,
      selectedStartedDate= Strings.instance.selectedStartedDate, selectedEndedDate= Strings.instance.selectedEndedDate,
      selectedLiving= Strings.instance.selectedLiving, selectedSchool= Strings.instance.selectedSchool, selectedChild= Strings.instance.selectedChild;
  String selectedSchoolID="", selectedChildID="", selectMessOffering="Yes", selectedTransportUse="Yes";
  Constants constants;
  UIUpdates uiUpdates;
  List<SchoolModel> schoolModelList= [];
  List<ChildModel> childModelList= [];
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  int _radioValueMess = 0, _radioValueTransport = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  void _handleRadioValueChangeMess(int value) {
    setState(() {
      _radioValueMess = value;

      switch (_radioValueMess) {
        case 0:
          selectMessOffering= "Yes";
          break;
        case 1:
          selectMessOffering= "No";
          break;
      }
    });
  }

  void _handleRadioValueChangeTransport(int value) {
    setState(() {
      _radioValueTransport = value;

      switch (_radioValueTransport) {
        case 0:
          selectedTransportUse= "Yes";
          break;
        case 1:
          selectedTransportUse= "No";
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
              title: "Add Child Education",
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            OpenEducationTypeDialog(context).then((value) => {
                              if(value != null){
                                setState(() {
                                  selectedNature = value;
                                })
                              }
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
                                      Expanded(
                                        child: Container(
                                            height: 35,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedNature,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedNature == Strings.instance.selectEducationType ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

                        InkWell(
                          onTap: (){
                            OpenLivingDialog(context).then((value) => {
                              if(value != null){
                                setState(() {
                                  selectedLiving = value;
                                })
                              }
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
                                      Expanded(
                                        child: Container(
                                            height: 35,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedLiving,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedLiving == Strings.instance.selectedLiving ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

                        InkWell(
                          onTap: (){
                            if(selectedNature != Strings.instance.selectEducationType) {
                              OpenEducationLevelDialog(context).then((value) =>
                              {
                                if(value != null){
                                  setState(() {
                                    selectedLevel = value;
                                  })
                                }
                              });
                            }else{
                              uiUpdates.ShowToast(Strings.instance.selectEducationType);
                            }
                          },
                          child: Container(
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedLevel,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedLevel == Strings.instance.selectLevel ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

                        InkWell(
                          onTap: (){
                            if(schoolModelList.length > 0) {
                              OpenSchoolDialog(context).then((value) =>
                              {
                                if(value != null){
                                  setState(() {
                                    selectedSchoolID = value.id;
                                    selectedSchool = value.name;
                                  })
                                }
                              });
                            }else{
                              uiUpdates.ShowToast(Strings.instance.schoolNotAvail);
                            }
                          },
                          child: Container(
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedSchool,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedSchool == Strings.instance.selectedSchool ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

                        InkWell(
                          onTap: (){
                            if(childModelList.length > 0) {
                              OpenChildDialog(context).then((value) =>
                              {
                                if(value != null){
                                  setState(() {
                                    selectedChildID = value.id;
                                    selectedChild = value.name;
                                  })
                                }
                              });
                            }else{
                              uiUpdates.ShowToast(Strings.instance.childNotAvail);
                            }
                          },
                          child: Container(
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedChild,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedChild == Strings.instance.selectedChild ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                    Expanded(
                                      child: Container(
                                        height: 35,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: fileNoController,
                                            cursorColor: AppTheme.colors.newPrimary,
                                            keyboardType: TextInputType.number,
                                            maxLines: 1,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.colors.newBlack
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "File No.",
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
                                            controller: degreeController,
                                            cursorColor: AppTheme.colors.newPrimary,
                                            keyboardType: TextInputType.text,
                                            maxLines: 1,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.colors.newBlack
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Degree",
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
                                            controller: classController,
                                            cursorColor: AppTheme.colors.newPrimary,
                                            keyboardType: TextInputType.text,
                                            maxLines: 1,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.colors.newBlack
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Class",
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
                            _selectDate(context, 1);
                          },
                          child: Container(
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedStartedDate,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedStartedDate == Strings.instance.selectedStartedDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                                                        fontSize: 14,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
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

                        InkWell(
                          onTap: (){
                            _selectDate(context, 2);
                          },
                          child: Container(
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedEndedDate,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedEndedDate == Strings.instance.selectedEndedDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                                                        fontSize: 14,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
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

                        SizedBox(height: 30,),

                        selectedLiving != Strings.instance.selectedLiving ? Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Accommodation Detail",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 14,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
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
                                        Expanded(
                                          child: Container(
                                            height: 35,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: TextField(
                                                controller: placeNameController,
                                                cursorColor: AppTheme.colors.newPrimary,
                                                keyboardType: TextInputType.text,
                                                maxLines: 1,
                                                textInputAction: TextInputAction.next,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppTheme.colors.newBlack
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: selectedLiving == constants.dayScholar ? "Residence Name" : "Hostel Name",
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
                                                controller: placeAddressController,
                                                cursorColor: AppTheme.colors.newPrimary,
                                                keyboardType: TextInputType.text,
                                                maxLines: 1,
                                                textInputAction: TextInputAction.next,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppTheme.colors.newBlack
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: selectedLiving == constants.dayScholar ? "Residence Address" : "Hostel Adress",
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
                                                controller: placeContactController,
                                                cursorColor: AppTheme.colors.newPrimary,
                                                inputFormatters: [numberMask],
                                                keyboardType: TextInputType.number,
                                                maxLines: 1,
                                                textInputAction: TextInputAction.next,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppTheme.colors.newBlack
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Contact Number",
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

                            SizedBox(height: 15,),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Mess Offering?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
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
                                            groupValue: _radioValueMess,
                                            onChanged: _handleRadioValueChangeMess,
                                          ),
                                          new Text(
                                            'Yes',
                                            style: TextStyle(
                                                color: AppTheme.colors.newBlack,
                                                fontSize: 14,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          new Radio(
                                            value: 1,
                                            groupValue: _radioValueMess,
                                            onChanged: _handleRadioValueChangeMess,
                                          ),
                                          new Text(
                                            'No',
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

                            SizedBox(height: 15,),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Use Transport?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
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
                                            groupValue: _radioValueTransport,
                                            onChanged: _handleRadioValueChangeTransport,
                                          ),
                                          new Text(
                                            'Yes',
                                            style: TextStyle(
                                                color: AppTheme.colors.newBlack,
                                                fontSize: 14,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          new Radio(
                                            value: 1,
                                            groupValue: _radioValueTransport,
                                            onChanged: _handleRadioValueChangeTransport,
                                          ),
                                          new Text(
                                            'No',
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
                          ],
                        ) : Container(),

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(1);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(studentCardFileName,
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
                          onTap: ()
                          {
                            OpenFilePicker(2);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(affiliateFileName,
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
                          onTap: ()
                          {
                            OpenFilePicker(3);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(challanFileName,
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
                          onTap: ()
                          {
                            OpenFilePicker(4);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(resultCardFileName,
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
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> OpenEducationTypeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: EducationNatureDialogModel(),
          );
        }
    );
  }

  Future<String> OpenLivingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: LivingDialogModel(),
          );
        }
    );
  }

  Future<String> OpenEducationLevelDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: EducationLevelDialogModel(selectedNature == constants.underMatric ? constants.GetUnderMatricLevels() : constants.GetPostMatricLevels()),
          );
        }
    );
  }

  Future<void> _selectDate(BuildContext context, int position) async {
    Map<int, Color> color =
    {
      50:Color.fromRGBO(4,131,184, .1),
      100:Color.fromRGBO(4,131,184, .2),
      200:Color.fromRGBO(4,131,184, .3),
      300:Color.fromRGBO(4,131,184, .4),
      400:Color.fromRGBO(4,131,184, .5),
      500:Color.fromRGBO(4,131,184, .6),
      600:Color.fromRGBO(4,131,184, .7),
      700:Color.fromRGBO(4,131,184, .8),
      800:Color.fromRGBO(4,131,184, .9),
      900:Color.fromRGBO(4,131,184, 1),
    };

    MaterialColor myColor = MaterialColor(constants.dateDialogBg, color);
    MaterialColor myColornewWhite = MaterialColor(constants.dateDialogText, color);
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1947, 8),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: myColor,
              primaryColorDark: myColornewWhite,
              accentColor: myColornewWhite,
            ),
            dialogBackgroundColor:Colors.white,
          ),
          child: child,
        );
      },);
    if (picked != null && picked != selectedDate)
      setState(() {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        //selectedDate = picked;
        if(position == 1){ // issue cnic
          selectedStartedDate = dateFormat.format(picked).toString();
        }else if(position == 2){ //expire cnic
          selectedEndedDate = dateFormat.format(picked).toString();
        }
      });
  }

  void OpenFilePicker(int position) async{
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
            if(position == 1) {
              studentCardFileName = file.name;
              studentCardFilePath = file.path;
            }else if(position == 2){
              affiliateFileName = file.name;
              affiliateFilePath = file.path;
            }else if(position == 3){
              challanFileName = file.name;
              challanFilePath = file.path;
            }else if(position == 4){
              resultCardFileName = file.name;
              resultCardFilePath = file.path;
            }
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

  void Validation() {
    if(selectedNature != Strings.instance.selectEducationType){
      if(selectedLiving != Strings.instance.selectedLiving){
        if(selectedLevel != Strings.instance.selectLevel){
          if(degreeController.text.toString().isNotEmpty){
            if(classController.text.toString().isNotEmpty){
              if(selectedStartedDate != Strings.instance.selectedStartedDate){
                if(selectedEndedDate != Strings.instance.selectedEndedDate){
                  if(challanFilePath.isNotEmpty){
                    if(resultCardFilePath.isNotEmpty){
                      if(studentCardFilePath.isNotEmpty) {
                        if(affiliateFilePath.isNotEmpty) {
                          if(selectedSchoolID.isNotEmpty) {
                            if(selectedChildID.isNotEmpty) {
                              if(placeNameController.text.isNotEmpty) {
                                if(placeAddressController.text.isNotEmpty) {
                                  if(placeContactController.text.isNotEmpty) {
                                    if(selectMessOffering.isNotEmpty) {
                                      if(selectedTransportUse.isNotEmpty) {
                                        if(fileNoController.text.isNotEmpty) {
                                          CheckConnectivity();
                                        }else{
                                          uiUpdates.ShowToast(
                                              Strings.instance.cFileMessage);
                                        }
                                      }else{
                                        uiUpdates.ShowToast(
                                            Strings.instance.transportDetailReq);
                                      }
                                    }else{
                                      uiUpdates.ShowToast(
                                          Strings.instance.messDetailReq);
                                    }
                                  }else{
                                    uiUpdates.ShowToast(
                                        Strings.instance.placeContactReq);
                                  }
                                }else{
                                  uiUpdates.ShowToast(
                                      Strings.instance.placeAddressReq);
                                }
                              }else{
                                uiUpdates.ShowToast(
                                    Strings.instance.placeNameReq);
                              }
                            }else {
                              uiUpdates.ShowToast(Strings.instance.selectedChild);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.selectedSchool);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.selectAffiliate);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.selectStudentCard);
                      }
                    }else{
                      uiUpdates.ShowToast(Strings.instance.resultCardMessage);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.uploadChallan);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.selectedEndedDate);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.selectedStartedDate);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.classMessage);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.degreeMessage);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.selectLevel);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectedLiving);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectEducationType);
    }
  }

  GetInformation() async{
    List<String> tagsList= [constants.accountInfo, constants.empChildren, constants.schoolsInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
    uiUpdates.DismissProgresssDialog();
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var accounts= data["account"];
        List<dynamic> childrens= accounts["emp_children"];
        List<dynamic> schools= data["schools"];
        if(schools.length > 0){
          schools.forEach((element) {
            schoolModelList.add(new SchoolModel(element["school_id"], element["school_name"]));
          });
        }

        ///childrens
        if(childrens.length > 0){
          childrens.forEach((element) {
            childModelList.add(new ChildModel(element["child_id"], element["child_name"]));
          });
        }
      } else {
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
      }
    } else {
      var body = jsonDecode(response.body);
      String message = body["Message"].toString();
      if(message == constants.expireToken){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        uiUpdates.ShowToast(message);
      }
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        GetInformation();
      }
    });
  }

  Future<SchoolModel> OpenSchoolDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: SchoolsDialogModel(schoolModelList),
          );
        }
    );
  }

  Future<ChildModel> OpenChildDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: ChildDialogModel(childModelList),
          );
        }
    );
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddSelfEdu()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddSelfEdu() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.education+"create";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['child_id'] = selectedChildID;
    request.fields['emp_id'] = UserSessions.instance.getEmployeeID;
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['school_id'] = selectedSchoolID;
    request.fields['nature'] = selectedNature;
    request.fields['level'] = selectedLevel;
    request.fields['degree'] = degreeController.text.toString();
    request.fields['class'] = classController.text.toString();
    request.fields['started'] = selectedStartedDate;
    request.fields['ended'] = selectedEndedDate;
    request.fields['living'] = selectedLiving;
    request.fields['whom'] = "Child";
    request.fields['fileno'] = fileNoController.text.toString();
    request.fields['hostel'] = placeNameController.text.toString();
    request.fields['address'] = placeAddressController.text.toString();
    request.fields['contact'] = placeContactController.text.toString();
    request.fields['offering'] = selectMessOffering;
    request.fields['transport'] = selectedTransportUse;
    request.files.add(
        http.MultipartFile(
            'student_card',
            File(studentCardFilePath).readAsBytes().asStream(),
            File(studentCardFilePath).lengthSync(),
            filename: studentCardFilePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'affiliate',
            File(affiliateFilePath).readAsBytes().asStream(),
            File(affiliateFilePath).lengthSync(),
            filename: affiliateFilePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'challan',
            File(challanFilePath).readAsBytes().asStream(),
            File(challanFilePath).lengthSync(),
            filename: challanFilePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'result_card',
            File(resultCardFilePath).readAsBytes().asStream(),
            File(resultCardFilePath).lengthSync(),
            filename: resultCardFilePath.split("/").last
        )
    );

    APIService.addAuthHeaderToMultipartRequest(request);
    var response = await request.send();
    uiUpdates.DismissProgresssDialog();
    try {
      final resp = await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.selfEducationMessage);
          Navigator.pop(context);
        } else {
          uiUpdates.ShowToast(Strings.instance.failedSelfEducation);
        }
      } else {
        var body = jsonDecode(resp.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    }catch(e){
      uiUpdates.ShowToast(e);
    }
  }
}
