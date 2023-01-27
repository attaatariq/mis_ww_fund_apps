import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';

class EmployerSecondTab extends StatefulWidget {

  final parentFunction;

  EmployerSecondTab(this.parentFunction);

  @override
  _EmployerSecondTabState createState() => _EmployerSecondTabState();
}

class _EmployerSecondTabState extends State<EmployerSecondTab> {
  String selectedCompanyName= "Select Company", selectedDate="Select Date of Birth", selectedCNICIssueDate= "CNIC Issue Date",
      selectedCNICExpiryDate= "CNIC Expiry Date", selectedDisability= "Select Disability", selectedCity= "Select City",
      selectedProvince= "Select Porvince";
  String selectedCompanyID= "";
  bool isDisable= false;

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
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Person Name",
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
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Person Code",
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
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Designation",
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
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
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
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
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
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
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
              margin: EdgeInsets.only(top: 30, bottom: 60),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        widget.parentFunction(3);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                        ),
                        child: Center(
                          child: Text("Back",
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
                  ),

                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        widget.parentFunction(2);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 45,
                        color: AppTheme.colors.newPrimary,
                        child: Center(
                          child: Text("Next",
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
