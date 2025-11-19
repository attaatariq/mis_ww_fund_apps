import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/sectors/employer/CompanyForm.dart';
import 'package:wwf_apps/screens/sectors/employee/EmployeeForm.dart';
import 'package:wwf_apps/screens/auth/login.dart';
import 'package:wwf_apps/screens/home/employee/employee_home.dart';
import 'package:wwf_apps/screens/home/employer/employer_home.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'FFW', // id
    'FFW Notifications', // title
    importance: Importance.high,
    playSound: true);
Constants constants = new Constants();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  constants.ShowNotification(message);
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _fadeAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configure system UI
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Start animations
    _animationController.forward();

    // Initialize Firebase notifications
    FirebaseNotificationInit();
    FirebaseNotificationListener();

    // Start navigation timer
    StartTimer();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
    }
  }

  StartTimer() async {
    // 3.5 seconds provides good balance - enough time for initialization
    // and smooth animations, but not too long to frustrate users
    var duration = const Duration(milliseconds: 3500);
    return Timer(duration, routes);
  }

  routes() {
    CheckLogedInUser();
  }

  void CheckLogedInUser() {
    if (UserSessions.instance.getUserID != "") {
      SetScreen();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.colors.newPrimary;
    final backgroundColor = isDarkMode
        ? const Color(0xFF1A1A1A)
        : primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        backgroundColor,
                        backgroundColor.withOpacity(0.85),
                      ]
                    : [
                        primaryColor,
                        Color.lerp(primaryColor, Colors.black, 0.1),
                      ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Subtle decorative background pattern
                  _buildBackgroundPattern(),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Professional logo container with badge effect
                        AnimatedOpacity(
                          opacity: _fadeAnimation.value,
                          duration: const Duration(milliseconds: 800),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.colors.newWhite.withOpacity(0.15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                    offset: Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: AppTheme.colors.newWhite.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.colors.newWhite.withOpacity(0.1),
                                  border: Border.all(
                                    color: AppTheme.colors.newWhite.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "archive/images/logo.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    color: AppTheme.colors.newWhite,
                                    colorBlendMode: BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Spacing
                        SizedBox(height: 40),

                        // Main title with professional styling
                        AnimatedOpacity(
                          opacity: _fadeAnimation.value,
                          duration: const Duration(milliseconds: 1000),
                          child: Column(
                            children: [
                              Text(
                                "Workers Welfare Fund",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 26,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: 60,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.newWhite.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Subtitle with government branding
                        AnimatedOpacity(
                          opacity: _fadeAnimation.value * 0.9,
                          duration: const Duration(milliseconds: 1200),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 24, right: 24),
                            child: Column(
                              children: [
                                Text(
                                  "Management Information System",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.colors.newWhite.withOpacity(0.95),
                                    fontSize: 15,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Government of Pakistan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.colors.newWhite.withOpacity(0.75),
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.3,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Professional loading indicator
                  Positioned(
                    bottom: 140,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: _fadeAnimation.value * 0.7,
                      duration: const Duration(milliseconds: 1500),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.colors.newWhite.withOpacity(0.8),
                              ),
                              strokeWidth: 3.0,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite.withOpacity(0.7),
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Professional copyright footer
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: _fadeAnimation.value * 0.75,
                      duration: const Duration(milliseconds: 1800),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 28.0, top: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.copyright,
                                  color: AppTheme.colors.newWhite.withOpacity(0.75),
                                  size: 13,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "2024 Workers Welfare Fund",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.colors.newWhite.withOpacity(0.75),
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Ministry of Overseas Pakistanis & Human Resource Development",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.colors.newWhite.withOpacity(0.6),
                                fontSize: 10,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Subtle background pattern for professional look
  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _BackgroundPatternPainter(
          opacity: _fadeAnimation.value * 0.1,
        ),
      ),
    );
  }

  void SetScreen() {
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
            builder: (BuildContext context) => EmployeeForm(),
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
            builder: (BuildContext context) => WorkerForm(),
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
            builder: (BuildContext context) => CompanyForm(),
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

  Future FirebaseNotificationInit() async{
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
      Map<String, dynamic> data= message.data;
      constants.ShowNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      constants.ShowNotification(message);
    });
  }
}

// Custom painter for subtle background pattern
class _BackgroundPatternPainter extends CustomPainter {
  final double opacity;

  _BackgroundPatternPainter({this.opacity = 0.1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw subtle geometric pattern
    final spacing = 60.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw subtle circles at intersections
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.5)
      ..style = PaintingStyle.fill;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_BackgroundPatternPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}
