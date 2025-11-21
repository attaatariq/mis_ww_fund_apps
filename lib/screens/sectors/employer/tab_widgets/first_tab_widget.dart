import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/city_dialog_model.dart';
import 'package:wwf_apps/dialogs/company_types_dialog_model.dart';
import 'package:wwf_apps/dialogs/month_dialog_model.dart';
import 'package:wwf_apps/dialogs/province_dialog_model.dart';
import 'package:wwf_apps/models/CityModel.dart';
import 'package:wwf_apps/models/MonthModel.dart';
import 'package:wwf_apps/models/ProvinceModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/home/employer/employer_home.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class EmployerFirstTab extends StatefulWidget {
  final parentFunction;

  EmployerFirstTab(this.parentFunction);

  @override
  _EmployerFirstTabState createState() => _EmployerFirstTabState();
}

TextEditingController cNameController= TextEditingController();
TextEditingController cCodeController= TextEditingController();
TextEditingController cFileNoController= TextEditingController();
TextEditingController cIndustryController= TextEditingController();
TextEditingController cFocusController= TextEditingController();
TextEditingController cNumberController= TextEditingController();
TextEditingController cFaxNoController= TextEditingController();
TextEditingController cWebsiteController= TextEditingController();
TextEditingController cAddressController= TextEditingController();

