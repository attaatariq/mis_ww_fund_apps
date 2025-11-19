import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/city_dialog_model.dart';
import 'package:wwf_apps/dialogs/disability_dialog_model.dart';
import 'package:wwf_apps/dialogs/district_dialog_model.dart';
import 'package:wwf_apps/dialogs/province_dialog_model.dart';
import 'package:wwf_apps/models/CityModel.dart';
import 'package:wwf_apps/models/CompanyModel.dart';
import 'package:wwf_apps/models/CompanyWorkerInformationModel.dart';
import 'package:wwf_apps/models/DistritModel.dart';
import 'package:wwf_apps/models/ProvinceModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/general/location_picker.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class WWFEmployeeFirstTab extends StatefulWidget {
  final parentFunction;

  WWFEmployeeFirstTab(this.parentFunction);

  @override
  _WWFEmployeeFirstTabState createState() => _WWFEmployeeFirstTabState();
}

TextEditingController wWFatherNameController= TextEditingController();
TextEditingController wWDesignationController= TextEditingController();
TextEditingController wWEobiNumberController= TextEditingController();
TextEditingController wWSsnNumberController= TextEditingController();
TextEditingController wWAddressController= TextEditingController();
TextEditingController wWDisabilityDetailController= TextEditingController();

class _WWFEmployeeFirstTabState extends State<WWFEmployeeFirstTab> {
  String selectedDobDate=Strings.instance.selectDOB, selectedCNICIssueDate= Strings.instance.selectedCnicIssueDate,
      selectedCNICExpiryDate= Strings.instance.selectedCnicExpiryDate, selectedDisability= Strings.instance.selectDisability, selectedCity= Strings.instance.selectCity, selectedDistrict= Strings.instance.selectDistrict,
      selectedProvince= Strings.instance.selectProvince, selectedDistrictID="", locationSelectionTitle=Strings.instance.selectLocation, selectedAppontmentDate= Strings.instance.selectedAppointmentDate;
  String selectedCityID= "", selectedProvinceID="", disabilityType="";
  bool isDisable= false;
  Constants constants;
  UIUpdates uiUpdates;
  Map data = {"lat" : "0.0", "lng" : "0.0"};
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 15),
      color: AppTheme.colors.newWhite,
      child: ListView(
        padding: EdgeInsets.all(0),
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
                              controller: wWFatherNameController,
                              cursorColor: AppTheme.colors.newPrimary,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.colors.newBlack
                              ),
                              decoration: InputDecoration(
                                hintText: "Father Name",
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
                                    child: Text(selectedDobDate,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedDobDate == "Select Date of Birth" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                    child: Text(selectedCNICIssueDate,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedCNICIssueDate == "CNIC Issue Date" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
              _selectDate(context, 3);
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
                                    child: Text(selectedCNICExpiryDate,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedCNICExpiryDate == "CNIC Expiry Date" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
              _selectDate(context, 4);
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
                                    child: Text(selectedAppontmentDate,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedAppontmentDate == Strings.instance.selectedAppointmentDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                              controller: wWDesignationController,
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
                              controller: wWEobiNumberController,
                              cursorColor: AppTheme.colors.newPrimary,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.colors.newBlack
                              ),
                              decoration: InputDecoration(
                                hintText: "EOBI Number",
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
                              controller: wWSsnNumberController,
                              cursorColor: AppTheme.colors.newPrimary,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.colors.newBlack
                              ),
                              decoration: InputDecoration(
                                hintText: "SSN Number",
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
              OpenDisabilityDialog(context).then((value) {
                if(value != null) {
                  HandelDisabilitySelection(value);
                }
              });
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
                                    child: Text(selectedDisability,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedDisability == "Select Disability" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

          isDisable ? Container(
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
                              controller: wWDisabilityDetailController,
                              cursorColor: AppTheme.colors.newPrimary,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.colors.newBlack
                              ),
                              decoration: InputDecoration(
                                hintText: "Disability Detail",
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
          ) : Container(),

          InkWell(
            onTap: (){
              if(EmployeeInformationForm.citiesList.length > 0) {
                OpenCityDialog(context).then((value) {
                  if(value != null) {
                    setState(() {
                      selectedCityID = value.cityID;
                      selectedCity = value.cityName;
                    });
                  }
                });
              }else{
                uiUpdates.ShowToast("Cities Not Available");
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
                                    child: Text(selectedCity,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedCity == Strings.instance.selectCity ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
              if(EmployeeInformationForm.districtList.length > 0) {
                OpenDistrictDialog(context).then((value) {
                  if(value != null) {
                    setState(() {
                      selectedDistrictID = value.id;
                      selectedDistrict = value.name;
                    });
                  }
                });
              }else{
                uiUpdates.ShowToast("District Not Available");
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
                                    child: Text(selectedDistrict,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedDistrict == Strings.instance.selectDistrict ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
              if(EmployeeInformationForm.provincesList.length > 0) {
                OpenProvinceDialog(context).then((value) {
                  if(value != null){
                    setState(() {
                      selectedProvinceID = value.provinceID;
                      selectedProvince= value.provinceName;
                    });
                  }
                });
              }else{
                uiUpdates.ShowToast("Provinces Not Available");
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
                                    child: Text(selectedProvince,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: selectedProvince == "Select Province" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                              controller: wWAddressController,
                              cursorColor: AppTheme.colors.newPrimary,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.colors.newBlack
                              ),
                              decoration: InputDecoration(
                                hintText: "Address",
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
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => LocationPicker()
              )).then((value) => {
                if(value != null){
                  data = value,
                  if(data["lat"] != "0.0" && data["lng"] != "0.0"){
                    setState(() {
                      locationSelectionTitle = "Change Location";
                    })
                  }
                }
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
              ),
              child: Center(
                child: Text(locationSelectionTitle,
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
              margin: EdgeInsets.only(top: 30, bottom: 60),
              height: 45,
              color: AppTheme.colors.newPrimary,
              child: Center(
                child: Text("Next",
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
    );
  }

  Future<void> _selectDate(BuildContext context, int from) async {
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
    MaterialColor myColorWhite = MaterialColor(constants.dateDialogText, color);
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: myColor,
                primaryColorDark: myColorWhite,
                accentColor: myColorWhite,
              ),
              dialogBackgroundColor:Colors.white,
            ),
            child: child,
          );
        },);
    if (picked != null && picked != selectedDate)
      setState(() {
        if(from == 1) {
          selectedDobDate = picked.toString();
        }else if(from == 2){
          selectedCNICIssueDate = picked.toString();
        }else if(from == 3){
          selectedCNICExpiryDate= picked.toString();
        }else if(from == 4){
          selectedAppontmentDate = picked.toString();
        }
      });
  }

  Future<String> OpenDisabilityDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: DisabilityDialogModel(),
          );
        }
    );
  }

  void HandelDisabilitySelection(String value) {
    if(value == constants.disable)
    {
      setState(() {
        selectedDisability= constants.disable;
        isDisable= true;
      });
    }else{
      setState(() {
        selectedDisability= constants.notDisable;
        isDisable= false;
      });
    }
  }

  Future<CityModel> OpenCityDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CityDialogModel(EmployeeInformationForm.citiesList),
          );
        }
    );
  }

  Future<ProvinceModel> OpenProvinceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: ProvinceDialogModel(EmployeeInformationForm.provincesList),
          );
        }
    );
  }

  Future<DistrictModel> OpenDistrictDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: DistrictDialogModel(EmployeeInformationForm.districtList),
          );
        }
    );
  }

  void Validation() {
    if(wWFatherNameController.text.isNotEmpty){
      if(selectedDobDate != Strings.instance.selectDOB) {
        if (selectedCNICIssueDate != Strings.instance.selectedCnicIssueDate) {
          if (selectedCNICExpiryDate != Strings.instance.selectedCnicExpiryDate) {
            if(wWEobiNumberController.text.isNotEmpty){
              if(wWSsnNumberController.text.isNotEmpty){
                if(selectedDisability != Strings.instance.selectDisability){
                  if(selectedCityID.isNotEmpty){
                    if(selectedProvinceID.isNotEmpty){
                      if(wWAddressController.text.isNotEmpty){
                        if(selectedAppontmentDate != Strings.instance.selectedAppointmentDate) {
                          if(selectedDistrictID.isNotEmpty) {
                            if(data["lat"] != "0.0" && data["lng"] != "0.0"){
                              if (isDisable) {
                                if (wWDisabilityDetailController.text
                                    .isNotEmpty) {
                                  disabilityType =
                                      wWDisabilityDetailController.text
                                          .toString();
                                  CreateInoModel();
                                } else {
                                  uiUpdates.ShowToast(
                                      Strings.instance.disabilityDetail);
                                }
                              } else {
                                CreateInoModel();
                              }
                            }else{
                              uiUpdates.ShowToast(Strings.instance.selectLocation);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.selectDistrict);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.selectedAppointmentDate);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.addressMessage);
                      }
                    }else{
                      uiUpdates.ShowToast(Strings.instance.selectProvince);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.selectCity);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.selectDisability);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.ssnNumberMessage);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.eobiNumberMessage);
            }
          } else {
            uiUpdates.ShowToast(Strings.instance.selectedCnicExpiryDate);
          }
        } else {
          uiUpdates.ShowToast(Strings.instance.selectedCnicIssueDate);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectDOB);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.fatherNameMessage);
    }
  }

  void CreateInoModel() {
    CompanyWorkerInformationModel companyWorkerInformationModel= new CompanyWorkerInformationModel("1",
        wWFatherNameController.text.toString(), selectedDobDate, selectedCNICIssueDate, selectedCNICExpiryDate, selectedAppontmentDate, "Null",
        wWDesignationController.text.toString(), wWEobiNumberController.text.toString(), wWSsnNumberController.text.toString(),
        selectedDisability, disabilityType, selectedCityID, selectedDistrictID, selectedProvinceID, wWAddressController.text.toString(), data["lat"], data["lng"]);
    EmployeeInformationForm.companyWorkerInformationModel= companyWorkerInformationModel;
    ////call Function
    widget.parentFunction(1);
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        if(UserSessions.instance.getEmployeeID == ""){
          GetInformation();
        }
      }
    });
  }

  GetInformation() async{

    List<String> tagsList= [constants.accountInfo, constants.citiesInfo, constants.statesInfo, constants.districtsInfo,constants.companiesInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data);
    
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];

        ///get companies
        List<dynamic> entitlementsCompanies = data['companies'];
        if(entitlementsCompanies.length > 0){
          entitlementsCompanies.forEach((row) {
            String comp_id= row["comp_id"].toString();
            String comp_name= row["comp_name"].toString();
            EmployeeInformationForm.companiesList.add(new CompanyModel(comp_id, comp_name));
          });
        }

        ///get cities
        List<dynamic> entitlementsCities = data['cities'];
        if(entitlementsCities.length > 0){
          entitlementsCities.forEach((row) {
            String city_id= row["city_id"].toString();
            String city_name= row["city_name"].toString();
            EmployeeInformationForm.citiesList.add(new CityModel(city_id, city_name));
          });
        }

        ///get provinces
        List<dynamic> entitlementsProvinces = data['states'];
        if(entitlementsProvinces.length > 0){
          entitlementsProvinces.forEach((row) {
            String province_id= row["state_id"].toString();
            String province_name= row["state_name"].toString();
            EmployeeInformationForm.provincesList.add(new ProvinceModel(province_id, province_name));
          });
        }

        ///get provinces
        List<dynamic> entitlementsDistricts = data['districts'];
        if(entitlementsDistricts.length > 0){
          entitlementsDistricts.forEach((row) {
            String district_id= row["district_id"].toString();
            String district_name= row["district_name"].toString();
            EmployeeInformationForm.districtList.add(new DistrictModel(district_id, district_name));
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
}
