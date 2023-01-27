import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/screens/general/edit_my_profile.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Text("Profile",
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
                              builder: (context) => EditProfile()
                          )).then((value) => {
                            setState(() {})
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.edit, color: AppTheme.colors.newWhite, size: 20,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 230,
                width: double.infinity,
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

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: UserSessions.instance.getUserImage != "null" ? FadeInImage(
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

                    SizedBox(height: 10,),

                    Text(
                      UserSessions.instance.getUserName,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 16,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold),
                    ),

                    Text(
                      UserSessions.instance.getUserEmail,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      UserSessions.instance.getUserCNIC,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
                child: Text(
                  "About",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
                child: Text(
                  UserSessions.instance.getUserAbout,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
                child: Text(
                  "Account Info",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.colors.newPrimary,
                              AppTheme.colors.colorD4,
                            ],
                          ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/profile_ic.png",
                          height: 20.0,
                          width: 20,
                          color: AppTheme.colors.newWhite,
                        ),
                      ),
                    ),

                    SizedBox(width: 15,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(
                          UserSessions.instance.getUserName,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.colors.newPrimary,
                            AppTheme.colors.colorD4,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/phone_ic.png",
                          height: 20.0,
                          width: 20,
                          color: AppTheme.colors.newWhite,
                        ),
                      ),
                    ),

                    SizedBox(width: 15,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Number",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(
                          UserSessions.instance.getUserNumber,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.colors.newPrimary,
                            AppTheme.colors.colorD4,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/email_ic.png",
                          height: 20.0,
                          width: 20,
                          color: AppTheme.colors.newWhite,
                        ),
                      ),
                    ),

                    SizedBox(width: 15,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(
                          UserSessions.instance.getUserEmail,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.colors.newPrimary,
                            AppTheme.colors.colorD4,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/cnic_ic.png",
                          height: 20.0,
                          width: 20,
                          color: AppTheme.colors.newWhite,
                        ),
                      ),
                    ),

                    SizedBox(width: 15,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CNIC",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
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
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