class _EmployerFirstTabState extends State<EmployerFirstTab> {
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  String selectedEstablishDate="Select Establish Date", selectedType= "Select Type", selectedCity= "Select City",
      selectedProvince= "Select Province", selectClosingMonth="Select Closing Month";
  String selectedCityID= "", selectedProvinceID= "", selectedClosingMonthNo="";
  Constants constants;
  UIUpdates uiUpdates;
  String logoFilePath="", logoFileName="Select Logo";
  List<CityModel> citiesList = [];
  List<ProvinceModel> provincesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CreateCitiesList();
    CreateProvincesList();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
            ),

            InkWell(
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
                                      child: Text(selectedEstablishDate,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: selectedEstablishDate == "Select Establish Date" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                controller: cCodeController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Code",
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
                                controller:  cFileNoController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "File No",
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
                                controller: cIndustryController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Industry",
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
                                controller: cFocusController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Focus",
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
                                inputFormatters: [numberMask],
                                controller: cNumberController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
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

            InkWell(
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
                                controller: cFaxNoController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
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
                                controller: cWebsiteController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Website (URL)",
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
                if(citiesList.length > 0) {
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
                                            color: selectedCity == "Select City" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                if(provincesList.length > 0) {
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

            InkWell(
              onTap: (){
                OpenMonthDialog(context).then((value) {
                  if(value != null){
                    setState(() {
                      selectClosingMonth = value.monthName;
                      selectedClosingMonthNo= value.monthNumber;
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
                                      child: Text(selectClosingMonth,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: selectClosingMonth == "Select Closing Month" ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                controller: cAddressController,
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
                margin: EdgeInsets.only(top: 10, bottom: 60),
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
      ),
    );
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

  Future<CityModel> OpenCityDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CityDialogModel(citiesList),
          );
        }
    );
  }

  Future<ProvinceModel> OpenProvinceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: ProvinceDialogModel(provincesList),
          );
        }
    );
  }

  Future<MonthModel> OpenMonthDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: MonthDialogModel(constants.GetMonthModel()),
          );
        }
    );
  }

  void CreateCitiesList() {
    citiesList.add(new CityModel("1", "Islamabad"));
    citiesList.add(new CityModel("2", "Lahore"));
    citiesList.add(new CityModel("3", "Karachi"));
    citiesList.add(new CityModel("4", "Faislabad"));
    citiesList.add(new CityModel("4", "Sargodah"));
  }

  void CreateProvincesList() {
    provincesList.add(new ProvinceModel("1", "Punjab"));
    provincesList.add(new ProvinceModel("2", "Sindh"));
    provincesList.add(new ProvinceModel("3", "Blochistan"));
    provincesList.add(new ProvinceModel("4", "NWFP"));
    provincesList.add(new ProvinceModel("5", "Fata"));
    provincesList.add(new ProvinceModel("6", "Gilgit Baltistan"));
    provincesList.add(new ProvinceModel("7", "Azad Kashmir"));
  }

  void OpenFilePicker() async{
    try {
      var status = await Permission.storage.status;
      if (status.isDenied || status.isPermanentlyDenied || status.isLimited || status.isRestricted) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        // Check if permission was granted
        if (statuses[Permission.storage] != PermissionStatus.granted) {
          uiUpdates.ShowToast("Storage permission is required to select files");
          return;
        }
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
          uiUpdates.ShowToast("File selected: ${file.name}");
        } else {
          uiUpdates.ShowToast("Failed to get file path. Please try again.");
        }
      } else {
        // User cancelled file picker - no need to show error
      }
    } catch (e) {
      uiUpdates.ShowToast("Error selecting file: ${e.toString()}");
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
      lastDate: DateTime(2101),
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
        selectedEstablishDate= selectedDate.toString();
      });
  }

  void Validation() {
    if(cNameController.text.isNotEmpty)
      {
        if(selectedEstablishDate != "Select Establish Date")
        {
          if(cCodeController.text.isNotEmpty)
          {
            if(cFileNoController.text.isNotEmpty)
            {
              if(cIndustryController.text.isNotEmpty)
              {
                if(cFocusController.text.isNotEmpty)
                {
                  if(cNumberController.text.isNotEmpty)
                  {
                    if(cNumberController.text.length == 11)
                    {
                      if(selectedType != "Select Type")
                      {
                        if(cFaxNoController.text.isNotEmpty)
                        {
                          if(cWebsiteController.text.isNotEmpty)
                          {
                            if(selectedCityID != "")
                            {
                              if(selectedProvinceID != "")
                              {
                                if(selectedClosingMonthNo != "") {
                                  if (cAddressController.text.isNotEmpty) {
                                    if (logoFilePath != "") {
                                      CheckConnectivity();
                                    } else {
                                      uiUpdates.ShowToast(
                                          Strings.instance.cLogoMessage);
                                    }
                                  } else {
                                    uiUpdates.ShowToast(
                                        Strings.instance.cAddressMessage);
                                  }
                                }else{
                                  uiUpdates.ShowToast(Strings.instance.cClosingMonthMessage);
                                }
                              }else{
                                uiUpdates.ShowToast(Strings.instance.cProvinceMessage);
                              }
                            }else{
                              uiUpdates.ShowToast(Strings.instance.cCityMessage);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.cWebsiteMessage);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.cFaxNoMessage);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.cTypeMessage);
                      }
                    }else{
                      uiUpdates.ShowToast(Strings.instance.invalidNumberMessage);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.cNumberMessage);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.cFocusMessage);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.cIndustryMessage);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.cFileMessage);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.cCodeMessage);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.cEstablishDateMessage);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.cNameMessage);
    }
  }

  void CheckConnectivity() {
    //uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        SaveData()
      }else{
        uiUpdates.DismissProgresssDialog(),
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  SaveData() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog("Please Wait...");
    var url = constants.getApiBaseURL()+constants.companies+"company";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = cNameController.text.toString();
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['fileno'] = cFileNoController.text.toString();
    request.fields['type'] = selectedType;
    request.fields['industry'] = cIndustryController.text.toString();
    request.fields['engaged'] = cFocusController.text.toString();
    request.fields['landline'] = cNumberController.text.toString();
    request.fields['fax_no'] = cFaxNoController.text.toString();
    request.fields['address'] = cAddressController.text.toString();
    request.fields['city'] = "1";
    request.fields['province'] = "4";
    request.fields['district'] = "54";
    request.fields['website'] = cWebsiteController.text.toString();
    request.fields['started'] = selectedEstablishDate;
    request.fields['closing'] = selectedClosingMonthNo;
    request.files.add(
        http.MultipartFile(
            'logo',
            File(logoFilePath).readAsBytes().asStream(),
            File(logoFilePath).lengthSync(),
            filename: logoFilePath.split("/").last
        )
    );

    APIService.addAuthHeaderToMultipartRequest(request);
    var response = await request.send();
    try{
      final resp= await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.loginSuccess);
          var dataObject = body["Data"].toString();
          UserSessions.instance.setRefID(dataObject);
          UserSessions.instance.setUserAccount("1");
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => EmployerHome(),
            ),
                (route) => false,
          );
        } else {
          uiUpdates.ShowToast(Strings.instance.loginFailed);
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    }catch(e){
      uiUpdates.DismissProgresssDialog();
    }
  }
}
