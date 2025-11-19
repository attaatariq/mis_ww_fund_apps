import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/banks_dialog_model.dart';
import 'package:welfare_claims_app/models/InstallmentModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/annex3A.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class PayInstallment extends StatefulWidget {
  InstallmentModel installmentModel;

  PayInstallment(this.installmentModel);

  @override
  _PayInstallmentState createState() => _PayInstallmentState();
}

TextEditingController remarksController= new TextEditingController();
TextEditingController insChallanNoController= new TextEditingController();

class _PayInstallmentState extends State<PayInstallment> {
  String selectedBankName= Strings.instance.selectBankName, ins_amount= "0", ins_payment= "0", ins_balance= "0";
  String challanFilePath="", challanFileName="Select Challan", depositedDate= Strings.instance.depositedDate;
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
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
                          child: Text(widget.installmentModel.ins_number,
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
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    InkWell(
                      onTap: (){
                        OpenBankDialog(context).then((value) {
                          if(value != null){
                            setState(() {
                              selectedBankName = value;
                            });
                          }
                        });
                      },
                      child: Container(
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
                                              child: Text(selectedBankName,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: selectedBankName == Strings.instance.selectBankName ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(widget.installmentModel.ins_amount +" PKR(Amount)",
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newBlack,
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(widget.installmentModel.ins_amount+" PKR(Payment)",
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newBlack,
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("0.00 PKR(Balance)",
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppTheme.colors.newBlack,
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

                    InkWell(
                      onTap: (){
                        _selectDate(context);
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
                                              child: Text(depositedDate,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: depositedDate == Strings.instance.depositedDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

                    Container(
                      margin: EdgeInsets.only(top: 10),
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
                                        controller: challanNumberController,
                                        cursorColor: AppTheme.colors.newPrimary,
                                        keyboardType: TextInputType.text,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.colors.newBlack
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Challan No",
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

                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray, width: 1),
                      ),
                      height: 100,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: TextField(
                                  controller: remarksController,
                                  cursorColor: AppTheme.colors.newPrimary,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.done,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.colors.newBlack
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Remarks",
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

                    InkWell(
                      onTap: ()
                      {
                        OpenFilePicker();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                        ),
                        child: Center(
                          child: Text(challanFileName,
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
            )
          ],
        ),
      ),
    );
  }

  Future<String> OpenBankDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: BanksDialogModel(constants.GetBanksModel()),
          );
        }
    );
  }

  void OpenFilePicker() async{
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
        challanFileName = file.name;
        challanFilePath = file.path;
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
    MaterialColor myColorWhite = MaterialColor(constants.dateDialogText, color);
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
              primaryColorDark: myColorWhite,
              accentColor: myColorWhite,
            ),
            dialogBackgroundColor:Colors.white,
          ),
          child: child,
        );
      },);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        DateTime date = DateTime.parse(selectedDate.toString());
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        depositedDate = formatter.format(date);
      });
  }

  void Validation() async{
    if(selectedBankName != Strings.instance.selectBankName){
      if(depositedDate != Strings.instance.depositedDate){
        if(challanNumberController.text.toString().isNotEmpty){
          if(challanFilePath.isNotEmpty){
            CheckConnectivity();
          }else{
            uiUpdates.ShowToast(Strings.instance.uploadChallan);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.challanNoReq);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.depositedDate);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectBankName);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddInst()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  AddInst() async{
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    String remarks="";
    if(remarksController.text.toString().isNotEmpty){
      remarks= remarksController.text.toString();
    }else{
      remarks= "Remarks not available.";
    }
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "ins_id": widget.installmentModel.ins_id,
      "ins_amount": widget.installmentModel.ins_amount,
      "ins_payment": widget.installmentModel.ins_amount,
      "ins_balance": "0.00",
      "deposited_at": depositedDate,
      "ins_bank_name": selectedBankName,
      "ins_challan_no": challanNumberController.text.toString(),
      "ins_challan": challanFilePath,
      "ins_remarks": remarks,
    };
    var url = constants.getApiBaseURL()+constants.claims+"add_installment";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders(), encoding: Encoding.getByName("UTF-8"));
    print(response.body+" : "+response.statusCode.toString());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.successAddIns);
        Navigator.of(context).pop(true);
      } else {
        uiUpdates.ShowToast(Strings.instance.failedAddIns);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }
}
