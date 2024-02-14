import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/city_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/company_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/company_types_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/disability_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/district_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/province_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/turnover_dialog_model.dart';
import 'package:welfare_claims_app/models/CityModel.dart';
import 'package:welfare_claims_app/models/CompanyModel.dart';
import 'package:welfare_claims_app/models/DistritModel.dart';
import 'package:welfare_claims_app/models/ProvinceModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EmployeeTurnOver extends StatefulWidget {
  @override
  _EmployeeTurnOverState createState() => _EmployeeTurnOverState();
}

TextEditingController nameController= TextEditingController();
TextEditingController addressController= TextEditingController();
TextEditingController cNameController= TextEditingController();
TextEditingController cLandlineController= TextEditingController();

class _EmployeeTurnOverState extends State<EmployeeTurnOver> {
  String selectedCompanyName= Strings.instance.selectCompany,selectedType= "Select Type", selectedCompanyID= "", selectedTurnoverType= Strings.instance.turnOverType,
      selectedCityID="", selectedProvinceID="", selectedDistrictID="", selectedCity= Strings.instance.selectCity,
      selectedProvince= Strings.instance.selectProvince, selectedDistrict= Strings.instance.selectDistrict, selectedAppointedDate = Strings.instance.selectedAppointmentDate;
  List<CompanyModel> companiesList= [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isNew = true;
  int _radioValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    GetInformation();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          isNew= true;
          break;
        case 1:
          isNew= false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
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
                      child: Text("Turn-Over",
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
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [

                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: AppTheme.colors.newPrimary,
                                    ),
                                    child: Radio(
                                      value: 0,
                                      activeColor: AppTheme.colors.newPrimary,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Text("New Company",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newPrimary,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Theme(
                                    data: ThemeData(
                                      //here change to your color
                                      unselectedWidgetColor: AppTheme.colors.newPrimary,
                                    ),
                                    child: Radio(
                                      value: 1,
                                      activeColor: AppTheme.colors.newPrimary,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Text("Existing Company",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.colors.newPrimary,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    _radioValue == 0 ? InkWell(
                      onTap: (){
                        OpenTurnOverDialog(context).then((value) => {
                          HandelTurnoverSelection(value)
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
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
                                              child: Text(selectedTurnoverType,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: selectedTurnoverType == Strings.instance.turnOverType ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                    ) : Container(),

                    _radioValue == 1 ? InkWell(
                      onTap: (){
                        if(companiesList.length > 0){
                          OpenCompaniesDialog(context).then((value) => {
                            setState(() {
                              selectedCompanyID = value.id;
                              selectedCompanyName = value.name;
                            })
                          });
                        }else{
                          uiUpdates.ShowToast(Strings.instance.companiesNotAvail);
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
                                              child: Text(selectedCompanyName,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: selectedCompanyName == Strings.instance.selectCompany ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                    ) : Container(),

                    _radioValue == 0 ? Container(
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
                                        controller: cNameController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.text,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Company Name",
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
                    _radioValue == 1?Container():InkWell(
                      onTap: (){
                        OpenCompanyTypeDialog(context).then((value) => {
                          if(value != null){
                            setState(() {
                              selectedType = value;
                            })
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
                                              child: Text(selectedType,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: selectedType == "Select Type" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                    _radioValue == 0 ? Container(
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
                                        controller: cLandlineController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Company Landline",
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

                    _radioValue == 0 || _radioValue == 1 ? InkWell(
                      onTap: (){
                        _selectDate(context);
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
                                              child: Text(selectedAppointedDate,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: selectedAppointedDate == Strings.instance.selectedAppointmentDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                    ) : Container(),

                    _radioValue == 0 ? InkWell(
                      onTap: (){
                        OpenCityDialog(context).then((value) => {
                          if(value != null) {
                            setState(() {
                              selectedCityID = value.cityID;
                              selectedCity = value.cityName;
                            })
                          }else{
                            uiUpdates.ShowToast("Cities Not Available")
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
                    ) : Container(),

                    _radioValue == 0 ? InkWell(
                      onTap: (){
                        OpenDistrictDialog(context).then((value) {
                          if(value != null) {
                            setState(() {
                              selectedDistrictID = value.id;
                              selectedDistrict = value.name;
                            });
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
                    ) : Container(),

                    _radioValue == 0 ? InkWell(
                      onTap: (){
                        OpenProvinceDialog(context).then((value) {
                          if(value != null){
                            setState(() {
                              selectedProvinceID = value.provinceID;
                              selectedProvince= value.provinceName;
                            });
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
                                              child: Text(selectedProvince,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: selectedProvince == Strings.instance.selectProvince ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                    ) : Container(),

                    _radioValue == 0 ? Container(
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
                                        controller: addressController,
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
                    ) : Container(),

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

  Future<String> OpenTurnOverDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: TurnoverDialogModel(),
          );
        }
    );
  }

  Future<CompanyModel> OpenCompaniesDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CompaniesDialogModel(companiesList),
          );
        }
    );
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

  HandelTurnoverSelection(String value) {
    if(value == constants.current)
    {
      setState(() {
        selectedTurnoverType= constants.current;
      });
    }else{
      setState(() {
        selectedTurnoverType= constants.previous;
      });
    }
  }

  GetInformation() async{
    List<String> tagsList= [constants.accountInfo, constants.citiesInfo, constants.statesInfo, constants.districtsInfo,constants.companiesInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "user_token": UserSessions.instance.getToken,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data);
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    print(data);
    print(url+response.body);
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
            companiesList.add(new CompanyModel(comp_id, comp_name));
          });
        }

        ///get cities
        List<dynamic> entitlementsCities = data['cities'];
        if(entitlementsCities.length > 0 && EmployeeInformationForm.citiesList.length == 0){
          entitlementsCities.forEach((row) {
            String city_id= row["city_id"].toString();
            String city_name= row["city_name"].toString();
            EmployeeInformationForm.citiesList.add(new CityModel(city_id, city_name));
          });
        }

        ///get provinces
        List<dynamic> entitlementsProvinces = data['states'];
        if(entitlementsProvinces.length > 0 && EmployeeInformationForm.provincesList.length == 0){
          entitlementsProvinces.forEach((row) {
            String province_id= row["state_id"].toString();
            String province_name= row["state_name"].toString();
            EmployeeInformationForm.provincesList.add(new ProvinceModel(province_id, province_name));
          });
        }

        ///get district
        List<dynamic> entitlementsDistricts = data['districts'];
        if(entitlementsDistricts.length > 0 && EmployeeInformationForm.districtList.length == 0){
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
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
      firstDate: DateTime(1947, 8),
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
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        //selectedDate = picked;
        selectedAppointedDate = dateFormat.format(picked).toString();
      });
  }

  void Validation() {
    if(_radioValue == 0){
      if(selectedTurnoverType != Strings.instance.turnOverType){
        if(cNameController.text.toString().isNotEmpty){
          if(selectedType != "Select Type"){
          if(selectedAppointedDate != Strings.instance.selectedAppointmentDate){
            if(selectedCityID.isNotEmpty){
              if(selectedProvinceID.isNotEmpty){
                if(selectedDistrictID.isNotEmpty) {
                  if(addressController.text.toString().isNotEmpty){
                    if(cLandlineController.text.toString().isNotEmpty){
                      CheckConnection();
                    }else{
                      uiUpdates.ShowToast(Strings.instance.cLandlineMessage);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.addressMessage);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.selectDistrict);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.selectProvince);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.selectCity);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.selectedAppointmentDate);
          }}else{
            uiUpdates.ShowToast(Strings.instance.cTypeMessage);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.cNameMessage);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.turnOverType);
      }
    }else{
      if(selectedCompanyID.isNotEmpty){
        if(selectedAppointedDate != Strings.instance.selectedAppointmentDate){
          CheckConnection();
        }else{
          uiUpdates.ShowToast(Strings.instance.selectedAppointmentDate);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectCompany);
      }
    }
  }

  void CheckConnection() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        if(_radioValue == 0){
          SaveNewTurnOver()
        }else{
          SaveExistingTurnOver()
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  SaveNewTurnOver() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    Map data = {
      "user_id": UserSessions.instance.getUserID,//
      "user_token": UserSessions.instance.getToken,//
      "emp_id": UserSessions.instance.getEmployeeID,//
      "comp_name": cNameController.text.toString(),//
      "comp_address": addressController.text.toString(),//
      "comp_city": selectedCityID,//
      "comp_district": selectedDistrictID,//
      "comp_province": selectedProvinceID,//
      "comp_status": selectedTurnoverType,//
      "appointed_at": selectedAppointedDate,//
      "comp_type": selectedType,
      "comp_landline":  cLandlineController.text.toString(),
    };

    var url = constants.getApiBaseURL()+constants.companies+"turntonew";
    var response = await http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.turnOverSaveSuccess);
      } else {
        uiUpdates.ShowToast(Strings.instance.turnOverSaveFail);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  SaveExistingTurnOver() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "user_token": UserSessions.instance.getToken,
      "emp_id": UserSessions.instance.getEmployeeID,
      "comp_id": selectedCompanyID,
      "appointed_at": selectedAppointedDate,
    };

    var url = constants.getApiBaseURL()+constants.companies+"turntoexist";
    var response = await http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.turnOverSaveSuccess);
      } else {
        uiUpdates.ShowToast(Strings.instance.turnOverSaveFail);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
  Future<String> OpenCompanyTypeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CompanyTypesDialogModel(constants.GetCompanyTypes()),
          );
        }
    );
  }

}
