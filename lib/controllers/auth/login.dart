
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/models/ClaimStageModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/sectors/employer/CompanyForm.dart';
import 'package:wwf_apps/screens/sectors/employee/EmployeeForm.dart';
import 'package:wwf_apps/screens/general/splash_screen.dart';
import 'package:wwf_apps/screens/home/employee/employee_home.dart';
import 'package:wwf_apps/screens/home/employer/employer_home.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class LoginController extends GetxController{
  var isLoading=false.obs;

  FocusNode cnicNode= FocusNode();
  TextEditingController cnicController= TextEditingController();
  TextEditingController passwordController= TextEditingController();

  loginData({String ipAddress,String platform,String deviceModel,UIUpdates uiUpdates,BuildContext context, Function(bool) onComplete}) async {
    uiUpdates.HideKeyBoard();
    Map<String,dynamic> data = {
      "cnic": cnicController.text.toString(),
      "password": passwordController.text.toString(),
      "ip": ipAddress,
      "platform": platform,
      "device": deviceModel,
    };
    var url = constants.authentication+"login";

    try {
      var response = await APIService.postRequest(apiName: url,mapData: data,uiUpdates: uiUpdates);
      
      // Always dismiss dialog first
      uiUpdates.DismissProgresssDialog();
      
      if (response != null && response.isNotEmpty) {
        try {
          var body = jsonDecode(response);
          String code = body["Code"].toString();
          if (code == "1") {
            uiUpdates.ShowSuccess(Strings.instance.loginSuccess);
            var dataObject = body["Data"];
            
            // Handle nested account structure - account data is nested under "account" key
            var account = dataObject["account"];
            if (account == null) {
              // Fallback: try direct access for backward compatibility
              account = dataObject;
            }
            
            // Extract user account information with null safety
            String userID = account["user_id"]?.toString() ?? "";
            String user_name = account["user_name"]?.toString() ?? "";
            String user_cnic = account["user_cnic"]?.toString() ?? "";
            String user_email = account["user_email"]?.toString() ?? "";
            String user_contact = account["user_contact"]?.toString() ?? "";
            String user_sector = account["user_sector"]?.toString() ?? "";
            String sector_name = account["sector_name"]?.toString() ?? "";
            String user_role = account["user_role"]?.toString() ?? "";
            String role_name = account["role_name"]?.toString() ?? "";
            String user_image = account["user_image"]?.toString() ?? "";
            String user_about = account["user_about"]?.toString() ?? "";
            
            // These fields might be at Data level or account level - check both
            String user_token = dataObject["user_token"]?.toString() ?? account["user_token"]?.toString() ?? "";
            String user_account = dataObject["user_account"]?.toString() ?? account["user_account"]?.toString() ?? account["user_count"]?.toString() ?? "0";
            String user_backing = dataObject["user_backing"]?.toString() ?? account["user_backing"]?.toString() ?? account["ref_id"]?.toString() ?? "null";
            String agent_expiry = dataObject["agent_expiry"]?.toString() ?? account["agent_expiry"]?.toString() ?? "";
            
            // Extract employee ID if available (for employees)
            String emp_id = account["emp_id"]?.toString() ?? "";
            
            // Load claim stages data if available (check both Data level and account level)
            if (dataObject["claim_stages"] != null) {
              try {
                Map<String, dynamic> claimStagesJson = dataObject["claim_stages"];
                ClaimStagesData.instance.loadFromJson(claimStagesJson);
              } catch (e) {
                // Silently fail if claim stages parsing fails
              }
            } else if (account["claim_stages"] != null) {
              try {
                Map<String, dynamic> claimStagesJson = account["claim_stages"];
                ClaimStagesData.instance.loadFromJson(claimStagesJson);
              } catch (e) {
                // Silently fail if claim stages parsing fails
              }
            }
            
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
                user_backing,
                agent_expiry,
                emp_id
            );

            // Reset feedback dialog flag on login (so it shows once per login)
            UserSessions.instance.setFeedbackDialogShown(false);
            
            // Show welcome toast message
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context != null) {
                uiUpdates.ShowSuccess("Welcome Back! Welcome On Dashboard, ${user_name}.");
              }
            });

            passwordController.clear();
            SetScreen(user_sector, user_role, user_account, context, user_backing);
            if (onComplete != null) onComplete(true);
          } else {
            String errorMessage = body["Message"]?.toString() ?? Strings.instance.loginFailed;
            uiUpdates.ShowError(errorMessage);
            if (onComplete != null) onComplete(false);
          }
        } catch (e) {
          uiUpdates.ShowError(Strings.instance.somethingWentWrong);
          if (onComplete != null) onComplete(false);
        }
      } else {
        // Response is null or empty - error already shown by APIService
        if (onComplete != null) onComplete(false);
      }
    } catch(e) {
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowError(Strings.instance.somethingWentWrong);
      if (onComplete != null) onComplete(false);
    }
  }

  void SetSession(String userID, String user_name, String user_cnic, String user_email, String user_contact, String user_image, String user_about, String user_token, String user_account, String user_sector, String user_role, String user_backing, String agent_expiry, [String emp_id = ""]) {
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
    UserSessions.instance.setRefID(user_backing);
    UserSessions.instance.setAgentExpiry(agent_expiry);
    
    // Set employee ID if available
    if (emp_id.isNotEmpty) {
      UserSessions.instance.setEmployeeID(emp_id);
    }
    
    if(user_sector == "8" && user_role == "8"){
      UserSessions.instance.setDeoID(true);
    }
  }
  void SetScreen(String user_sector, String user_role, String user_account,BuildContext context, String user_backing) {
    if((user_sector == "7" && user_role == "6")||(user_sector == "4" && user_role == "3")){ // wwf employee
      if(user_account == "0" || user_backing == "null") {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeForm(),
          ),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => EmployeeHome(),
          ),
              (route) => false,
        );
      }
    }else if(user_sector == "8" && user_role == "9"){ // company worker
      if(user_account == "0" || user_backing == "null") {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => WorkerForm(),
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
      if(user_account == "0"|| user_backing == "null"){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => CompanyForm(),
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