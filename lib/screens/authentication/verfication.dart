import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/SignUpDataModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Verification extends StatefulWidget {
  SignupDataModel signupDataModel;

  Verification(this.signupDataModel);

  @override
  _VerificationState createState() => _VerificationState();
}

TextEditingController emailCodeController = TextEditingController();
TextEditingController otpCodeController = TextEditingController();

class _VerificationState extends State<Verification>
    with SingleTickerProviderStateMixin {
  var verificationMarsk = new MaskTextInputFormatter(mask: '######');
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

                  // Verification Form Section
                  _buildVerificationFormSection(),
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
                    Icons.verified_user,
                    size: 50,
                    color: AppTheme.colors.newWhite,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Verify Your Account",
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
                "Enter the verification codes sent to your email and phone number",
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

  Widget _buildVerificationFormSection() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Verification Code Field
          _buildCodeInputField(
            icon: Icons.email_outlined,
            hintText: "Email Verification Code",
            controller: emailCodeController,
            inputFormatters: [verificationMarsk],
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 24),

          // Phone Verification Code Field
          _buildCodeInputField(
            icon: Icons.phone_android,
            hintText: "Phone Verification Code (OTP)",
            controller: otpCodeController,
            inputFormatters: [verificationMarsk],
            textInputAction: TextInputAction.done,
          ),

          SizedBox(height: 40),

          // Sign Up Button
          _buildSignUpButton(),

          SizedBox(height: 24),

          // Info Text
          _buildInfoText(),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCodeInputField({
    IconData icon,
    String hintText,
    TextEditingController controller,
    List<TextInputFormatter> inputFormatters = const [],
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
        inputFormatters: inputFormatters,
        cursorColor: AppTheme.colors.newPrimary,
        keyboardType: TextInputType.number,
        textInputAction: textInputAction,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: AppTheme.colors.newBlack,
          fontFamily: "AppFont",
          fontWeight: FontWeight.w700,
          letterSpacing: 4,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: "AppFont",
            color: AppTheme.colors.colorDarkGray,
            fontSize: 14,
            letterSpacing: 0,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
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
                        Icons.check_circle_outline,
                        color: AppTheme.colors.newWhite,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Verify & Sign Up",
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

  Widget _buildInfoText() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.colors.newPrimary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.colors.newPrimary,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Check your email inbox and SMS for the 6-digit verification codes",
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Validation() {
    if (emailCodeController.text.isNotEmpty) {
      if (emailCodeController.text.toString().length == 6) {
        if (otpCodeController.text.isNotEmpty) {
          if (otpCodeController.text.toString().length == 6) {
            if (widget.signupDataModel.emailVerificationCode ==
                emailCodeController.text.toString()) {
              if (widget.signupDataModel.numberVerificationCode ==
                  otpCodeController.text.toString()) {
                setState(() {
                  _isLoading = true;
                });
                SignupUser();
              } else {
                uiUpdates.ShowToast(Strings.instance.invalidNumberVerificationCode);
                setState(() {
                  _isLoading = false;
                });
              }
            } else {
              uiUpdates.ShowToast(Strings.instance.invalidEmailVerificationCode);
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            uiUpdates.ShowToast(Strings.instance.invalidNumberVerificationCode);
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          uiUpdates.ShowToast(Strings.instance.missingNumberVerificationCode);
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        uiUpdates.ShowToast(Strings.instance.invalidEmailVerificationCode);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      uiUpdates.ShowToast(Strings.instance.missingEmailVerificationCode);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void SignupUser() async {
    uiUpdates.HideKeyBoard();
    Map data = {
      "name": widget.signupDataModel.name,
      "cnic": widget.signupDataModel.cnic,
      "email": widget.signupDataModel.email,
      "contact": widget.signupDataModel.contact,
      "gender": widget.signupDataModel.gender,
      "sector": widget.signupDataModel.sector,
      "password": widget.signupDataModel.password,
      "confirm": widget.signupDataModel.password
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.authentication + "signup";
    var response = await http.post(Uri.parse(url),
        body: data, encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel =
        constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    setState(() {
      _isLoading = false;
    });
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      String message = body["Message"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(message);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        uiUpdates.ShowToast(message);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
}
