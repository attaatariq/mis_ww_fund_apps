import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/child_dialog_model.dart';
import 'package:wwf_apps/dialogs/company_dialog_model.dart';
import 'package:wwf_apps/dialogs/marriage_category_dialog_model.dart';
import 'package:wwf_apps/models/ChildModel.dart';
import 'package:wwf_apps/models/CompanyModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/network/api_service.dart';

class MarraiageClaim extends StatefulWidget {
  @override
  _MarraiageClaimState createState() => _MarraiageClaimState();
}

TextEditingController husbandNameController= TextEditingController();

class _MarraiageClaimState extends State<MarraiageClaim> {
  String serviceCertificateFilePath="", serviceCertificateFileName="Service Certificate", affidavitNotClaimPath="", affidavitNotClaimName="Affidavit Not Claimed",
      compansationAwardPath="", compansationAwardName="Compensation Award", nikahNamaPath="", nikahNamaName="Nikah Nama",
      accumulativeServicePath="", accumulativeServiceName="Accumulated";
  String selectedMarriageCategory= Strings.instance.selectedCategory;
  String selectedMarriageDate= Strings.instance.selectedMarriageDate, selectedChildID="", selectedChild= Strings.instance.selectedChild;
  Constants constants;
  UIUpdates uiUpdates;
  List<ChildModel> childModelList= [];
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
                      child: Text("Marriage Claim",
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
                          OpenMarriageCategoryDialog(context).then((value) => {
                            setState(() {
                              selectedMarriageCategory= value;
                            })
                          });
                        },
                        child: Container(
                       //   margin: EdgeInsets.only(top: 15),
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
                                                child: Text(selectedMarriageCategory,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedMarriageCategory == Strings.instance.selectedCategory ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                                                      fontSize: 14,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ),

                                              Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.colors.newPrimary, size: 18,)
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

                      selectedMarriageCategory == constants.marriageDaughter ? InkWell(
                        onTap: (){
                          if(childModelList.length > 0) {
                            OpenChildDialog(context).then((value) =>
                            {
                              if(value != null){
                                setState(() {
                                  selectedChildID = value.id;
                                  selectedChild = value.name;
                                })
                              }
                            });
                          }else{
                            uiUpdates.ShowToast(Strings.instance.childNotAvail);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
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
                                                child: Text(selectedChild,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedChild == Strings.instance.selectedChild ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                                                      fontSize: 14,
                                                      fontFamily: "AppFont",
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ),

                                              Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.colors.newPrimary, size: 18,)
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
                      ) : Container(),

                      Container(
                        margin: EdgeInsets.only(top: 15),
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
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: husbandNameController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.newBlack
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Husband Name",
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

                      InkWell(
                        onTap: (){
                          _selectDate(context, 1);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
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
                                                child: Text(selectedMarriageDate,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedMarriageDate == Strings.instance.selectedMarriageDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                            child: Text(serviceCertificateFileName,
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
                          OpenFilePicker(4);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                          ),
                          child: Center(
                            child: Text(nikahNamaName,
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
                            child: Text(accumulativeServiceName,
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
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> OpenMarriageCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: MarriageCategoryDialogModel(),
          );
        }
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
  Future<ChildModel> OpenChildDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: ChildDialogModel(childModelList),
          );
        }
    );
  }

  void OpenFilePicker(int position) async{
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied || status.isLimited || status.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
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
          serviceCertificateFileName = file.name;
          serviceCertificateFilePath = file.path;
        }else if(position == 2){
          affidavitNotClaimName = file.name;
          affidavitNotClaimPath = file.path;
        }else if(position == 3){
          compansationAwardName = file.name;
          compansationAwardPath = file.path;
        }else if(position == 4){
          nikahNamaName = file.name;
          nikahNamaPath = file.path;
        }else if(position == 5){
          accumulativeServiceName = file.name;
          accumulativeServicePath = file.path;
        }
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void Validation() {
      if(selectedMarriageCategory != Strings.instance.selectedCategory){
      if(husbandNameController.text.toString().isNotEmpty){
        if(serviceCertificateFilePath.isNotEmpty){
          if(affidavitNotClaimPath.isNotEmpty){
            if(compansationAwardPath.isNotEmpty){
              if(nikahNamaPath.isNotEmpty){
                if(accumulativeServicePath.isNotEmpty){
                  if(selectedMarriageCategory == constants.marriageDaughter) {
                    if(selectedChildID.isNotEmpty) {
                      CheckCConnectivity();
                    }else{
                      uiUpdates.ShowToast(Strings.instance.selectedChild);
                    }
                  }else{
                    CheckCConnectivity();
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.accumulativeServiceMessage);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.nikahNamaMessage);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.dcSelectCompansationAward);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.dcAffaiadavitNoClaim);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.selectServiceCertificate);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.husbandNameMessage);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectedCategory);
    }
  }

  void CheckCConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddMarriageClaim()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddMarriageClaim() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.claims+"marriage_claim";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['emp_id'] = UserSessions.instance.getEmployeeID;
    request.fields['comp_id'] =comp_id;
    request.fields['user_id'] = UserSessions.instance.getUserID;
    // Token now sent in Authorization header, not in fields
    APIService.addAuthHeaderToMultipartRequest(request);
    request.fields['child_id'] = selectedChildID;
    request.fields['category'] = selectedMarriageCategory;
    request.fields['husband'] = husbandNameController.text.toString();
    request.fields['marriage_date'] = selectedMarriageDate;
    request.files.add(
        http.MultipartFile(
            'certificate',
            File(serviceCertificateFilePath).readAsBytes().asStream(),
            File(serviceCertificateFilePath).lengthSync(),
            filename: serviceCertificateFilePath.split("/").last
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
            'award',
            File(compansationAwardPath).readAsBytes().asStream(),
            File(compansationAwardPath).lengthSync(),
            filename: compansationAwardPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'nikahnama',
            File(nikahNamaPath).readAsBytes().asStream(),
            File(nikahNamaPath).lengthSync(),
            filename: nikahNamaPath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile(
            'service',
            File(accumulativeServicePath).readAsBytes().asStream(),
            File(accumulativeServicePath).lengthSync(),
            filename: accumulativeServicePath.split("/").last
        )
    );

    var response = await request.send();
    uiUpdates.DismissProgresssDialog();
    try {
      final resp = await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.marriageClaimRequestMessage);
          Navigator.of(context).pop(true);
        } else {
          uiUpdates.ShowToast(Strings.instance.failedMarriageClaim);
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
    List<String> tagsList= [constants.accountInfo, constants.empChildren,constants.companiesInfo];
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
        var account= data["account"];
        List<dynamic> childrens= account["emp_children"];
        String empID= account["emp_id"].toString();
        comp_id=account["comp_id"].toString();
        UserSessions.instance.setEmployeeID(empID);

        ///childrens
        if(childrens.length > 0){
          childrens.forEach((element) {
            childModelList.add(new ChildModel(element["child_id"], element["child_name"]));
          });
        }
        ///get companies
        List<dynamic> entitlementsCompanies = data['companies'];
        if (entitlementsCompanies.length > 0) {
          entitlementsCompanies.forEach((row) {
            String comp_id = row["comp_id"].toString();
            String comp_name = row["comp_name"].toString();
            companiesList.add(new CompanyModel(comp_id, comp_name));
          });
        }
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
        selectedMarriageDate= selectedDate.toString();
      });
  }
}
