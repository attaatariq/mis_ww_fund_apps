import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/widgets/standard_header.dart';

class EducationClaimTypes extends StatefulWidget {
  @override
  _EducationClaimTypesState createState() => _EducationClaimTypesState();
}

class _EducationClaimTypesState extends State<EducationClaimTypes> {
  bool isAnySelect= false;

  @override
  Widget build(BuildContext context) {
    isAnySelect= true;
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Claims",
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.newPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text("Education Claim",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 14,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.colorDarkGray,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      height: 40,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.newPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text("Fee Claim",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 14,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.colorDarkGray,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    isAnySelect ? Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 20),
                            child: Text("Select Claim Type",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 14,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                            height: 40,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newPrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text("Education Claim",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: AppTheme.colors.newBlack,
                                          fontSize: 14,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 1,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.colorDarkGray,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                            height: 40,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.newPrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text("Fee Claim",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: AppTheme.colors.newBlack,
                                          fontSize: 14,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 1,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.colorDarkGray,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
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
