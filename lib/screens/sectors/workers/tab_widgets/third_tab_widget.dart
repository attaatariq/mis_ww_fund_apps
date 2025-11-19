import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/sectors/workers/WorkerForm.dart';
import 'package:wwf_apps/screens/home/employee/employee_home.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class WorkerThirdTab extends StatefulWidget {

  final parentFunction;

  WorkerThirdTab(this.parentFunction);

  @override
  _WorkerThirdTabState createState() => _WorkerThirdTabState();
}

class _WorkerThirdTabState extends State<WorkerThirdTab> {
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
    constants = new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
        color: AppTheme.colors.newWhite,
        child: ListView(
          children: [

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CNIC Upload*",
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
                            child: Text("Select",
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SSN File Upload*",
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
                            child: Text("Select",
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
                      Text("EOBI File Upload*",
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
                            child: Text("Select",
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Appointment Letter Upload*",
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
                            child: Text("Select",
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
                      Text("Affidavit Upload*",
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
                            child: Text("Select",
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reg. Certificate Upload*",
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
                            child: Text("Select",
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
                      Text("IRA 2012 Upload*",
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
                            child: Text("Select",
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

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Factory Card Upload*",
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
                            child: Text("Select",
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
                                color: AppTheme.colors.newWhite,
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
      SetFilePosition(file, position);
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void SetFilePosition(PlatformFile file, int position) {
    if(position == 1){
      setState(() {
        cnicFileName= file.name;
        cnicFilePath= file.path;
      });
    }else if(position == 2){
      setState(() {
        ssnFileName= file.name;
        ssnFilePath= file.path;
      });
    }else if(position == 3){
      setState(() {
        eobiFileName= file.name;
        eobiFilePath= file.path;
      });
    }else if(position == 4){
      setState(() {
        appointmentLetterFileName= file.name;
        appointmentLetterFilePath= file.path;
      });
    }else if(position == 5){
      setState(() {
        affidavitFileName= file.name;
        affidavitFilePath= file.path;
      });
    }else if(position == 6){
      setState(() {
        regCertificateFileName= file.name;
        regCertificateFilePath= file.path;
      });
    }else if(position == 7){
      setState(() {
        ira2012FileName= file.name;
        ira2012FilePath= file.path;
      });
    }else if(position == 8){
      setState(() {
        factoryCardFileName= file.name;
        factoryCardFilePath= file.path;
      });
    }
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
        AddEmployee()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddEmployee() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog("Please Wait...");
    var url = constants.getApiBaseURL()+constants.employees+"create";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['comp_id'] = WorkerForm.companyWorkerInformationModel.selectedCompanyID;
    request.fields['father'] = WorkerForm.companyWorkerInformationModel.fatherName;
    request.fields['about'] = WorkerForm.companyWorkerInformationModel.designation;
    request.fields['ssno'] = WorkerForm.companyWorkerInformationModel.ssnNumber;
    request.fields['eobino'] = WorkerForm.companyWorkerInformationModel.eobiNumber;
    request.fields['appoint_date'] = WorkerForm.companyWorkerInformationModel.appointDate;
    request.fields['scale'] = WorkerForm.companyWorkerInformationModel.payScale;
    request.fields['disability'] = WorkerForm.companyWorkerInformationModel.selectedDisability;
    request.fields['cnic_issued'] = WorkerForm.companyWorkerInformationModel.cnicIssueDate;
    request.fields['cnic_expiry'] = WorkerForm.companyWorkerInformationModel.cnicExpiryDate;
    request.fields['birthday'] = WorkerForm.companyWorkerInformationModel.selectedDOB;
    request.fields['address'] = WorkerForm.companyWorkerInformationModel.address;
    request.fields['city'] = WorkerForm.companyWorkerInformationModel.selectedCityID;
    request.fields['district'] = WorkerForm.companyWorkerInformationModel.selectedDistrictID;
    request.fields['province'] = WorkerForm.companyWorkerInformationModel.selectedProvinceID;
    request.fields['bank'] = WorkerForm.companyWorkerBankInformationModel.selectedBank;
    request.fields['account_title'] = WorkerForm.companyWorkerBankInformationModel.accountTitle;
    request.fields['account_no'] = WorkerForm.companyWorkerBankInformationModel.accountNumber;
    request.fields['latitude'] = WorkerForm.companyWorkerInformationModel.latitude;
    request.fields['longitude'] = WorkerForm.companyWorkerInformationModel.longitude;

    request.files.add(
        http.MultipartFile('ssn_upload',
            File(ssnFilePath).readAsBytes().asStream(),
            File(ssnFilePath).lengthSync(),
            filename: ssnFilePath.split("/").last
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
        http.MultipartFile('affidavit_upload',
            File(affidavitFilePath).readAsBytes().asStream(),
            File(affidavitFilePath).lengthSync(),
            filename: affidavitFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('certificate_upload',
            File(regCertificateFilePath).readAsBytes().asStream(),
            File(regCertificateFilePath).lengthSync(),
            filename: regCertificateFilePath.split("/").last
        )
    );
    request.files.add(
        http.MultipartFile('prescribed_upload',
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

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}
