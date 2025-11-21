import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/screens/home/employee/add_beneficiary.dart';
import 'package:wwf_apps/screens/home/employee/add_child.dart';
import 'package:wwf_apps/screens/home/employee/add_child_education.dart';
import 'package:wwf_apps/screens/home/employee/add_self_education.dart';

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
            StandardHeader(
              title: "Information",
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
                            Image.asset("archive/images/card.png",
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
                            Image.asset("archive/images/childrens.png",
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
                            Image.asset("archive/images/user_book.png",
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
                            Image.asset("archive/images/beneficiary.png",
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
