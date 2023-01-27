import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/hajj_claim.dart';
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';

class HajjClaimsDetail extends StatefulWidget {
  @override
  _HajjClaimsDetailState createState() => _HajjClaimsDetailState();
}

class _HajjClaimsDetailState extends State<HajjClaimsDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          child: Text("Hajj Claims",
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

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HajjClaim()
                        )).then((value) => {
                          setState(() {})
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.add_box_outlined, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 50),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: UserSessions.instance.getUserImage != "null" && UserSessions.instance.getUserImage != "" && UserSessions.instance.getUserImage != "NULL" ? FadeInImage(
                                  image: NetworkImage(constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                                  placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                  fit: BoxFit.fill,
                                ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                  height: 40.0,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),

                            SizedBox(width: 10,),

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        UserSessions.instance.getUserName,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.newBlack,
                                            fontSize: 13,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      Text(
                                        UserSessions.instance.getUserCNIC,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 10,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 28,
                                    width: 70,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppTheme.colors.colorExelent
                                    ),

                                    child: Center(
                                      child: Text(
                                        "-",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: AppTheme.colors.newWhite,
                                            fontSize: 10,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.bold
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

                      SizedBox(height: 10,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Claim Detail",
                              textAlign: TextAlign.start,
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

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text("-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Submitted Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text("-",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Year",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text("-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        GetHajjClaims();
      }
    });
  }

  void GetHajjClaims() {

  }
}
