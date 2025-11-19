import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_beneficiary.dart';
import '../../../Strings/Strings.dart';
import '../../../constants/Constants.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../network/api_service.dart';
import '../../../uiupdates/UIUpdates.dart';
import '../../../usersessions/UserSessions.dart';

class BeneficiaryDetail extends StatefulWidget {
  @override
  _BeneficiaryDetailState createState() => _BeneficiaryDetailState();
}

class _BeneficiaryDetailState extends State<BeneficiaryDetail> {
  String image = "", name = Strings.instance.notAvail, identity = Strings.instance.notAvail,
      cnic = Strings.instance.notAvail, number = Strings.instance.notAvail,
      guardian = Strings.instance.notAvail, relation = Strings.instance.notAvail,
      bank = Strings.instance.notAvail, nature = Strings.instance.notAvail,
      accountNumber = Strings.instance.notAvail, accountTitle = Strings.instance.notAvail,
      address = Strings.instance.notAvail;
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
                          child: Text("Beneficiary",
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
                            builder: (context) => AddBeneficiary()
                        )).then((value)  {
                          setState(() {});
                          if(value){
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

            !isError ? SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.colors.colorDarkGray),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: image != "null" && image != "" && image != "NULL" ? FadeInImage(
                              image: NetworkImage(constants.getImageBaseURL()+image),
                              placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                              fit: BoxFit.fill,
                            ) : Image.asset("assets/images/no_image_placeholder.jpg",
                              height: 40.0,
                              width: 40,
                              fit: BoxFit.fill,
                            ),
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
                                    number,
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
                                "Identity",
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
                                identity,
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
                                "CNIC",
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
                                cnic,
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
                                "Guardian",
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
                                guardian,
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
                                "Beneficiary Relation",
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
                                relation,
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
                                "Beneficiary Nature",
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
                                nature,
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
                                "Bank",
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
                                bank,
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
                                "Account Title",
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
                                accountTitle,
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
                                "Account Number",
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
                                accountNumber,
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

                    SizedBox(
                      height: 10,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address",
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
                          address,
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
    List<String> tagsList= [constants.accountInfo, constants.inheritorInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        if(data != null) {
          var account = data["account"];
          if (account != null) {
            var inheritors = account["inheritors"];
            if(inheritors != null) {
              identity = inheritors["bene_identity"].toString();
              name = inheritors["bene_name"].toString();
              image = inheritors["bene_upload"].toString();
              number = inheritors["bene_contact"].toString();
              cnic = inheritors["bene_cnic"].toString();
              guardian = inheritors["bene_guardian"].toString();
              relation = inheritors["bene_relation"].toString();
              bank = inheritors["bene_bank"].toString();
              nature = inheritors["bene_nature"].toString();
              accountTitle = inheritors["bene_title"].toString();
              accountNumber = inheritors["bene_account"].toString();
              address = inheritors["bene_address"].toString();
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
