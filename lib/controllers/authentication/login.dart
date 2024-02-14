
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employer/CompanyInformationFrom.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/wwf_employee/WWFEmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/general/splash_screen.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/employee_home.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/employer_home.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class LoginController extends GetxController{
  var isLoading=false.obs;

  FocusNode cnicNode= FocusNode();
  TextEditingController cnicController= TextEditingController();
  TextEditingController passwordController= TextEditingController();

  loginData({String ipAddress,String platform,String deviceModel,UIUpdates uiUpdates,BuildContext context}) async {
    uiUpdates.HideKeyBoard();
    Map<String,dynamic> data = {
      "cnic": cnicController.text.toString(),
      "password": passwordController.text.toString(),
      "ip": ipAddress,
      "platform": platform,
      "device": deviceModel,
    };
    print(data.toString());
    var url = constants.authentication+"login";


    ///http.post(Uri.parse(url), body: data, encoding: Encoding.getByName("UTF-8")
    var response = await APIService.postRequest(apiName: url,mapData: data,uiUpdates: uiUpdates);
    print(response);
//    print(url+response.body+" : "+response.statusCode.toString());
    try{
      uiUpdates.DismissProgresssDialog();
      if (response !=null) {
        var body = jsonDecode(response);
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
          passwordController.clear();
          SetScreen(user_sector, user_role, user_account,context,ref_id);
        } else {
          uiUpdates.ShowToast(Strings.instance.loginFailed);
        }
      }
    }catch(e){
      print('error:$e');
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }finally{
      uiUpdates.DismissProgresssDialog();
    }

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
  void SetScreen(String user_sector, String user_role, String user_account,BuildContext context, String ref_id) {
    print("user_account:$user_sector:$user_role");
    if((user_sector == "7" && user_role == "6")||(user_sector == "4" && user_role == "3")){ // wwf employee
      if(user_account == "0" || ref_id=="null") {
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
      if(user_account == "0" || ref_id=="null") {
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
      if(user_account == "0"|| ref_id=="null"){
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