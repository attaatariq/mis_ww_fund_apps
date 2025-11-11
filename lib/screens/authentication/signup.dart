import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/dialogs/sector_category_dialog_model.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/SignUpDataModel.dart';
import 'package:welfare_claims_app/screens/authentication/verfication.dart';
import 'package:welfare_claims_app/screens/general/location_picker.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

FocusNode cnicNode = FocusNode();
FocusNode numberNode = FocusNode();
TextEditingController cnicController = TextEditingController();
TextEditingController numberController = TextEditingController();
TextEditingController fullNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  var cnicMask = new MaskTextInputFormatter(mask: '#####-#######-#');
  var numberMask = new MaskTextInputFormatter(mask: '###########');
  String selectedSectorCategory = "";
  String selectedSectorID = "", selectedGender = "";
  Constants constants;
  UIUpdates uiUpdates;
  int _radioValue = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  AnimationController _animationController;
  Animation<double> _fadeAnimation;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          selectedGender = "Male";
          break;
        case 1:
          selectedGender = "Female";
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedSectorCategory = "Please Select Registration Type";
    selectedGender = "Male";
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

                  // Registration Form Section
                  _buildRegistrationFormSection(),
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
      height: 240,
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
            // Logo
            Container(
              width: 110,
              height: 110,
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
                margin: EdgeInsets.all(6),
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
                    "assets/images/logo.png",
                    width: 70,
                    height: 70,
                    color: AppTheme.colors.newWhite,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Create Account",
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
              "Register to get started",
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
    );
  }

  Widget _buildRegistrationFormSection() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Registration Type Selector
          _buildRegistrationTypeSelector(),

          SizedBox(height: 20),

          // Full Name Field
          _buildInputField(
            icon: Icons.person_outline,
            hintText: "Full Name",
            controller: fullNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 20),

          // Email Field
          _buildInputField(
            icon: Icons.email_outlined,
            hintText: "Email Address",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 20),

          // Contact Number Field
          _buildInputField(
            icon: Icons.phone_android,
            hintText: "Contact Number",
            controller: numberController,
            focusNode: numberNode,
            inputFormatters: [numberMask],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 20),

          // CNIC Field
          _buildInputField(
            icon: Icons.badge_outlined,
            hintText: "CNIC Number",
            controller: cnicController,
            focusNode: cnicNode,
            inputFormatters: [cnicMask],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 20),

          // Password Field
          _buildPasswordField(
            controller: passwordController,
            hintText: "Password",
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),

          SizedBox(height: 20),

          // Confirm Password Field
          _buildPasswordField(
            controller: confirmPasswordController,
            hintText: "Confirm Password",
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),

          SizedBox(height: 24),

          // Gender Selection
          _buildGenderSelector(),

          SizedBox(height: 32),

          // Next Button
          _buildNextButton(),

          SizedBox(height: 24),

          // Login Link
          _buildLoginLink(),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRegistrationTypeSelector() {
    final isSelected = selectedSectorCategory != "Please Select Registration Type";
    
    return GestureDetector(
      onTap: () {
        OpenSectorCategoryDialog(context).then((value) {
          HandelSeledSector(value);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.colors.newWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.colors.newPrimary
                : AppTheme.colors.colorLightGray,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.business_center_outlined,
                color: AppTheme.colors.newPrimary,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedSectorCategory,
                  style: TextStyle(
                    color: isSelected
                        ? AppTheme.colors.newBlack
                        : AppTheme.colors.colorDarkGray,
                    fontSize: 15,
                    fontFamily: "AppFont",
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.colors.newPrimary,
                size: 24,
              ),
            ],
          ),
        ),
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

  Widget _buildPasswordField({
    TextEditingController controller,
    String hintText,
    bool obscureText,
    Function onToggleVisibility,
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
        cursorColor: AppTheme.colors.newPrimary,
        keyboardType: TextInputType.text,
        obscureText: obscureText,
        textInputAction: TextInputAction.next,
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
            Icons.lock_outline,
            color: AppTheme.colors.newPrimary,
            size: 22,
          ),
          suffixIcon: GestureDetector(
            onTap: onToggleVisibility,
            child: Icon(
              obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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

  Widget _buildGenderSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorLightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.colors.colorLightGray,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  value: 0,
                  label: "Male",
                  icon: Icons.male,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildGenderOption(
                  value: 1,
                  label: "Female",
                  icon: Icons.female,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption({int value, String label, IconData icon}) {
    final isSelected = _radioValue == value;
    return GestureDetector(
      onTap: () => _handleRadioValueChange(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.colors.newPrimary.withOpacity(0.1)
              : AppTheme.colors.newWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppTheme.colors.newPrimary
                : AppTheme.colors.colorLightGray,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.colors.newPrimary
                  : AppTheme.colors.colorDarkGray,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.colors.newPrimary
                    : AppTheme.colors.newBlack,
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
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
                      Text(
                        "Next",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 16,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppTheme.colors.newWhite,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: AppTheme.colors.colorDarkGray,
            fontSize: 14,
            fontFamily: "AppFont",
            fontWeight: FontWeight.normal,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Login",
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

  Future<String> OpenSectorCategoryDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SectorCategoryDialogModel(),
        );
      },
    );
  }

  void Validation() {
    if (selectedSectorCategory != "Please Select Registration Type") {
      if (fullNameController.text.isNotEmpty) {
        if (emailController.text.isNotEmpty) {
          if (constants.IsValidEmail(emailController.text.toString())) {
            if (numberController.text.isNotEmpty) {
              if (numberController.text.toString().length == 11) {
                if (cnicController.text.isNotEmpty) {
                  if (cnicController.text.toString().length == 15) {
                    if (passwordController.text.isNotEmpty) {
                      if (confirmPasswordController.text.isNotEmpty) {
                        if (passwordController.text.toString() ==
                            confirmPasswordController.text.toString()) {
                          setState(() {
                            _isLoading = true;
                          });
                          CheckConnectivity();
                        } else {
                          uiUpdates.ShowToast(Strings.instance.passwordMatchMessage);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        uiUpdates.ShowToast(Strings.instance.confirmPasswordMessage);
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } else {
                      uiUpdates.ShowToast(Strings.instance.passwordMessage);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } else {
                    uiUpdates.ShowToast(Strings.instance.invalidCNICMessage);
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  uiUpdates.ShowToast(Strings.instance.cnicMessage);
                  setState(() {
                    _isLoading = false;
                  });
                }
              } else {
                uiUpdates.ShowToast(Strings.instance.invalidNumberMessage);
                setState(() {
                  _isLoading = false;
                });
              }
            } else {
              uiUpdates.ShowToast(Strings.instance.numberMessage);
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            uiUpdates.ShowToast(Strings.instance.invalidEmailMessage);
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          uiUpdates.ShowToast(Strings.instance.emailMessage);
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        uiUpdates.ShowToast(Strings.instance.fullnameMessage);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      uiUpdates.ShowToast(Strings.instance.companyCategoryMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void CheckConnectivity() {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.CheckConnectivity(context).then((value) => {
          if (value) {
            SendVerificationCodes()
          } else {
            uiUpdates.DismissProgresssDialog(),
            uiUpdates.ShowToast(Strings.instance.internetNotConnected),
            setState(() {
              _isLoading = false;
            })
          }
        });
  }

  SendVerificationCodes() async {
    uiUpdates.HideKeyBoard();
    Map data = {
      "email": emailController.text.toString(),
      "contact": numberController.text.toString(),
    };

    var url = constants.getApiBaseURL() + constants.authentication + "sendcode";
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
        String emailCode = body["Data"]["email_code"].toString();
        String otpCode = body["Data"]["phone_code"].toString();
        SignupDataModel signupDataModel = new SignupDataModel(
            fullNameController.text.toString(),
            cnicController.text.toString(),
            emailController.text.toString(),
            numberController.text.toString(),
            selectedGender,
            selectedSectorID,
            passwordController.text.toString(),
            emailCode,
            otpCode);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Verification(signupDataModel)),
        );
      } else {
        uiUpdates.ShowToast(message);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void HandelSeledSector(String value) {
    if (value != null && value != "") {
      selectedSectorCategory = value;
      setState(() {
        if (selectedSectorCategory == constants.selectorCategoryFirstName) {
          selectedSectorID = "1";
        } else if (selectedSectorCategory == constants.selectorCategorySecondName) {
          selectedSectorID = "2";
        } else {
          selectedSectorID = "3";
        }
      });
    }
  }
}
