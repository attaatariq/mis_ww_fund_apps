import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/screens/sectors/employer/tab_widgets/first_tab_widget.dart';
import 'package:wwf_apps/screens/sectors/employer/tab_widgets/second_tab_widget.dart';

class CompanyForm extends StatefulWidget {
  int selectedTab= 0;


  @override
  _CompanyFormState createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {

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
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    widget.selectedTab == 0 ? EmployerFirstTab(parentFunction) : widget.selectedTab == 1 ? EmployerSecondTab(parentFunction) :
                    widget.selectedTab == 3 ? EmployerFirstTab(parentFunction) : EmployerSecondTab(parentFunction)
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

