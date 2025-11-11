import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

TextEditingController emailController = TextEditingController();

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  Constants constants;
  UIUpdates uiUpdates;
  bool _isLoading = false;
  AnimationController _animationController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
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
    _animationController?.dispose();
    super.dispose();
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

                  // Reset Password Form Section
                  _buildResetPasswordFormSection(),
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
      height: 280,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with professional styling
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
                  child: Icon(
                    Icons.lock_reset,
                    size: 50,
                    color: AppTheme.colors.newWhite,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Forgot Password?",
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 28,
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
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Enter your email address and we'll send you a link to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.colors.newWhite.withOpacity(0.9),
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.3,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetPasswordFormSection() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Input Field
          Container(
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
              controller: emailController,
              cursorColor: AppTheme.colors.newPrimary,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.colors.newBlack,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Email Address",
                hintStyle: TextStyle(
                  fontFamily: "AppFont",
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
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
          ),

          SizedBox(height: 40),

          // Reset Password Button
          _buildResetButton(),

          SizedBox(height: 24),

          // Back to Login Link
          _buildBackToLoginLink(),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return Material(
      elevation: 8,
      shadowColor: AppTheme.colors.newPrimary.withOpacity(0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : () => Validation(),
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        color: AppTheme.colors.newWhite,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Reset Password",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 16,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_back_ios,
          size: 14,
          color: AppTheme.colors.colorDarkGray,
        ),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Back to Login",
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
      ],
    );
  }

  void Validation() {
    // Validate Email is not empty
    if (emailController.text.trim().isEmpty) {
      uiUpdates.ShowToast(Strings.instance.emailMessage);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Validate Email format
    if (!constants.IsValidEmail(emailController.text.trim())) {
      uiUpdates.ShowToast(Strings.instance.invalidEmailMessage);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // All validations passed
    setState(() {
      _isLoading = true;
    });
    CheckConnectivity();
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
          if (value) {
            ResetPassword()
          } else {
            uiUpdates.ShowToast(Strings.instance.internetNotConnected),
            setState(() {
              _isLoading = false;
            })
          }
        });
  }

  ResetPassword() async {
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    Map data = {
      "email": emailController.text.toString(),
    };
    var url = constants.getApiBaseURL() + constants.authentication + "forgot";
    var response = await http.post(Uri.parse(url),
        body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel =
        constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode != 500) {
      if (responseCodeModel.status == true) {
        var body = jsonDecode(response.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.resetPasswordSuccess);
          Navigator.pop(context);
        } else {
          uiUpdates.ShowToast(Strings.instance.resetPasswordFailed);
        }
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      var body = jsonDecode(response.body);
      String data = body["Data"].toString();
      uiUpdates.ShowToast(data);
    }
  }
}
