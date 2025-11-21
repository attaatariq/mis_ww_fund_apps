import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/banks_dialog_model.dart';
import 'package:wwf_apps/models/InstallmentModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/utils/permission_handler.dart';

class PayInstallment extends StatefulWidget {
  InstallmentModel installmentModel;
  String claimType; // e.g., "Estate (Housing & Flats) Claim"
  String employeeName; // e.g., "Naeema Khan"
  String dueDate; // e.g., "2025-11-05"

  PayInstallment(this.installmentModel, {this.claimType = "Estate Claim", this.employeeName = "", this.dueDate = ""});

  @override
  _PayInstallmentState createState() => _PayInstallmentState();
}

TextEditingController remarksController= new TextEditingController();
TextEditingController challanNumberController= new TextEditingController();
TextEditingController paymentController= new TextEditingController();

class _PayInstallmentState extends State<PayInstallment> {
  String selectedBankName= Strings.instance.selectBankName, ins_amount= "0", ins_payment= "0", ins_balance= "0";
  String challanFilePath="", challanFileName="NO FILE AVAILABLE", depositedDate= Strings.instance.depositedDate;
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    // Initialize values from installment model
    ins_amount = widget.installmentModel.ins_amount ?? "0.00";
    ins_payment = widget.installmentModel.ins_payment ?? "0.00";
    ins_balance = widget.installmentModel.ins_balance ?? ins_amount;
    paymentController.text = ins_amount; // Pre-fill payment with amount
    remarksController.text = "Testing"; // Pre-fill description
    if (widget.dueDate.isEmpty && widget.installmentModel.ins_duedate != null) {
      widget.dueDate = widget.installmentModel.ins_duedate ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Pay Installment",
          ),
          
          // Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Field
                  _buildFormField(
                    label: "Amount*",
                    child: Text(
                      "${double.parse(ins_amount).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Payment Field
                  _buildFormField(
                    label: "Payment*",
                    child: TextField(
                      controller: paymentController,
                      cursorColor: AppTheme.colors.newPrimary,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.colors.newBlack,
                        fontFamily: "AppFont",
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter payment amount",
                        hintStyle: TextStyle(
                          fontFamily: "AppFont",
                          color: AppTheme.colors.colorDarkGray,
                        ),
                      ),
                      onChanged: (value) {
                        // Calculate balance
                        try {
                          double amount = double.parse(ins_amount);
                          double payment = value.isEmpty ? 0 : double.parse(value);
                          double balance = amount - payment;
                          setState(() {
                            ins_balance = balance.toStringAsFixed(2);
                          });
                        } catch (e) {
                          // Invalid input
                        }
                      },
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Balance Field
                  _buildFormField(
                    label: "Balance*",
                    child: Text(
                      "${double.parse(ins_balance).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Bank Name Field
                  _buildFormField(
                    label: "Bank Name*",
                    child: InkWell(
                      onTap: () {
                        OpenBankDialog(context).then((value) {
                          if(value != null){
                            setState(() {
                              selectedBankName = value;
                            });
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedBankName == Strings.instance.selectBankName 
                                  ? "-- Select --" 
                                  : selectedBankName,
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
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Challan No Field
                  _buildFormField(
                    label: "Challan No*",
                    child: TextField(
                      controller: challanNumberController,
                      cursorColor: AppTheme.colors.newPrimary,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.colors.newBlack,
                        fontFamily: "AppFont",
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter challan number",
                        hintStyle: TextStyle(
                          fontFamily: "AppFont",
                          color: AppTheme.colors.colorDarkGray,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Payment Date Field
                  _buildFormField(
                    label: "Payment Date*",
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            depositedDate == Strings.instance.depositedDate 
                                ? "mm/dd/yyyy" 
                                : _formatDate(depositedDate),
                            style: TextStyle(
                              color: depositedDate == Strings.instance.depositedDate 
                                  ? AppTheme.colors.colorDarkGray 
                                  : AppTheme.colors.newBlack,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: AppTheme.colors.newPrimary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Description Field
                  _buildFormField(
                    label: "Description*",
                    child: TextField(
                      controller: remarksController,
                      cursorColor: AppTheme.colors.newPrimary,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.colors.newBlack,
                        fontFamily: "AppFont",
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter description",
                        hintStyle: TextStyle(
                          fontFamily: "AppFont",
                          color: AppTheme.colors.colorDarkGray,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Payment Challan Field
                  _buildFormField(
                    label: "Payment Challan*",
                    child: InkWell(
                      onTap: () {
                        OpenFilePicker();
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.colorLightGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                challanFileName,
                                style: TextStyle(
                                  color: challanFileName == "NO FILE AVAILABLE" 
                                      ? AppTheme.colors.colorDarkGray.withOpacity(0.7)
                                      : AppTheme.colors.newBlack,
                                  fontSize: 14,
                                  fontFamily: "AppFont",
                                  fontWeight: challanFileName == "NO FILE AVAILABLE" 
                                      ? FontWeight.normal 
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (challanFileName != "NO FILE AVAILABLE")
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.colors.newPrimary,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: AppTheme.colors.colorLightGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 12),
                      
                      // Pay Now Button
                      ElevatedButton(
                        onPressed: () {
                          Validation();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.colors.colorAccent, // #363636
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                        ),
                        child: Text(
                          "Pay Now",
                          style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFormField({String label, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 13,
            fontFamily: "AppFont",
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.colors.colorDarkGray.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.contains("-")) {
        DateTime date = DateTime.parse(dateStr);
        return DateFormat('MM/dd/yyyy').format(date);
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
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
    try {
      // Check and request storage permission using centralized handler
      bool hasPermission = await ensureStoragePermission(context);
      if (!hasPermission) {
        uiUpdates.ShowError("Storage permission is required to select files. Please grant permission in app settings.");
        return;
      }
      
      FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ["pdf", "png", "jpeg", "jpg"]
      );

      if(result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.path != null && file.path.isNotEmpty) {
          setState(() {
            challanFileName = file.name;
            challanFilePath = file.path;
          });
          uiUpdates.ShowSuccess("File selected: ${file.name}");
        } else {
          uiUpdates.ShowError("Failed to get file path. Please try again.");
        }
      } else {
        // User cancelled file picker - no need to show error
      }
    } catch (e) {
      uiUpdates.ShowError("Error selecting file: ${e.toString()}");
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
            uiUpdates.ShowError(Strings.instance.uploadChallan);
          }
        }else{
          uiUpdates.ShowError(Strings.instance.challanNoReq);
        }
      }else{
        uiUpdates.ShowError(Strings.instance.depositedDate);
      }
    }else{
      uiUpdates.ShowError(Strings.instance.selectBankName);
    }
  }

  void CheckConnectivity() {
    constants.CheckConnectivity(context).then((value) {
      if(value){
        AddInst();
      }else{
        uiUpdates.ShowError(Strings.instance.internetNotConnected);
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
    
    String paymentAmount = paymentController.text.isNotEmpty 
        ? paymentController.text 
        : widget.installmentModel.ins_amount;
    
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "ins_id": widget.installmentModel.ins_id,
      "ins_amount": widget.installmentModel.ins_amount,
      "ins_payment": paymentAmount,
      "ins_balance": ins_balance,
      "deposited_at": depositedDate,
      "ins_bank_name": selectedBankName,
      "ins_challan_no": challanNumberController.text.toString(),
      "ins_challan": challanFilePath,
      "ins_remarks": remarks,
    };
    var url = constants.getApiBaseURL()+constants.claims+"add_installment";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders(), encoding: Encoding.getByName("UTF-8"));
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowSuccess(Strings.instance.successAddIns);
        Navigator.of(context).pop(true);
      } else {
        uiUpdates.ShowError(Strings.instance.failedAddIns);
      }
    } else {
      uiUpdates.ShowError(responseCodeModel.message);
    }
  }
}
