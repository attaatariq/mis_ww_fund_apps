import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/annex3A.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/annexA.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class Contribution extends StatefulWidget {
  @override
  _ContributionState createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.appBlackColors,
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
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.white, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Contribute Us",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.white,
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
                        OpenAnnexA();
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text("Add Annex-A",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.white,
                                    fontSize: 13,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),

                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: AppTheme.colors.colorDarkGray,)
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
                        OpenAnnex3A();
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text("Add Annex-3A",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.colors.white,
                                    fontSize: 13,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),

                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: AppTheme.colors.colorDarkGray,)
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

  void OpenAnnexA() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AnnexA()
    ));
  }

  void OpenAnnex3A() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Annex3A()
    ));
  }
}
