import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';

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
                      child: Text("Claims",
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
