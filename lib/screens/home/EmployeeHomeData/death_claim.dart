import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/company_dialog_model.dart';
import 'package:welfare_claims_app/models/CompanyModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/network/api_service.dart';

class DeathClaim extends StatefulWidget {
  @override
  _DeathClaimState createState() => _DeathClaimState();
}

class _DeathClaimState extends State<DeathClaim> {
  String eobiFilePath="", eobiFileName="Select EOBI Pension", affidavitNotClaimPath="", affidavitNotClaimName="Affidavit Not Claimed",
  affaiadavitNotMarriedPath= "", affaiadavitNotMarriedName="Affidavit No Marriage", compansationAwardPath="", compansationAwardName="Compensation Award",
  deathCertificatePath="", deathCertificateName= "Death Certificate", pensionBookPath="", pensionBookName="Pension Book",
  condonationPath="", condonationName="Condonation", cnicFilePath="", cnicFileName="CNIC/Form-B";
  String selectedDeathDate= Strings.instance.selectedDeathDate;
  Constants constants;
  UIUpdates uiUpdates;
  List<CompanyModel> companiesList = [];
  String comp_id='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
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
                      child: Text("Death Claim",
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
                margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                child: SingleChildScrollView(
                    child: Column(
                      children: [

                        InkWell(
                          onTap: (){
                            _selectDate(context, 1);
                          },
                          child: Container(
                             // margin: EdgeInsets.only(top: 15),
                          height: 45,
                            child: Stack(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            height: 35,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(selectedDeathDate,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: selectedDeathDate == Strings.instance.selectedDeathDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                                                        fontSize: 14,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
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
                        ),

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(1);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(eobiFileName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(2);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(affidavitNotClaimName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(3);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(affaiadavitNotMarriedName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(4);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(compansationAwardName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(5);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(deathCertificateName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(6);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(pensionBookName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(7);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(condonationName,
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

                        InkWell(
                          onTap: ()
                          {
                            OpenFilePicker(8);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                            ),
                            child: Center(
                              child: Text(cnicFileName,
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

                        InkWell(
                          onTap: (){
                            Validation();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 60),
                            height: 45,
                            color: AppTheme.colors.newPrimary,
                            child: Center(
                              child: Text("Add",
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
                      ],
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<CompanyModel> OpenCompanyDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CompaniesDialogModel(companiesList),
          );
        });
  }

  Future<void> _selectDate(BuildContext context, int position) async {
    Map<int, Color> color =
    {
      50:Color.fromRGBO(4,131,184, .1),
      100:Color.fromRGBO(4,131,184, .2),
      200:Color.fromRGBO(4,131,184, .3),
      300:Color.fromRGBO(4,131,184, .4),
      400:Color.fromRGBO(4,131,184, .5),
      500:Color.fromRGBO(4,131,184, .6),
      600:Color.fromRGBO(4,131,184, .7),
      700:Color.fromRGBO(4,131,184, .8),
      800:Color.fromRGBO(4,131,184, .9),
      900:Color.fromRGBO(4,131,184, 1),
    };

    MaterialColor myColor = MaterialColor(constants.dateDialogBg, color);
    MaterialColor myColornewWhite = MaterialColor(constants.dateDialogText, color);
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1947, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: myColor,
              primaryColorDark: myColornewWhite,
              accentColor: myColornewWhite,
            ),
            dialogBackgroundColor:Colors.white,
          ),
          child: child,
        );
      },);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selectedDeathDate= selectedDate.toString();
      });
  }

  void OpenFilePicker(int position) async{
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied || status.isLimited || status.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf", "png", "jpeg", "jpg"]
    );

    if(result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        if(position == 1) {
          eobiFileName = file.name;
          eobiFilePath = file.path;
        }else if(position == 2){
          affidavitNotClaimName = file.name;
          affidavitNotClaimPath = file.path;
        }else if(position == 3){
          affaiadavitNotMarriedName = file.name;
          affaiadavitNotMarriedPath = file.path;
        }else if(position == 4){
          compansationAwardName = file.name;
          compansationAwardPath = file.path;
        }else if(position == 5){
          deathCertificateName = file.name;
          deathCertificatePath = file.path;
        }else if(position == 6){
          pensionBookName = file.name;
          pensionBookPath = file.path;
        }else if(position == 7){
          condonationName = file.name;
          condonationPath = file.path;
        }else if(position == 8){
          cnicFileName = file.name;
          cnicFilePath = file.path;
        }
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void Validation() {
    if(selectedDeathDate != Strings.instance.selectedDeathDate){
      if(eobiFilePath.isNotEmpty){
        if(affidavitNotClaimPath.isNotEmpty){
          if(affaiadavitNotMarriedPath.isNotEmpty){
            if(compansationAwardPath.isNotEmpty){
              if(deathCertificatePath.isNotEmpty){
                if(pensionBookPath.isNotEmpty){
                  if(condonationPath.isNotEmpty){
                    if(cnicFilePath.isNotEmpty){
                      ChecjConnectivity();
                    }else{
                      uiUpdates.ShowToast(Strings.instance.dcSelectCnic);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.dcSelectCondonsation);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.dcSelectPensionBook);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.dcSelectDeathCertificate);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.dcSelectCompansationAward);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.dcAffaidavitNoMarriage);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.dcAffaiadavitNoClaim);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.dcSelectedEobiPension);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectedDeathDate);
    }

  }

  void ChecjConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddDeathClaim()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddDeathClaim() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.claims+"deceased_claim";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['emp_id'] = UserSessions.instance.getEmployeeID;
    request.fields['comp_id'] =comp_id;
    request.fields['user_id'] = UserSessions.instance.getUserID;
    // Token now sent in Authorization header, not in fields
    APIService.addAuthHeaderToMultipartRequest(request);
    request.fields['death_date'] = selectedDeathDate;
    request.files.add(
        http.MultipartFile(
            'eobipension',
            File(eobiFilePath).readAsBytes().asStream(),
            File(eobiFilePath).lengthSync(),
            filename: eobiFilePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'not_claimed',
            File(affidavitNotClaimPath).readAsBytes().asStream(),
            File(affidavitNotClaimPath).lengthSync(),
            filename: affidavitNotClaimPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'no_marriage',
            File(affaiadavitNotMarriedPath).readAsBytes().asStream(),
            File(affaiadavitNotMarriedPath).lengthSync(),
            filename: affaiadavitNotMarriedPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'award',
            File(compansationAwardPath).readAsBytes().asStream(),
            File(compansationAwardPath).lengthSync(),
            filename: compansationAwardPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'death_certificate',
            File(deathCertificatePath).readAsBytes().asStream(),
            File(deathCertificatePath).lengthSync(),
            filename: deathCertificatePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'book',
            File(pensionBookPath).readAsBytes().asStream(),
            File(pensionBookPath).lengthSync(),
            filename: pensionBookPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'condonation',
            File(condonationPath).readAsBytes().asStream(),
            File(condonationPath).lengthSync(),
            filename: condonationPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'cnic',
            File(cnicFilePath).readAsBytes().asStream(),
            File(cnicFilePath).lengthSync(),
            filename: cnicFilePath.split("/").last
        )
    );

    var response = await request.send();
    uiUpdates.DismissProgresssDialog();
    try {
      final resp = await http.Response.fromStream(response);
      print('${request.fields}:url:$url :${resp.body}:${resp.statusCode}');
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.deathClaimRequestMessage);
          Navigator.of(context).pop(true);
        } else {
          uiUpdates.ShowToast(Strings.instance.faileddeathClaim);
        }
      } else {
        var body = jsonDecode(resp.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    }catch(e){
      uiUpdates.ShowToast(e);
    }
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
    List<String> tagsList= [constants.accountInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
    debugPrint(response.body+" : "+response.statusCode.toString(),wrapWidth: 1024);
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    print(response.body);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var account= data["account"];
        String empID= account["emp_id"].toString();
        comp_id=account["comp_id"].toString();
        UserSessions.instance.setEmployeeID(empID);

      } else {
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
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
