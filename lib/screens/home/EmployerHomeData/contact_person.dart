import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/screens/home/EmployerHomeData/AddContactPerson.dart';
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';

class ContactPerson extends StatefulWidget {
  @override
  _ContactPersonState createState() => _ContactPersonState();
}

class _ContactPersonState extends State<ContactPerson> {
  String faxNo= Strings.instance.notAvail, name = Strings.instance.notAvail, designation = Strings.instance.notAvail, gender = Strings.instance.notAvail, email = Strings.instance.notAvail, number = Strings.instance.notAvail;
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
      backgroundColor: AppTheme.colors.white,
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
                          child: Text("Contact Person",
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
                            builder: (context) => AddContactPerson()
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

            !isError ? SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.colors.colorDarkGray),
                ),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          color: AppTheme.colors.newPrimary,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Center(child: Icon(Icons.perm_contact_cal_rounded, size: 20, color: AppTheme.colors.white,))
                          ),
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 13,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Text(
                                    designation,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.colorDarkGray,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),

                              Text(
                                gender,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fax Number",
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),

                              Text(
                                faxNo,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),

                              Text(
                                email,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contact Number",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal
                                ),
                              ),

                              Text(
                                number,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ) : Expanded(
              child: Container(
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
    List<String> tagsList= [constants.accountInfo, constants.contactPersonInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "user_token": UserSessions.instance.getToken,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data);
    print(response.body+" : "+response.statusCode.toString());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        if(data != null) {
          var account = data["account"];
          if (account != null) {
            var deoDetail = account["person"];
            if(deoDetail != null) {
              name = deoDetail["person_name"].toString();
              faxNo = deoDetail["person_fax_no"].toString();
              number = deoDetail["person_contact"].toString();
              gender = deoDetail["person_gender"].toString();
              email = deoDetail["person_email"].toString();
              designation = deoDetail["person_about"].toString();
            }else{
              isError = true;
              errorMessage = Strings.instance.notAvail;
            }
          }else{
            isError = true;
            errorMessage = Strings.instance.notAvail;
          }
        }else{
          isError = true;
          errorMessage = Strings.instance.notAvail;
        }
      } else {
        isError = true;
        errorMessage = Strings.instance.notAvail;
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
      }
    } else {
      var body = jsonDecode(response.body);
      String message = body["Message"].toString();
      if(message == constants.expireToken){
        isError = true;
        errorMessage = Strings.instance.notAvail;
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        isError = true;
        errorMessage = Strings.instance.notAvail;
        uiUpdates.ShowToast(message);
      }
    }

    setState(() {});
  }
}
