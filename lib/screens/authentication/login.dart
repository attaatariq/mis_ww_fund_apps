import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employer/CompanyInformationFrom.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/wwf_employee/WWFEmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/authentication/forgot_password.dart';
import 'package:welfare_claims_app/screens/authentication/signup.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/employee_home.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/employer_home.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

FocusNode cnicNode= FocusNode();
TextEditingController cnicController= TextEditingController();
TextEditingController passwordController= TextEditingController();

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver{
  bool rememberMe = false;
  var cnicMask = new MaskTextInputFormatter(mask: '#####-#######-#',);
  String ipAddress="000.000.0.000", deviceModel="Not Available", platform="";
  UIUpdates uiUpdates;
  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    ///check new updated version
    constants.CheckForNewUpdate(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      print("Resume Called");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(190), bottomRight: Radius.circular(190))
              ),

              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  child: Column(
                    children: [
                      Container(
                        height: 120.0,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.asset("assets/images/logo.png",
                            height: 120.0,
                            width: 120,
                            color: AppTheme.colors.newWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 60),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 45,
                    child: Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: Icon(Icons.person_pin_outlined, color: AppTheme.colors.newPrimary, size: 18,)
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Container(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      focusNode: cnicNode,
                                      controller: cnicController,
                                      inputFormatters: [cnicMask],
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "CNIC NO",
                                        hintStyle: TextStyle(
                                            fontFamily: "AppFont",
                                            color: AppTheme.colors.colorDarkGray
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 1,
                            color: AppTheme.colors.colorDarkGray,
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 45,
                    child: Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: Icon(Icons.lock_outline, color: AppTheme.colors.newPrimary, size: 18,)
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Container(
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: passwordController,
                                      cursorColor: AppTheme.colors.newPrimary,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.colors.newBlack
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            fontFamily: "AppFont",
                                            color: AppTheme.colors.colorDarkGray
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 1,
                            color: AppTheme.colors.colorDarkGray,
                          ),
                        )
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ForgotPassword()
                          ));
                        },
                        child: Text("Forgot Password?",
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50,),

                  InkWell(
                    onTap: (){
                      GetIPAddress();
                    },
                    child: Material(
                      elevation: 10,
                      shadowColor: AppTheme.colors.colorLightGray,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary,
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: Center(
                          child: Text("Login",
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
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SignUp()
                        ));
                      },
                      child: Container(
                        height: 20,
                        child: Text("Don't have an account? SIGN UP",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;
  });

  void InformationScreenNavigation()
  {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => EmployeeHome()
    ));
  }

  void Validation() {
    if(cnicController.text.isNotEmpty)
      {
        if(cnicController.text.toString().length == 15) {
          if (passwordController.text.isNotEmpty) {
              CheckConnectivity();
          } else {
            uiUpdates.ShowToast(Strings.instance.passwordMessage);
          }
        }else {
          uiUpdates.ShowToast(Strings.instance.invalidCNICMessage);
        }
      }else{
      uiUpdates.ShowToast(Strings.instance.cnicMessage);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value)
        {
          LoginUser()
        }else{
        uiUpdates.DismissProgresssDialog(),
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  LoginUser() async{
    uiUpdates.HideKeyBoard();
    Map data = {
      "cnic": cnicController.text.toString(),
      "password": passwordController.text.toString(),
      "ip": ipAddress,
      "platform": platform,
      "device": deviceModel,
    };
    print(data.toString());
    var url = constants.getApiBaseURL()+constants.authentication+"login";
    var response = await http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8"));
    print(response.body+" : "+response.statusCode.toString());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(response.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.loginSuccess);
          var dataObject = body["Data"];
          String userID = dataObject["user_id"].toString();
          String user_name = dataObject["user_name"].toString();
          String user_cnic = dataObject["user_cnic"].toString();
          String user_email = dataObject["user_email"].toString();
          String user_contact = dataObject["user_contact"].toString();
          String user_sector = dataObject["user_sector"].toString();
          String sector_name = dataObject["sector_name"].toString();
          String user_role = dataObject["user_role"].toString();
          String role_name = dataObject["role_name"].toString();
          String user_image = dataObject["user_image"].toString();
          String user_about = dataObject["user_about"].toString();
          String user_token = dataObject["user_token"].toString();
          String user_account = dataObject["user_account"].toString();
          String ref_id = dataObject["ref_id"].toString();
          String agent_expiry = dataObject["agent_expiry"].toString();
          SetSession(
              userID,
              user_name,
              user_cnic,
              user_email,
              user_contact,
              user_image,
              user_about,
              user_token,
              user_account,
              user_sector,
              user_role,
              ref_id,
              agent_expiry);
          SetScreen(user_sector, user_role, user_account);
        } else {
          uiUpdates.ShowToast(Strings.instance.loginFailed);
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
  }

  GetIPAddress() {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    constants.GetIPAddress(context).then((value) => {
      ipAddress = value,
      GetDeviceinfo()
    });
  }

  GetDeviceinfo() {
    constants.GetDeviceInfo(context).then((value) => {
      deviceModel = value,
      GetPalform()
    });
  }

  GetPalform() {
    constants.GetPlatForm(context).then((value) => {
      platform = value,
      Validation()
    });
  }

  void SetSession(String userID, String user_name, String user_cnic, String user_email, String user_contact, String user_image, String user_about, String user_token, String user_account, String user_sector, String user_role, String ref_id, String agent_expiry) {
    UserSessions.instance.setUserID(userID);
    UserSessions.instance.setUserName(user_name);
    UserSessions.instance.setUserCNIC(user_cnic);
    UserSessions.instance.setUserEmail(user_email);
    UserSessions.instance.setUserNumber(user_contact);
    UserSessions.instance.setUserImage(user_image);
    UserSessions.instance.setUserAbout(user_about);
    UserSessions.instance.setToken(user_token);
    UserSessions.instance.setUserAccount(user_account);
    UserSessions.instance.setUserSector(user_sector);
    UserSessions.instance.setUserRole(user_role);
    UserSessions.instance.setRefID(ref_id);
    UserSessions.instance.setAgentExpiry(agent_expiry);
    if(user_sector == "8" && user_role == "8"){
      UserSessions.instance.setDeoID(true);
    }
  }

  void SetScreen(String user_sector, String user_role, String user_account) {
    if(user_sector == "7" && user_role == "6"){ // wwf employee
      if(user_account == "0") {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => WWFEmployeeInformationForm(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeHome(),
          ),
              (route) => false,
        );
      }
    }else if(user_sector == "8" && user_role == "9"){ // company worker
      if(user_account == "0") {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeInformationForm(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeHome(),
          ),
              (route) => false,
        );
      }
    }else if(user_sector == "8" && user_role == "7"){ //CEO company
      if(user_account == "0"){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => CompanyInformationForm(),
          ),
              (route) => false,
        );
      }else{
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployerHome(),
          ),
              (route) => false,
        );
      }
    }else if(user_sector == "8" && user_role == "8"){ //DEO company
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => EmployerHome(),
        ),
            (route) => false,
      );
    }else if(user_sector == "9" && user_role == "10"){ //Manager fee school

    }
  }
}
