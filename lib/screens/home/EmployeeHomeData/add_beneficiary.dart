import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/banks_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/beneficiary_relation_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/city_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/district_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/identitity_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/province_dialog_model.dart';
import 'package:welfare_claims_app/models/CityModel.dart';
import 'package:welfare_claims_app/models/DistritModel.dart';
import 'package:welfare_claims_app/models/ProvinceModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/bankAccountTypeModel.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class AddBeneficiary extends StatefulWidget {
  @override
  _AddBeneficiaryState createState() => _AddBeneficiaryState();
}

TextEditingController bNameController= TextEditingController();
TextEditingController bCnicController= TextEditingController();
TextEditingController bGuardiaNameController= TextEditingController();
TextEditingController bNumberController= TextEditingController();
TextEditingController bAddressController= TextEditingController();
TextEditingController bAccountTitleController= TextEditingController();
TextEditingController bAccountNumberController= TextEditingController();

class _AddBeneficiaryState extends State<AddBeneficiary> {
  String cnicFilePath="", cnicFileName="Select CNIC/B-Form";
  String selectedIdentity= Strings.instance.selectedIdentity,
      selectedAccountType= Strings.instance.selectedAccount,
      selectedBeneficiaryRelation = Strings.instance.beneficiaryRelation,
      selectedCity= Strings.instance.selectCity, selectedProvince= Strings.instance.selectProvince, selectedDistrict= Strings.instance.selectDistrict;
  String selectedCNICIssueDate= Strings.instance.selectedCnicIssueDate, selectedCNICExpiryDate= Strings.instance.selectedCnicExpiryDate;
  var cnicMask = new MaskTextInputFormatter(mask: '#####-#######-#',);
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  String selectedCityID="", selectedProvinceID="", selectedDistrictID="";
  String selectedBankName= Strings.instance.selectBankName;
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    GetInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
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
                      child: Text("Add Beneficiary",
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
                                          controller: bNameController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Beneficiary Name",
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
                          OpenIdentityTypeDialog(context).then((value) => {
                            if(value != null){
                              setState(() {
                                selectedIdentity = value;
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
                                                child: Text(selectedIdentity,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedIdentity == Strings.instance.selectedIdentity ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                          controller: bCnicController,
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
                                            hintText: "CNIC",
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
                                          controller: bGuardiaNameController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Guardian Name",
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
                          OpenBeneficiaryRelationModeDialog(context).then((value) => {
                            if(value != null){
                              setState(() {
                                selectedBeneficiaryRelation = value;
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
                                                child: Text(selectedBeneficiaryRelation,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedBeneficiaryRelation == Strings.instance.beneficiaryRelation ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                          controller: bNumberController,
                                          inputFormatters: [numberMask],
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
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
                                          controller: bAddressController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
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
                        onTap: (){
                          OpenCityDialog(context).then((value) => {
                            if(value != null){
                              if(EmployeeInformationForm.citiesList.length > 0) {
                                OpenCityDialog(context).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedCityID = value.cityID;
                                      selectedCity = value.cityName;
                                    });
                                  }
                                })
                              } else
                                {
                                  uiUpdates.ShowToast("Cities Not Available")
                                }
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
                          OpenCityDialog(context).then((value) => {
                            if(value != null){
                              if(EmployeeInformationForm.districtList.length >
                                  0) {
                                OpenDistrictDialog(context).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedDistrictID = value.id;
                                      selectedDistrict = value.name;
                                    });
                                  }
                                })
                              } else
                                {
                                  uiUpdates.ShowToast("District Not Available")
                                }
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
                      ),

                      InkWell(
                        onTap: (){
                          OpenProvinceDialog(context).then((value) => {
                            if(value != null){
                              if(EmployeeInformationForm.provincesList.length >
                                  0) {
                                OpenProvinceDialog(context).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedProvinceID = value.provinceID;
                                      selectedProvince = value.provinceName;
                                    });
                                  }
                                })
                              } else
                                {
                                  uiUpdates.ShowToast("Provinces Not Available")
                                }
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
                      ),

                      InkWell(
                        onTap: (){
                          OpenBankDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectedBankName = value;
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
                                                child: Text(selectedBankName,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedBankName == Strings.instance.selectBankName ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                          controller: bAccountTitleController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Account Title",
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

                          BankAccountTypeDialog(context).then((value) => {
                            if(value != null){
                              setState(() {
                                selectedAccountType = value;
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
                                                child: Text(selectedAccountType,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedAccountType == Strings.instance.selectedAccount ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                          controller: bAccountNumberController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Account Number",
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
                          OpenFilePicker();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                          ),
                          child: Center(
                            child: Text(cnicFileName,
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

  Future<String> OpenIdentityTypeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: IdentityDialogModel(),
          );
        }
    );
  }

  Future<String> BankAccountTypeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: BankAccountTypeDialogModel(),
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
          selectedCNICIssueDate = dateFormat.format(picked).toString();
        }else if(position == 2){ //expire cnic
          selectedCNICExpiryDate = dateFormat.format(picked).toString();
        }
      });
  }

  Future<String> OpenBeneficiaryRelationModeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: BeneficiaryRelationDialogModel(),
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

  Future<String> OpenBankDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: BanksDialogModel(constants.GetBanksModel()),
          );
        }
    );
  }

  void OpenFilePicker() async{
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied || status.isLimited || status.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf", "png", "jpeg", "jpg"]
    );

    if(result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        cnicFileName = file.name;
        cnicFilePath = file.path;
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void Validation() {
    if(bNameController.text.toString().isNotEmpty){
      if(selectedIdentity != Strings.instance.selectedIdentity){
        if(bCnicController.text.toString().isNotEmpty){
          if(selectedCNICIssueDate != Strings.instance.selectedCnicIssueDate){
            if(selectedCNICExpiryDate != Strings.instance.selectedCnicExpiryDate){
              if(bGuardiaNameController.text.toString().isNotEmpty){
                if(selectedBeneficiaryRelation != Strings.instance.selectedBeneficiaryRelation){
                  if(bNumberController.text.toString().isNotEmpty){
                    if(bAddressController.text.toString().isNotEmpty){
                      if(selectedCityID.isNotEmpty){
                        if(selectedDistrictID.isNotEmpty){
                          if(selectedProvinceID.isNotEmpty){
                            if(selectedBankName != Strings.instance.selectBankName){
                              if(bAccountTitleController.text.toString().isNotEmpty){
                                if(bAccountNumberController.text.toString().isNotEmpty){
                                  if(cnicFilePath.isNotEmpty){
                                    if(selectedAccountType != Strings.instance.selectedAccount){
                                      CheckConnectivity();
                                    }else{
                                      uiUpdates.ShowToast(Strings.instance.bSelectAccount);
                                    }
                                  }else{
                                    uiUpdates.ShowToast(Strings.instance.bSelectCnic);
                                  }
                                }else{
                                  uiUpdates.ShowToast(Strings.instance.bAccountNumber);
                                }
                              }else{
                                uiUpdates.ShowToast(Strings.instance.bAccountTitle);
                              }
                            }else{
                              uiUpdates.ShowToast(Strings.instance.selectBankName);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.selectProvince);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.selectDistrict);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.selectCity);
                      }
                    }else{
                      uiUpdates.ShowToast(Strings.instance.bAddress);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.bContactNumber);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.selectedBeneficiaryRelation);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.bGuardianName);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.selectedCnicExpiryDate);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.selectedCnicIssueDate);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.bCnicNumber);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectedIdentity);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectBeneficiaryName);
    }
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
    List<String> tagsList= [constants.accountInfo, constants.citiesInfo, constants.statesInfo, constants.districtsInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "user_token": UserSessions.instance.getToken,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data);
    print(response.body+" : "+response.statusCode.toString());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var account= data["account"];
        String empID= account["emp_id"];
        UserSessions.instance.setEmployeeID(empID);

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

        ///get provinces
        List<dynamic> entitlementsDistricts = data['districts'];
        if(entitlementsDistricts.length > 0 && EmployeeInformationForm.districtList.length == 0) {
          entitlementsDistricts.forEach((row) {
            String district_id = row["district_id"].toString();
            String district_name = row["district_name"].toString();
            EmployeeInformationForm.districtList.add(
                new DistrictModel(district_id, district_name));
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

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddBeneficiar()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddBeneficiar() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.claims+"beneficiary";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = bNameController.text.toString();//
    request.fields['emp_id'] = UserSessions.instance.getEmployeeID;//
    request.fields['user_id'] = UserSessions.instance.getUserID;//
    request.fields['cnic'] = bCnicController.text.toString();//
    request.fields['bissued'] = selectedCNICIssueDate;//
    request.fields['bexpiry'] = selectedCNICExpiryDate;//
    request.fields['guardian'] = bGuardiaNameController.text.toString();//
    request.fields['relation'] = selectedBeneficiaryRelation;//
    request.fields['contact'] = bNumberController.text.toString();//
    request.fields['address'] = bAddressController.text.toString();//
    request.fields['city'] = selectedCityID;//
    request.fields['district'] = selectedDistrictID;//
    request.fields['province'] = selectedProvinceID;//
    request.fields['bank'] = selectedBankName;//
    request.fields['title'] = bAccountTitleController.text.toString();
    request.fields['account'] = bAccountNumberController.text.toString();
    request.fields['itype'] = selectedIdentity;
    request.fields['type'] = selectedAccountType;

    request.files.add(
        http.MultipartFile(
            'bene_upload',
            File(cnicFilePath).readAsBytes().asStream(),
            File(cnicFilePath).lengthSync(),
            filename: cnicFilePath.split("/").last
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
          uiUpdates.ShowToast(Strings.instance.beneficiaryMessage);
          Navigator.of(context).pop(true);
        } else {
          uiUpdates.ShowToast(Strings.instance.failedbeneficiary);
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
