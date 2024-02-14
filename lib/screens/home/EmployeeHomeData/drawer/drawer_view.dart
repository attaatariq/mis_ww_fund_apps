import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/screens/general/change_password.dart';
import 'package:welfare_claims_app/screens/general/complaints.dart';
import 'package:welfare_claims_app/screens/general/faqs.dart';
import 'package:welfare_claims_app/screens/general/my_profile.dart';
import 'package:welfare_claims_app/screens/general/notifications_alerts.dart';
import 'package:welfare_claims_app/screens/general/send_feedback.dart';
import 'package:welfare_claims_app/screens/general/turn_over_history.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_beneficiary.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_child.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_child_education.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_self_education.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/beneficiary_detail.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/childrens_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/death_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/death_claim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/education_claim_types.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/employee_turnover.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/estate_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/hajj_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/hajj_claim_detail.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/marriage_calim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/marriage_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/education_claim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/self_education_list.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EmployeeDrawerView extends StatefulWidget {
  @override
  _EmployeeDrawerViewState createState() => _EmployeeDrawerViewState();
}

class _EmployeeDrawerViewState extends State<EmployeeDrawerView> {
  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colors.white,
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.colors.newPrimary,
                    AppTheme.colors.colorD4,
                  ],
                )
            ),
            child: Align(
                alignment: Alignment.bottomLeft,
                child:  Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: UserSessions.instance.getUserImage != "null" && UserSessions.instance.getUserImage != "" && UserSessions.instance.getUserImage != "NULL" && UserSessions.instance.getUserImage != "N/A" ? FadeInImage(
                                image: NetworkImage(constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                                placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                fit: BoxFit.fill,
                              ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                height: 60.0,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Text(
                            UserSessions.instance.getUserName,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 14,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 2),
                          child: Text(
                            UserSessions.instance.getUserCNIC,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 10,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),

                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 0.5,
                            color: AppTheme.colors.colorDarkGray,
                            width: double.infinity,
                          )
                      ),
                    ],
                  ),
                )
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right: 15, top: 15),
                    child: Text(
                      "Claims",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EducationClaimList()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/educational.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Educational Claim",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 13,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MarriageClaimList()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/merriage.png"),
                                    alignment: Alignment.center,
                                    height: 16.0,
                                    width: 16.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Marriage Claim",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DeathClaimList()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/death.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Death Claim",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EstateClaim()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/estate_claim.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Estate Claim",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HajjClaim()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/hajj_icon.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Hajj Claim",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right: 15, top: 20),
                    child: Text(
                      "Information",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SelfEducationList()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/education.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Self Education",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ChildrenList()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/childrens.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Children's",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddChildEducation()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/child_education.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Add Children Education",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BeneficiaryDetail()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/beneficiary.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Beneficiary",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EmployeeTurnOver()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/employee_turnover.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Turn-Over",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TurnOverHistory()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/turn_over_history.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Turn-Over History",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NotificationsAndAlerts()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/bell.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Notifications",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right: 15, top: 20),
                    child: Text(
                      "Settings",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyProfile()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/profile.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "My Profile",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ChangePassword()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/key.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Change Password",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right: 15, top: 20),
                    child: Text(
                      "Preferences",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Complaints()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/complaint.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Complaints",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SendFeedback()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/feedback.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Send Feedback",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FAQs()
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 45,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/faqs.png"),
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    width: 20.0,
                                    color: AppTheme.colors.newBlack,
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "FAQs",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
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
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 0.5,
                    width: double.infinity,
                    color: AppTheme.colors.colorDarkGray,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
