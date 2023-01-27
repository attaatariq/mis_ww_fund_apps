import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/city_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/company_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/disability_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/district_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/province_dialog_model.dart';
import 'package:welfare_claims_app/models/CityModel.dart';
import 'package:welfare_claims_app/models/CompanyModel.dart';
import 'package:welfare_claims_app/models/CompanyWorkerInformationModel.dart';
import 'package:welfare_claims_app/models/DistritModel.dart';
import 'package:welfare_claims_app/models/ProvinceModel.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/general/location_picker.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';

class EmployeeFirstTab extends StatefulWidget {
  final parentFunction;

  EmployeeFirstTab(this.parentFunction);

  @override
  _EmployeeFirstTabState createState() => _EmployeeFirstTabState();
}

TextEditingController cWFatherNameController= TextEditingController();
TextEditingController cWPayScaleController= TextEditingController();
TextEditingController cWDesignationController= TextEditingController();
TextEditingController cWEobiNumberController= TextEditingController();
TextEditingController cWSsnNumberController= TextEditingController();
TextEditingController cWAddressController= TextEditingController();
TextEditingController cWDisabilityDetailController= TextEditingController();

class _EmployeeFirstTabState extends State<EmployeeFirstTab> {
  String selectedCompanyName= Strings.instance.selectCompany, selectedDobDate=Strings.instance.selectDOB, selectedCNICIssueDate= Strings.instance.selectedCnicIssueDate,
      selectedCNICExpiryDate= Strings.instance.selectedCnicExpiryDate, selectedAppontmentDate= Strings.instance.selectedAppointmentDate, selectedDisability= Strings.instance.selectDisability, selectedCity= Strings.instance.selectCity,
      selectedProvince= Strings.instance.selectProvince, selectedDistrict= Strings.instance.selectDistrict, disabilityType="";
  String selectedCompanyID= "", selectedCityID="", selectedProvinceID="", selectedDistrictID="", locationSelectionTitle=Strings.instance.selectLocation;
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
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
        color: AppTheme.colors.appBlackColors,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            InkWell(
              onTap: (){
                if(EmployeeInformationForm.companiesList.length > 0){
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
                                controller: cWFatherNameController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
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
                _selectDate(context, 0);
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
                                            color: selectedDobDate == Strings.instance.selectDOB ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                      child: Text(selectedCNICIssueDate,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: selectedCNICIssueDate == Strings.instance.selectedCnicIssueDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                      child: Text(selectedCNICExpiryDate,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: selectedCNICExpiryDate == Strings.instance.selectedCnicExpiryDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                controller: cWPayScaleController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Pay Scale",
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
                                controller:  cWDesignationController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
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
                                controller: cWEobiNumberController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.number,
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
                                controller: cWSsnNumberController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.number,
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
                OpenDisabilityDialog(context).then((value) => {
                  if(value != null) {
                    HandelDisabilitySelection(value)
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
                                            color: selectedDisability == Strings.instance.selectDisability ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                controller: cWDisabilityDetailController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
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
                OpenCityDialog(context).then((value) => {
                  if(EmployeeInformationForm.citiesList.length > 0) {
                      OpenCityDialog(context).then((value) {
                        if(value != null) {
                          setState(() {
                            selectedCityID = value.cityID;
                            selectedCity = value.cityName;
                          });
                        }
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
                                controller: cWAddressController,
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
                margin: EdgeInsets.only(top: 10, bottom: 60),
                height: 45,
                color: AppTheme.colors.newPrimary,
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
          ],
        ),
      ),
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

  Future<CompanyModel> OpenCompaniesDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CompaniesDialogModel(EmployeeInformationForm.companiesList),
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
        selectedDate = picked;
        if(position == 0) { ///dob
          selectedDobDate = selectedDate.toString();
        }else if(position == 1){ // issue cnic
          selectedCNICIssueDate = selectedDate.toString();
        }else if(position == 2){ //expire cnic
          selectedCNICExpiryDate = selectedDate.toString();
        }else if(position == 3){ //appointment cnic
          selectedAppontmentDate = selectedDate.toString();
        }
      });
  }

  HandelDisabilitySelection(String value) {
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

  void Validation() {
    if(selectedCompanyID.isNotEmpty){
      if(cWFatherNameController.text.isNotEmpty){
        if(selectedDobDate != Strings.instance.selectDOB) {
          if (selectedCNICIssueDate != Strings.instance.selectedCnicIssueDate) {
            if (selectedCNICExpiryDate != Strings.instance.selectedCnicExpiryDate) {
              if(cWPayScaleController.text.isNotEmpty){
                if(cWEobiNumberController.text.isNotEmpty){
                  if(cWSsnNumberController.text.isNotEmpty){
                    if(selectedDisability != Strings.instance.selectDisability){
                      if(selectedCityID.isNotEmpty){
                        if(selectedProvinceID.isNotEmpty){
                          if(cWAddressController.text.isNotEmpty){
                            if(selectedAppontmentDate != Strings.instance.selectedAppointmentDate) {
                              if(selectedDistrictID.isNotEmpty) {
                                if(data["lat"] != "0.0" && data["lng"] != "0.0"){
                                  if (isDisable) {
                                    if (cWDisabilityDetailController.text
                                        .isNotEmpty) {
                                      disabilityType =
                                          cWDisabilityDetailController.text
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
              }else{
                uiUpdates.ShowToast(Strings.instance.payScaleMessage);
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
    }else{
      uiUpdates.ShowToast(Strings.instance.selectCompany);
    }
  }

  void CreateInoModel() {
    CompanyWorkerInformationModel companyWorkerInformationModel= new CompanyWorkerInformationModel(selectedCompanyID,
      cWFatherNameController.text.toString(), selectedDobDate, selectedCNICIssueDate, selectedCNICExpiryDate, selectedAppontmentDate, cWPayScaleController.text.toString(),
      cWDesignationController.text.toString(), cWEobiNumberController.text.toString(), cWSsnNumberController.text.toString(),
        selectedDisability, disabilityType, selectedCityID, selectedDistrictID, selectedProvinceID, cWAddressController.text.toString(), data["lat"], data["lng"]);
    EmployeeInformationForm.companyWorkerInformationModel= companyWorkerInformationModel;
    ////call Function
    widget.parentFunction(1);
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}
