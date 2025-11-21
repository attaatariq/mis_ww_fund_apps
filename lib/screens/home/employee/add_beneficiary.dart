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
import 'package:wwf_apps/dialogs/banks_dialog_model.dart';
import 'package:wwf_apps/dialogs/beneficiary_relation_dialog_model.dart';
import 'package:wwf_apps/dialogs/city_dialog_model.dart';
import 'package:wwf_apps/dialogs/district_dialog_model.dart';
import 'package:wwf_apps/dialogs/identitity_dialog_model.dart';
import 'package:wwf_apps/dialogs/province_dialog_model.dart';
import 'package:wwf_apps/models/CityModel.dart';
import 'package:wwf_apps/models/DistritModel.dart';
import 'package:wwf_apps/models/ProvinceModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/models/bankAccountTypeModel.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/widgets/form_widgets.dart';
import 'package:wwf_apps/themes/form_theme.dart';
import 'package:wwf_apps/utils/permission_handler.dart';
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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Column(
            children: [
              StandardHeader(
                title: "Add Beneficiary",
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(FormTheme.spacingXL),
                  decoration: BoxDecoration(
                  color: FormTheme.backgroundColor,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormTextField(
                        label: "Beneficiary Name",
                        hint: "Enter beneficiary name",
                        controller: bNameController,
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),

                      FormSelectableField(
                        label: "Identity Type",
                        value: selectedIdentity,
                        hint: Strings.instance.selectedIdentity,
                        prefixIcon: Icons.badge,
                        onTap: () {
                          OpenIdentityTypeDialog(context).then((value) {
                            if(value != null) {
                              setState(() {
                                selectedIdentity = value;
                              });
                            }
                          });
                        },
                      ),

                      FormTextField(
                        label: "CNIC",
                        hint: "Enter CNIC number",
                        controller: bCnicController,
                        prefixIcon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        inputFormatters: [cnicMask],
                        textInputAction: TextInputAction.next,
                      ),

                      FormSelectableField(
                        label: "CNIC Issue Date",
                        value: selectedCNICIssueDate,
                        hint: Strings.instance.selectedCnicIssueDate,
                        prefixIcon: Icons.calendar_today,
                        onTap: () {
                          _selectDate(context, 1);
                        },
                      ),

                      FormSelectableField(
                        label: "CNIC Expiry Date",
                        value: selectedCNICExpiryDate,
                        hint: Strings.instance.selectedCnicExpiryDate,
                        prefixIcon: Icons.calendar_today,
                        onTap: () {
                          _selectDate(context, 2);
                        },
                      ),

                      FormTextField(
                        label: "Guardian Name",
                        hint: "Enter guardian name",
                        controller: bGuardiaNameController,
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),

                      FormSelectableField(
                        label: "Beneficiary Relation",
                        value: selectedBeneficiaryRelation,
                        hint: Strings.instance.beneficiaryRelation,
                        prefixIcon: Icons.people,
                        onTap: () {
                          OpenBeneficiaryRelationModeDialog(context).then((value) {
                            if(value != null) {
                              setState(() {
                                selectedBeneficiaryRelation = value;
                              });
                            }
                          });
                        },
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
                              if(WorkerForm.citiesList.length > 0) {
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
                              if(WorkerForm.districtList.length >
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
                              if(WorkerForm.provincesList.length >
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
                          margin: EdgeInsets.only(
                            top: 15, 
                            bottom: 20 + MediaQuery.of(context).padding.bottom
                          ),
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
            child: CityDialogModel(WorkerForm.citiesList),
          );
        }
    );
  }

  Future<DistrictModel> OpenDistrictDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: DistrictDialogModel(WorkerForm.districtList),
          );
        }
    );
  }

  Future<ProvinceModel> OpenProvinceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: ProvinceDialogModel(WorkerForm.provincesList),
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
            cnicFileName = file.name;
            cnicFilePath = file.path;
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
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
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
        if(entitlementsCities.length > 0 && WorkerForm.citiesList.length == 0){
          entitlementsCities.forEach((row) {
            String city_id= row["city_id"].toString();
            String city_name= row["city_name"].toString();
            WorkerForm.citiesList.add(new CityModel(city_id, city_name));
          });
        }

        ///get provinces
        List<dynamic> entitlementsProvinces = data['states'];
        if(entitlementsProvinces.length > 0 && WorkerForm.provincesList.length == 0){
          entitlementsProvinces.forEach((row) {
            String province_id= row["state_id"].toString();
            String province_name= row["state_name"].toString();
            WorkerForm.provincesList.add(new ProvinceModel(province_id, province_name));
          });
        }

        ///get provinces
        List<dynamic> entitlementsDistricts = data['districts'];
        if(entitlementsDistricts.length > 0 && WorkerForm.districtList.length == 0) {
          entitlementsDistricts.forEach((row) {
            String district_id = row["district_id"].toString();
            String district_name = row["district_name"].toString();
            WorkerForm.districtList.add(
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
        uiUpdates.ShowError(message);
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
          uiUpdates.ShowSuccess(Strings.instance.beneficiaryMessage);
          Navigator.of(context).pop(true);
        } else {
          uiUpdates.ShowToast(Strings.instance.failedbeneficiary);
        }
      } else {
        var body = jsonDecode(resp.body);
        String message = body["Message"].toString();
        uiUpdates.ShowError(message);
      }
    }catch(e){
      uiUpdates.ShowError(e.toString());
    }
  }
}
