import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/screens/general/complaints.dart';
import 'package:welfare_claims_app/screens/general/faqs.dart';
import 'package:welfare_claims_app/screens/general/notifications_alerts.dart';
import 'package:welfare_claims_app/screens/general/send_feedback.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/contact_person.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/death_claim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/employee_verification.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/marriage_claim_list.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

import '../AddContactPerson.dart';
import '../AddDEO.dart';
import '../annex3A.dart';
import '../annexA.dart';
import '../deo_detail.dart';
import '../interst_distribution_list.dart';
import '../wpf_distribution_list.dart';

class EmployerDrawerView extends StatefulWidget {
  @override
  _EmployerDrawerViewState createState() => _EmployerDrawerViewState();
}

class _EmployerDrawerViewState extends State<EmployerDrawerView> {
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
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DeoDetail()
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
                                        "assets/images/deo.png"),
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
                                    "Data Entry Operator",
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
                          builder: (context) => ContactPerson()
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
                                        "assets/images/conact_person.png"),
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
                                    "Contact Person",
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
                          builder: (context) => EmployeeVerification()
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
                                        "assets/images/verified.png"),
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
                                    "Workers Verification",
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
                                    height: 20.0,
                                    width: 20.0,
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

                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right: 15, top: 20),
                    child: Text(
                      "Contribute Us",
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
                          builder: (context) => WpfDistributionList()
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
                                        "assets/images/annexure.png"),
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
                                    "WPF Distribution Sheet",
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
                          builder: (context) => InterstDistributionList()
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
                                        "assets/images/annexure.png"),
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
                                    "Interest Distribution Sheet",
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
                          builder: (context) => AddContactPerson()
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
                                        "assets/images/company.png"),
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
                                    "Company Detail",
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
                          builder: (context) => AddContactPerson()
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
                          builder: (context) => AddContactPerson()
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
