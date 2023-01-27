import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_beneficiary.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_child.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_child_education.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_self_education.dart';

class InformationSelection extends StatefulWidget {
  @override
  _InformationSelectionState createState() => _InformationSelectionState();
}

class _InformationSelectionState extends State<InformationSelection> {
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
                      child: Text("Information",
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

            Expanded(child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddSelfEducation()
                        ));
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image.asset("assets/images/education.png",
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              color: AppTheme.colors.newPrimary,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text("Add Self Education",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 13,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 1,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddChild()
                        ));
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image.asset("assets/images/childrens.png",
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              color: AppTheme.colors.newPrimary,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text("Add Children",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 13,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 1,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddChildEducation()
                        ));
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image.asset("assets/images/child_education.png",
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              color: AppTheme.colors.newPrimary,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text("Add Children Education",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 13,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 1,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddBeneficiary()
                        ));
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image.asset("assets/images/beneficiary.png",
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              color: AppTheme.colors.newPrimary,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text("Add Beneficiary",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 13,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 1,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
