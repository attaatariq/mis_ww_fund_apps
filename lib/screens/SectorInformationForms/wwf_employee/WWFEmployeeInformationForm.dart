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
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/tab_widgets/first_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/tab_widgets/second_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/tab_widgets/third_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/wwf_employee/tab_widgets/first_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/wwf_employee/tab_widgets/second_tab_widget.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/wwf_employee/tab_widgets/third_tab_widget.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class WWFEmployeeInformationForm extends StatefulWidget {
  int selectedTab= 0;

  @override
  _WWFEmployeeInformationFormState createState() => _WWFEmployeeInformationFormState();
}

class _WWFEmployeeInformationFormState extends State<WWFEmployeeInformationForm> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppTheme.colors.newPrimary
    ));
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
      backgroundColor: AppTheme.colors.newWhite,
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
                                  color: widget.selectedTab == 1 || widget.selectedTab == 4 ? AppTheme.colors.newWhite : AppTheme.colors.colorDarkGray,
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
                    widget.selectedTab == 0 ? WWFEmployeeFirstTab(parentFunction) : widget.selectedTab == 1 ? WWFEmployeeSecondTab(parentFunction) : widget.selectedTab == 2 ? WWFEmployeeThirdTab(parentFunction) :
                    widget.selectedTab == 3 ? WWFEmployeeFirstTab(parentFunction) : WWFEmployeeSecondTab(parentFunction)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

