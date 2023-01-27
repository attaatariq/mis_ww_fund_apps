import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/CityModel.dart';
import 'package:welfare_claims_app/models/CommpanyWorkerBankInformationModel.dart';
import 'package:welfare_claims_app/models/CompanyModel.dart';
import 'package:welfare_claims_app/models/CompanyWorkerInformationModel.dart';
import 'package:welfare_claims_app/models/DistritModel.dart';
import 'package:welfare_claims_app/models/ProvinceModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/tab_widgets/first_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/tab_widgets/second_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/tab_widgets/third_tab_widget.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EmployeeInformationForm extends StatefulWidget {
  int selectedTab= 0;
  static CompanyWorkerInformationModel companyWorkerInformationModel;
  static CompanyWorkerBankInformationModel companyWorkerBankInformationModel;
  static List<CityModel> citiesList= [];
  static List<ProvinceModel> provincesList= [];
  static List<DistrictModel> districtList= [];
  static List<CompanyModel> companiesList= [];

  @override
  _EmployeeInformationFormState createState() => _EmployeeInformationFormState();
}

class _EmployeeInformationFormState extends State<EmployeeInformationForm> {

  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppTheme.colors.newPrimary
    ));
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    GetInformation();
  }

  void parentFunction(newInt)
  {
    setState(() {
      widget.selectedTab= newInt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.appBlackColors,
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.colors.colorDarkGray,
                    offset: Offset(0.0, 0.2), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: widget.selectedTab == 0 || widget.selectedTab == 3 ? AppTheme.colors.newPrimary : AppTheme.colors.newWhite,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("Information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: widget.selectedTab == 0 || widget.selectedTab == 3 ? AppTheme.colors.newWhite : AppTheme.colors.colorDarkGray,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 2,
                              color: AppTheme.colors.newWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: 2,
                    color: AppTheme.colors.newPrimary,
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      color: widget.selectedTab == 1 || widget.selectedTab == 4 ? AppTheme.colors.newPrimary : AppTheme.colors.newWhite,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("Bank",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: widget.selectedTab == 1 || widget.selectedTab == 4 ? AppTheme.colors.white : AppTheme.colors.colorDarkGray,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 2,
                              color: AppTheme.colors.newWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: 2,
                    color: AppTheme.colors.newPrimary,
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      color: widget.selectedTab == 2 ? AppTheme.colors.newPrimary : AppTheme.colors.newWhite,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("Documents",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: widget.selectedTab == 2 ? AppTheme.colors.newWhite : AppTheme.colors.colorDarkGray,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 2,
                              color: AppTheme.colors.newWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    widget.selectedTab == 0 ? EmployeeFirstTab(parentFunction) : widget.selectedTab == 1 ? EmployeeSecondTab(parentFunction) : widget.selectedTab == 2 ? EmployeeThirdTab(parentFunction) :
                    widget.selectedTab == 3 ? EmployeeFirstTab(parentFunction) : EmployeeSecondTab(parentFunction)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GetInformation() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information/"+UserSessions.instance.getUserID+"/"+UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    print(response.body+" : "+response.statusCode.toString());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
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

