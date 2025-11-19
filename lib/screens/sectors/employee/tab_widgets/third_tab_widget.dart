import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/home/employee/employee_home.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class WWFEmployeeThirdTab extends StatefulWidget {

  final parentFunction;

  WWFEmployeeThirdTab(this.parentFunction);

  @override
  _WWFEmployeeThirdTabState createState() => _WWFEmployeeThirdTabState();
}

class _WWFEmployeeThirdTabState extends State<WWFEmployeeThirdTab> {
  String userName='';
  String userCNIC='';
  String userGender='';
  String userEmail='';
  String userContact='';

  String cnicFilePath="", cnicFileName=Strings.instance.uploadCnic;
  String ssnFilePath="", ssnFileName=Strings.instance.uploadSSnFile;
  String eobiFilePath="", eobiFileName=Strings.instance.uploadEobiFile;
  String appointmentLetterFilePath="", appointmentLetterFileName=Strings.instance.uploadAppointmentLetter;
  String affidavitFilePath="", affidavitFileName=Strings.instance.uploadAffidavit;
  String regCertificateFilePath="", regCertificateFileName=Strings.instance.uploadRegistrationCertificate;
  String ira2012FilePath="", ira2012FileName=Strings.instance.uploadIRA2012;
  String factoryCardFilePath="", factoryCardFileName=Strings.instance.uploadFactoryCard;
  UIUpdates uiUpdates;
  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 15),
      color: AppTheme.colors.newWhite,
      child: SingleChildScrollView(
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cnicFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(1);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ssnFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(2);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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
              ],
            ),

            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(eobiFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(3);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointmentLetterFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(4);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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
              ],
            ),

            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(affidavitFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(5);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(regCertificateFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(6);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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
              ],
            ),

            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ira2012FileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(7);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(factoryCardFileName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          OpenFilePicker(8);
                        },
                        child: Container(
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Choose File",
                              style: TextStyle(
                                  color: AppTheme.colors.white,
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
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: 30, bottom: 60),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        widget.parentFunction(4);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                        ),
                        child: Center(
                          child: Text("Back",
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
                  ),

                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        Validayion();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 45,
                        color: AppTheme.colors.newPrimary,
                        child: Center(
                          child: Text("Save",
                            style: TextStyle(
                                color: AppTheme.colors.white,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void OpenFilePicker(int from) async{
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
      SetRelatedFileData(file, from);
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void SetRelatedFileData(PlatformFile selectedFile, int from) {
    if(from == 1)
    {
        cnicFileName= selectedFile.name;
        cnicFilePath= selectedFile.path;
    }else if(from  == 2)
    {
      ssnFileName= selectedFile.name;
      ssnFilePath= selectedFile.path;
    }else if(from  == 3)
    {
      eobiFileName= selectedFile.name;
      eobiFilePath= selectedFile.path;
    }else if(from  == 4)
    {
      appointmentLetterFileName= selectedFile.name;
      appointmentLetterFilePath= selectedFile.path;
    }else if(from  == 5)
    {
      affidavitFileName= selectedFile.name;
      affidavitFilePath= selectedFile.path;
    }else if(from  == 6)
    {
      regCertificateFileName= selectedFile.name;
      regCertificateFilePath= selectedFile.path;
    }else if(from  == 7)
    {
      ira2012FileName= selectedFile.name;
      ira2012FilePath= selectedFile.path;
    }else if(from  == 8)
    {
      factoryCardFileName= selectedFile.name;
      factoryCardFilePath= selectedFile.path;
    }

    setState(() {
    });
  }

  void Validayion() {
    if(cnicFilePath.isNotEmpty){
      if(ssnFilePath.isNotEmpty){
        if(eobiFilePath.isNotEmpty){
          if(appointmentLetterFilePath.isNotEmpty){
            if(affidavitFilePath.isNotEmpty){
              if(regCertificateFilePath.isNotEmpty){
                if(ira2012FilePath.isNotEmpty){
                  if(factoryCardFilePath.isNotEmpty){
                    CheckConnectivity();
                  }else{
                    uiUpdates.ShowToast(Strings.instance.uploadFactoryCard);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.uploadIRA2012);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.uploadRegistrationCertificate);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.uploadAffidavit);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.uploadAppointmentLetter);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.uploadEobiFile);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.uploadSSnFile);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.uploadCnic);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddWWFEmployee()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddWWFEmployee() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog("Please Wait...");
    var url = constants.getApiBaseURL()+constants.employees+"create";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = UserSessions.instance.getUserID;//
    request.fields['comp_id'] = WorkerForm.companyWorkerInformationModel.selectedCompanyID;//
    request.fields['father'] = WorkerForm.companyWorkerInformationModel.fatherName;//
    request.fields['about'] = WorkerForm.companyWorkerInformationModel.designation;//
    request.fields['ssno'] = WorkerForm.companyWorkerInformationModel.ssnNumber;//
    request.fields['eobino'] = WorkerForm.companyWorkerInformationModel.eobiNumber;//
    request.fields['appointed'] = WorkerForm.companyWorkerInformationModel.appointDate;//
    request.fields['scale'] = WorkerForm.companyWorkerInformationModel.payScale;//
    request.fields['disable'] = WorkerForm.companyWorkerInformationModel.selectedDisability;//
    request.fields['issued'] = WorkerForm.companyWorkerInformationModel.cnicIssueDate;//
    request.fields['expiry'] = WorkerForm.companyWorkerInformationModel.cnicExpiryDate;//
    request.fields['birthday'] = WorkerForm.companyWorkerInformationModel.selectedDOB;//
    request.fields['address'] = WorkerForm.companyWorkerInformationModel.address;//
    request.fields['city'] = WorkerForm.companyWorkerInformationModel.selectedCityID;//
    request.fields['district'] = WorkerForm.companyWorkerInformationModel.selectedDistrictID;//
    request.fields['province'] = WorkerForm.companyWorkerInformationModel.selectedProvinceID;//
    request.fields['bank_name'] = WorkerForm.companyWorkerBankInformationModel.selectedBank;//
    request.fields['account_title'] = WorkerForm.companyWorkerBankInformationModel.accountTitle;//
    request.fields['account_no'] = WorkerForm.companyWorkerBankInformationModel.accountNumber;
    request.fields['account_type'] = WorkerForm.companyWorkerBankInformationModel.accountType;
    request.fields['latitude'] = WorkerForm.companyWorkerInformationModel.latitude;//
    request.fields['longitude'] = WorkerForm.companyWorkerInformationModel.longitude;//
    request.fields['name'] = userName;//
    request.fields['cnicno'] = userCNIC;//
    request.fields['gender'] = userGender;//
    request.fields['email'] = userEmail;//
    request.fields['contact'] = userContact;//
    List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(WorkerForm.companyWorkerInformationModel.latitude),
        double.parse(WorkerForm.companyWorkerInformationModel.longitude));
    request.fields['lladdress'] = placemarks.first.street??''+", "+placemarks.first.thoroughfare??''+", "+placemarks.first.locality??''+", "+placemarks.first.country??"";//

    /// type,  lladdress  , user_image
    request.files.add(
        http.MultipartFile('ssn_upload',
            File(ssnFilePath).readAsBytes().asStream(),
            File(ssnFilePath).lengthSync(),
            filename: ssnFilePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile('user_image',
            File(eobiFilePath).readAsBytes().asStream(),
            File(eobiFilePath).lengthSync(),
            filename: eobiFilePath.split("/").last
        )
    );

    request.files.add(
        http.MultipartFile('eobi_upload',
            File(eobiFilePath).readAsBytes().asStream(),
            File(eobiFilePath).lengthSync(),
            filename: eobiFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('cnic_upload',
            File(cnicFilePath).readAsBytes().asStream(),
            File(cnicFilePath).lengthSync(),
            filename: cnicFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('letter_upload',
            File(appointmentLetterFilePath).readAsBytes().asStream(),
            File(appointmentLetterFilePath).lengthSync(),
            filename: appointmentLetterFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('affi_upload',
            File(affidavitFilePath).readAsBytes().asStream(),
            File(affidavitFilePath).lengthSync(),
            filename: affidavitFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('reg_upload',
            File(regCertificateFilePath).readAsBytes().asStream(),
            File(regCertificateFilePath).lengthSync(),
            filename: regCertificateFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('ira_upload',
            File(ira2012FilePath).readAsBytes().asStream(),
            File(ira2012FilePath).lengthSync(),
            filename: ira2012FilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('card_upload',
            File(factoryCardFilePath).readAsBytes().asStream(),
            File(factoryCardFilePath).lengthSync(),
            filename: factoryCardFilePath.split("/").last
        )
    );

    APIService.addAuthHeaderToMultipartRequest(request);
    var response = await request.send();
    try{
      final resp= await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.loginSuccess);
          UserSessions.instance.setUserAccount("1");
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => EmployeeHome(),
            ),
                (route) => false,
          );
        } else {
          uiUpdates.ShowToast(Strings.instance.employeeAddFailed);
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    }catch(e){
      uiUpdates.DismissProgresssDialog();
    }
  }

  GetInformation() async{

    List<String> tagsList= [constants.accountInfo];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data);
    
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var account= data["account"];
         userName=account['user_name'];
         userCNIC=account['user_cnic'];
         userGender=account['user_gender'];
         userEmail=account['user_email'];
         userContact=account['user_contact'];
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
