import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/employee_verification_item.dart';
import 'package:welfare_claims_app/models/EmployeeVerificationModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

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
    print(newInt);
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
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Employee Verification",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: Column(
                  children: [
                    isError ? Expanded(
                      child: Center(
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal),
                        ),
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
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.companies +
        "list_employees/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      print("0");
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        print("1");
        var message= body["Message"];
        List<dynamic> entitlements = message["Unverified_Employees"];
        if(entitlements.length > 0)
        {
          print("2");
          list.clear();
          entitlements.forEach((row) {
            String user_id= row["user_id"].toString();
            String emp_id= row["emp_id"].toString();
            String user_name= row["user_name"].toString();
            String user_image= row["user_image"].toString();
            String user_cnic= row["user_cnic"].toString();
            String emp_about= row["emp_about"].toString();
            String emp_ssno= row["emp_ssno"].toString();
            String emp_eobino= row["emp_eobino"].toString();
            String appointed_at= row["appointed_at"].toString();
            list.add(new EmployeeVerificationModel(user_id, emp_id, user_name, user_image, user_cnic, emp_about, emp_ssno, emp_eobino, appointed_at));
          });

          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= false;
          });
        }else
        {
          print("3");
          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= true;
            errorMessage = "Employees Not Available";
          });
        }
      } else {
        print("4");
        uiUpdates.DismissProgresssDialog();
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      print("5");
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
}
