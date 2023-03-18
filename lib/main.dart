import 'dart:io';
// Testing...
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/screens/general/splash_screen.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'colors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
