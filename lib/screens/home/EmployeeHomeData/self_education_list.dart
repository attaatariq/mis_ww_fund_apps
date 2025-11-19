import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/self_education_list_item.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/SelfEducationModel.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_self_education.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:welfare_claims_app/widgets/empty_state_widget.dart';
import 'package:http/http.dart' as http;

class SelfEducationList extends StatefulWidget {
  @override
  _SelfEducationListState createState() => _SelfEducationListState();
}

class _SelfEducationListState extends State<SelfEducationList> {
  List<SelfEducationModel> selfEducationModelList= [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          child: Text("Self Education",
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

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddSelfEducation()
                        )).then((value)  {
                          setState(() {});
                          if(value==true){
                            selfEducationModelList.clear();
                            CheckTokenExpiry();
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.add_box_outlined, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            isError ? Expanded(
              child: EmptyStates.noEducation(),
            ) : Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (_, int index) =>
                      SelfEducationListItem(selfEducationModelList[index]),
                  itemCount: this.selfEducationModelList.length,
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
      }else{
        GetInformation();
      }
    });
  }

  GetInformation() async{
    try {
      List<String> tagsList= [constants.accountInfo, constants.empEduList];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      print(jsonEncode(tagsList).toString());
      
      var url = constants.getApiBaseURL()+constants.authentication+"information";
      print(url);
      var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      print(response.body);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var dataBody = body["Data"];
            if(dataBody != null && dataBody["account"] != null) {
              var data = dataBody["account"];
              List<dynamic> schools= data["emp_edu_ls"] != null ? data["emp_edu_ls"] : [];
              if(schools.length > 0){
                selfEducationModelList.clear();
                schools.forEach((element) {
                  selfEducationModelList.add(new SelfEducationModel(
                    element["edu_id"]?.toString() ?? "",
                    element["emp_id"]?.toString() ?? "",
                    element["child_id"]?.toString() ?? "",
                    element["school_id"]?.toString() ?? "",
                    element["edu_nature"]?.toString() ?? "",
                    element["edu_level"]?.toString() ?? "",
                    element["edu_degree"]?.toString() ?? "",
                    element["edu_class"]?.toString() ?? "",
                    element["edu_started"]?.toString() ?? "",
                    element["edu_ended"]?.toString() ?? "",
                    element["edu_living"]?.toString() ?? "",
                    element["edu_card"]?.toString() ?? "",
                    element["edu_affiliate"]?.toString() ?? "",
                    element["edu_challan"]?.toString() ?? "",
                    element["edu_result"]?.toString() ?? "",
                    element["school_name"]?.toString() ?? "",));
                });

                setState(() {
                  isError= false;
                });
              }else{
                setState(() {
                  isError= true;
                  errorMessage = Strings.instance.educationListNotAvail;
                });
              }
            } else {
              setState(() {
                isError= true;
                errorMessage = Strings.instance.educationListNotAvail;
              });
            }
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.educationListNotAvail;
            });
          }
        } catch (e) {
          print('JSON parsing error: $e');
          setState(() {
            isError= true;
            errorMessage = Strings.instance.educationListNotAvail;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"]?.toString() ?? "";
          
          if(message == constants.expireToken){
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          }else if(message.isNotEmpty && message != "null"){
            uiUpdates.ShowToast(message);
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.educationListNotAvail;
            });
          }
        } catch (e) {
          print('Error parsing error response: $e');
          setState(() {
            isError= true;
            errorMessage = Strings.instance.educationListNotAvail;
          });
        }
      }
    } catch (e) {
      print('Network or request error: $e');
      setState(() {
        isError= true;
        errorMessage = Strings.instance.educationListNotAvail;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      // Add small delay to ensure dialog is shown before dismissing
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
