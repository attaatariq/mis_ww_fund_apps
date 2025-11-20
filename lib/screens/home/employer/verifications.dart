import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/employee_verification_item.dart';
import 'package:wwf_apps/models/EmployeeVerificationModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';

class EmployeeVerification extends StatefulWidget {
  @override
  _EmployeeVerificationState createState() => _EmployeeVerificationState();
}

class _EmployeeVerificationState extends State<EmployeeVerification> {

  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<EmployeeVerificationModel> list= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetEmployees();
  }

  void parentFunction(newInt)
  {
    setState(() {
      list.removeAt(newInt);
      if(list.length == 0){
        isError = true;
        errorMessage = "Employee Not Available";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            StandardHeader(
              title: "Employee Verification",
            ),

            Expanded(
              child: Container(
                child: Column(
                  children: [
                    isError ? Expanded(
                      child: EmptyStateWidget(
                        icon: Icons.people_outline,
                        message: 'No Employees Available',
                        description: 'Employee verification records will appear here once available.',
                      ),
                    ) : Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (_, int index) =>
                              EmployeeVerificationItem(list[index], index, parentFunction),
                          itemCount: this.list.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }

  GetEmployees() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.employees +
          "index/" + UserSessions.instance.getUserID + "/" + UserSessions.instance.getRefID;
      var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            List<dynamic> entitlements = body["Data"] != null ? body["Data"] : [];
            if(entitlements.length > 0)
            {
              list.clear();
              entitlements.forEach((row) {
                String user_id= row["user_id"] != null ? row["user_id"].toString() : "";
                String emp_id= row["emp_id"] != null ? row["emp_id"].toString() : "";
                String user_name= row["user_name"] != null ? row["user_name"].toString() : "";
                String user_image= row["user_image"] != null ? row["user_image"].toString() : "";
                String user_cnic= row["user_cnic"] != null ? row["user_cnic"].toString() : "";
                String emp_about= row["emp_about"] != null ? row["emp_about"].toString() : "";
                String emp_ssno= row["emp_ssno"] != null ? row["emp_ssno"].toString() : "";
                String emp_eobino= row["emp_eobino"] != null ? row["emp_eobino"].toString() : "";
                String appointed_at= row["appointed_at"] != null ? row["appointed_at"].toString() : "";
                list.add(new EmployeeVerificationModel(user_id, emp_id, user_name, user_image, user_cnic, emp_about, emp_ssno, emp_eobino, appointed_at));
              });

              setState(() {
                isError= false;
              });
            }else
            {
              setState(() {
                isError= true;
                errorMessage = Strings.instance.notAvail;
              });
            }
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"] != null ? body["Message"].toString() : "";
          
          if(message == constants.expireToken){
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          }else if(message.isNotEmpty && message != "null"){
            uiUpdates.ShowToast(message);
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      setState(() {
        isError= true;
        errorMessage = Strings.instance.notAvail;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
