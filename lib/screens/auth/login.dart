import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/controllers/auth/login.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/sectors/employer/CompanyForm.dart';
import 'package:wwf_apps/screens/sectors/employee/EmployeeForm.dart';
import 'package:wwf_apps/screens/auth/forgot.dart';
import 'package:wwf_apps/screens/auth/signup.dart';
import 'package:wwf_apps/screens/home/employee/employee_home.dart';
import 'package:wwf_apps/screens/home/employer/employer_home.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  LoginController loginController = Get.put(LoginController());
  bool _obscurePassword = true;
  bool _isLoading = false;
  var cnicMask = new MaskTextInputFormatter(mask: '#####-#######-#');
  String ipAddress = "000.000.0.000",
      deviceModel = "Not Available",
      platform = "";
  UIUpdates uiUpdates;
  Constants constants;
  AnimationController _animationController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();

    // Check for app updates
    constants.CheckForNewUpdate(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Enhanced Header Section
                  _buildHeaderSection(),

                  // Login Form Section
                  _buildLoginFormSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.colors.newPrimary,
            Color.lerp(AppTheme.colors.newPrimary, Colors.black, 0.1),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with professional styling
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.colors.newWhite.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.colors.newWhite.withOpacity(0.15),
                    border: Border.all(
                      color: AppTheme.colors.newWhite.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "archive/images/logo.png",
                      width: 75,
                      height: 75,
                      color: AppTheme.colors.newWhite,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: AppTheme.colors.newWhite,
                  fontSize: 26,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Sign in to continue",
                style: TextStyle(
                  color: AppTheme.colors.newWhite.withOpacity(0.9),
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginFormSection() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CNIC Input Field
          _buildInputField(
            icon: Icons.badge_outlined,
            hintText: "CNIC Number",
            controller: loginController.cnicController,
            focusNode: loginController.cnicNode,
            inputFormatters: [cnicMask],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 24),

          // Password Input Field
          _buildPasswordField(),

          SizedBox(height: 16),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                );
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: AppTheme.colors.newPrimary,
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.colors.newPrimary,
                ),
              ),
            ),
          ),

          SizedBox(height: 40),

          // Login Button
          _buildLoginButton(),

          SizedBox(height: 32),

          // Sign Up Link
          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    IconData icon,
    String hintText,
    TextEditingController controller,
    FocusNode focusNode,
    List<TextInputFormatter> inputFormatters = const [],
    TextInputType keyboardType,
    TextInputAction textInputAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        cursorColor: AppTheme.colors.newPrimary,
        style: TextStyle(
          fontSize: 15,
          color: AppTheme.colors.newBlack,
          fontFamily: "AppFont",
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: "AppFont",
            color: AppTheme.colors.colorDarkGray,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: AppTheme.colors.newPrimary,
            size: 22,
          ),
          filled: true,
          fillColor: AppTheme.colors.newWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.colors.colorLightGray,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.colors.colorLightGray,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.colors.newPrimary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: loginController.passwordController,
        cursorColor: AppTheme.colors.newPrimary,
        keyboardType: TextInputType.text,
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontSize: 15,
          color: AppTheme.colors.newBlack,
          fontFamily: "AppFont",
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(
            fontFamily: "AppFont",
            color: AppTheme.colors.colorDarkGray,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: AppTheme.colors.newPrimary,
            size: 22,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppTheme.colors.colorDarkGray,
              size: 22,
            ),
          ),
          filled: true,
          fillColor: AppTheme.colors.newWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.colors.colorLightGray,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.colors.colorLightGray,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.colors.newPrimary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      elevation: 8,
      shadowColor: AppTheme.colors.newPrimary.withOpacity(0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : () => _handleLogin(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.colors.newPrimary,
                Color.lerp(AppTheme.colors.newPrimary, Colors.black, 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isLoading
                ? null
                : [
                    BoxShadow(
                      color: AppTheme.colors.newPrimary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.colors.newWhite,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    "Login",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 16,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: 14,
            fontFamily: "AppFont",
            fontWeight: FontWeight.normal,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: AppTheme.colors.newPrimary,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.colors.newPrimary,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    // Hide keyboard first
    uiUpdates.HideKeyBoard();
    
    // Validate first before showing any dialogs
    if (!_validateForm()) {
      return; // Validation failed, error already shown
    }

    // All validations passed, proceed with login
    setState(() {
      _isLoading = true;
    });
    GetIPAddress();
  }

  bool _validateForm() {
    // Validate CNIC
    if (loginController.cnicController.text.trim().isEmpty) {
      uiUpdates.ShowToast(Strings.instance.cnicMessage);
      return false;
    }

    // Validate CNIC length
    if (loginController.cnicController.text.toString().length != 15) {
      uiUpdates.ShowToast(Strings.instance.invalidCNICMessage);
      return false;
    }

    // Validate Password
    if (loginController.passwordController.text.trim().isEmpty) {
      uiUpdates.ShowToast(Strings.instance.passwordMessage);
      return false;
    }

    // Validate Password length (4-20 characters)
    String password = loginController.passwordController.text.trim();
    if (password.length < 4 || password.length > 20) {
      uiUpdates.ShowToast(Strings.instance.invalidPasswordLengthMessage);
      return false;
    }

    // All validations passed
    return true;
  }

  void Validation() {
    // This method is called after getting device info
    // Re-validate to ensure data is still valid
    if (!_validateForm()) {
      uiUpdates.DismissProgresssDialog();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // All validations passed, proceed with connectivity check
    CheckConnectivity();
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) {
      if (value) {
        loginController.loginData(
            ipAddress: ipAddress,
            platform: platform,
            deviceModel: deviceModel,
            context: context,
            uiUpdates: uiUpdates,
            onComplete: (success) {
              setState(() {
                _isLoading = false;
              });
            });
      } else {
        uiUpdates.DismissProgresssDialog();
        uiUpdates.ShowToast(Strings.instance.internetNotConnected);
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      setState(() {
        _isLoading = false;
      });
    });
  }

  GetIPAddress() {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.GetIPAddress(context).then((value) {
      if (value != null) {
        ipAddress = value;
        GetDeviceinfo();
      } else {
        uiUpdates.DismissProgresssDialog();
        uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      setState(() {
        _isLoading = false;
      });
    });
  }

  GetDeviceinfo() {
    constants.GetDeviceInfo(context).then((value) {
      if (value != null) {
        deviceModel = value;
        GetPalform();
      } else {
        uiUpdates.DismissProgresssDialog();
        uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      setState(() {
        _isLoading = false;
      });
    });
  }

  GetPalform() {
    constants.GetPlatForm(context).then((value) {
      if (value != null) {
        platform = value;
        Validation();
      } else {
        uiUpdates.DismissProgresssDialog();
        uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      setState(() {
        _isLoading = false;
      });
    });
  }
}
