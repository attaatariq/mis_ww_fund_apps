import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/CityModel.dart';
import 'package:wwf_apps/models/CommpanyWorkerBankInformationModel.dart';
import 'package:wwf_apps/models/CompanyModel.dart';
import 'package:wwf_apps/models/CompanyWorkerInformationModel.dart';
import 'package:wwf_apps/models/DistritModel.dart';
import 'package:wwf_apps/models/ProvinceModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/sectors/workers/tab_widgets/first_tab_widget.dart';
import 'package:wwf_apps/screens/sectors/workers/tab_widgets/second_tab_widget.dart';
import 'package:wwf_apps/screens/sectors/workers/tab_widgets/third_tab_widget.dart';
import 'package:wwf_apps/screens/sectors/employee/tab_widgets/first_tab_widget.dart';
import 'package:wwf_apps/screens/sectors/employee/tab_widgets/second_tab_widget.dart';
import 'package:wwf_apps/screens/sectors/employee/tab_widgets/third_tab_widget.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class EmployeeForm extends StatefulWidget {
  int selectedTab= 0;

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {

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
}

