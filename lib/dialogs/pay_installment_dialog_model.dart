import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/center_text_list_item.dart';
import 'package:wwf_apps/models/CityModel.dart';
import 'package:wwf_apps/models/InstallmentModel.dart';
import 'package:wwf_apps/models/PayInstallmentDeatailModel.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';

import 'banks_dialog_model.dart';

class PayInstalmentDialogModel extends StatefulWidget {
  InstallmentModel installmentModel;

  PayInstalmentDialogModel(this.installmentModel);

  @override
  _PayInstalmentDialogModelState createState() => _PayInstalmentDialogModelState();
}

TextEditingController remarksController= new TextEditingController();

class _PayInstalmentDialogModelState extends State<PayInstalmentDialogModel> {
  String selectedBankName= Strings.instance.selectBankName;
  String challanFilePath="", challanFileName="Select Challan";
  Constants constants;
  UIUpdates uiUpdates;
  
  @override
  void initState() {
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    remarksController.clear();
  }

  @override
  void dispose() {
    remarksController.clear();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.85),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.colors.newPrimary,
                      AppTheme.colors.newPrimary.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.payment,
                        color: AppTheme.colors.newWhite,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.installmentModel.ins_number ?? "Pay Installment",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 16,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Amount: ${widget.installmentModel.ins_amount ?? "0.00"} PKR",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite.withOpacity(0.9),
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: AppTheme.colors.newWhite,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bank Selection
                      Text(
                        "Bank Name",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            OpenBankDialog(context).then((value) {
                              if(value != null){
                                setState(() {
                                  selectedBankName = value;
                                });
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.colors.newWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedBankName == Strings.instance.selectBankName
                                    ? AppTheme.colors.colorDarkGray.withOpacity(0.3)
                                    : AppTheme.colors.newPrimary.withOpacity(0.5),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  color: selectedBankName == Strings.instance.selectBankName
                                      ? AppTheme.colors.colorDarkGray
                                      : AppTheme.colors.newPrimary,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    selectedBankName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selectedBankName == Strings.instance.selectBankName
                                          ? AppTheme.colors.colorDarkGray
                                          : AppTheme.colors.newBlack,
                                      fontSize: 14,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppTheme.colors.newPrimary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Remarks Field
                      Text(
                        "Remarks",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: remarksController,
                          cursorColor: AppTheme.colors.newPrimary,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.colors.newBlack,
                            fontFamily: "AppFont",
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter remarks (optional)",
                            hintStyle: TextStyle(
                              fontFamily: "AppFont",
                              color: AppTheme.colors.colorDarkGray,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // File Picker
                      Text(
                        "Challan Document",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 13,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            OpenFilePicker();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: challanFilePath.isEmpty
                                  ? AppTheme.colors.newWhite
                                  : AppTheme.colors.colorExelent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: challanFilePath.isEmpty
                                    ? AppTheme.colors.colorDarkGray.withOpacity(0.3)
                                    : AppTheme.colors.colorExelent.withOpacity(0.5),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  challanFilePath.isEmpty ? Icons.upload_file : Icons.check_circle,
                                  color: challanFilePath.isEmpty
                                      ? AppTheme.colors.colorDarkGray
                                      : AppTheme.colors.colorExelent,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        challanFileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: challanFilePath.isEmpty
                                              ? AppTheme.colors.colorDarkGray
                                              : AppTheme.colors.newBlack,
                                          fontSize: 14,
                                          fontFamily: "AppFont",
                                          fontWeight: challanFilePath.isEmpty
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                      if (challanFilePath.isNotEmpty)
                                        SizedBox(height: 2),
                                      if (challanFilePath.isNotEmpty)
                                        Text(
                                          "Tap to change",
                                          style: TextStyle(
                                            color: AppTheme.colors.colorDarkGray,
                                            fontSize: 11,
                                            fontFamily: "AppFont",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppTheme.colors.newPrimary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Submit Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Validation();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.colors.newPrimary,
                                  AppTheme.colors.newPrimary.withOpacity(0.85),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.colors.newPrimary.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppTheme.colors.newWhite,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Submit Payment",
                                  style: TextStyle(
                                    color: AppTheme.colors.newWhite,
                                    fontSize: 15,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
    if (status.isDenied || status.isLimited || status.isPermanentlyDenied || status.isRestricted) {
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
        challanFileName = file.name;
        challanFilePath = file.path;
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void Validation() {
    if(selectedBankName == Strings.instance.selectBankName){
      uiUpdates.ShowToast("Please select a bank");
      return;
    }
    
    if(challanFilePath.isEmpty){
      uiUpdates.ShowToast("Please select a challan document");
      return;
    }
    
    CheckConnection();
  }

  void CheckConnection() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        SendData(),
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  SendData() {
    PayInstallmentDetailModel detailModel= new PayInstallmentDetailModel(selectedBankName, challanFilePath);
    Navigator.of(context).pop(detailModel);
  }
}
