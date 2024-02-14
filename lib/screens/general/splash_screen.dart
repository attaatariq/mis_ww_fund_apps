import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_version/new_version.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employer/CompanyInformationFrom.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/wwf_employee/WWFEmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/authentication/login.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/employee_home.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/employer_home.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'FFW', // id
    'FFW Notifications', // title
    //'This channel is used for WWF notifications.', // description
    importance: Importance.high,
    playSound: true);
Constants constants= new Constants();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.toString()}');
  constants.ShowNotification(message);
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]); ///hide bottom navigation
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(  // setting navigation and status bar
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark
    ));

    ///Notification Code start
    FirebaseNotificationInit();
    FirebaseNotificationListener();
    ///// Notification Code end here

    StartTimer();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    print("Notification Clicked");
  }

  StartTimer() async{
    var duration= Duration(seconds: 5);
    return Timer(duration, routes);
  }

  routes() {
    CheckLogedInUser();
  }

  void CheckLogedInUser() {
    if(UserSessions.instance.getUserID != "")
    {
      SetScreen();
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginScreen()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      height: 120.0,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset("assets/images/logo.png",
                          height: 120.0,
                          width: 120,
                          color: AppTheme.colors.newWhite,
                        ),
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
              margin: EdgeInsets.only(bottom: 15),
              height: 20,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Copyright ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal
                    ),
                  ),

                  Icon(Icons.copyright, color: AppTheme.colors.newWhite, size: 8,),

                  Text(" 2021 Workers Welfare Fund (WWF)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void SetScreen() {
    print(UserSessions.instance.getUserID+" : "+UserSessions.instance.getToken+" : "+UserSessions.instance.getRefID);
    if((UserSessions.instance.getUserSector == "7" && UserSessions.instance.getUserRole == "6")
    || (UserSessions.instance.getUserSector == "4" && UserSessions.instance.getUserRole == "3")
    ){ // wwf employee
      if(UserSessions.instance.getUserAccount == "1" || UserSessions.instance.getRefID != "null"){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeHome(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => WWFEmployeeInformationForm(),
          ),
              (route) => false,
        );
      }
    }else if(UserSessions.instance.getUserSector == "8" && UserSessions.instance.getUserRole == "9"){ // company worker
      if(UserSessions.instance.getUserAccount == "1"|| UserSessions.instance.getRefID != "null"){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeHome(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeInformationForm(),
          ),
              (route) => false,
        );
      }
    }else if(UserSessions.instance.getUserSector == "8" && UserSessions.instance.getUserRole == "7"){ //CEO company
      if(UserSessions.instance.getUserAccount == "1"|| UserSessions.instance.getRefID != "null"){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployerHome(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => CompanyInformationForm(),
          ),
              (route) => false,
        );
      }
    }else if(UserSessions.instance.getUserSector == "8" && UserSessions.instance.getUserRole == "8"){ //DEO company
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => EmployerHome(),
        ),
            (route) => false,
      );
    }else if(UserSessions.instance.getUserSector == "9" && UserSessions.instance.getUserRole == "10"){ //Manager fee school

    }
  }

  Future<Void> FirebaseNotificationInit() async{
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void FirebaseNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Handling a On message '+message.data.toString());
      Map<String, dynamic> data= message.data;
      constants.ShowNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Handling a Open App message ${message.toString()}');
      constants.ShowNotification(message);
    });
  }
}
