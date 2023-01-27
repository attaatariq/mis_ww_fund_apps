import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/self_education_list_item.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/SelfEducationModel.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_self_education.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
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
                        )).then((value) => {
                          setState(() {})
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
    List<String> tagsList= [constants.accountInfo, constants.empEduList];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "user_token": UserSessions.instance.getToken,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    print(jsonEncode(tagsList).toString());
    //uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    print(url);
    var response = await http.post(Uri.parse(url), body: data);
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"]["account"];
        List<dynamic> schools= data["emp_edu_ls"];
        if(schools.length > 0){
          schools.forEach((element) {
            selfEducationModelList.add(new SelfEducationModel(
              element["edu_id"],
              element["emp_id"],
              element["child_id"],
              element["school_id"],
              element["edu_nature"],
              element["edu_level"],
              element["edu_degree"],
              element["edu_class"],
              element["edu_started"],
              element["edu_ended"],
              element["edu_living"],
              element["edu_card"],
              element["edu_affiliate"],
              element["edu_challan"],
              element["edu_result"],
              element["school_name"],));
          });

          uiUpdates.DismissProgresssDialog();
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
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
        setState(() {
          isError= true;
          errorMessage = Strings.instance.educationListNotAvail;
        });
      }
    } else {
      var body = jsonDecode(response.body);
      String message = body["Message"].toString();
      if(message == constants.expireToken){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        uiUpdates.ShowToast(message);
      }
    }
  }
}
