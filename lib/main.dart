import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/screens/general/splash_screen.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'colors/app_colors.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();

  ///set instance of user sessions
  await Firebase.initializeApp();
  await UserSessions.instance.init();
  await Strings.instance.init();

  runApp(MaterialApp(
    theme: new ThemeData(
        primaryColor: AppTheme.colors.newPrimary,
        accentColor: AppTheme.colors.colorAccent,
        primaryColorDark: AppTheme.colors.newPrimary,
        unselectedWidgetColor: AppTheme.colors.white),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
