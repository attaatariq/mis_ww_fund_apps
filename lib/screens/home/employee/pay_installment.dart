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
import 'package:wwf_apps/themes/form_theme.dart';

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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            StandardHeader(
              title: "Pay Installment",
            ),
            
            // Form Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: bottomPadding + 20
                ),
                child: Column(
                  children: [
                    // Main Form Card Container
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(FormTheme.borderRadiusL),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Banner Section with Image
                                  Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(FormTheme.borderRadiusL),
                                        topRight: Radius.circular(FormTheme.borderRadiusL),
                                      ),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Banner Image Background
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(FormTheme.borderRadiusL),
                                            topRight: Radius.circular(FormTheme.borderRadiusL),
                                          ),
                                          child: Image.asset(
                                            "archive/images/banners/transact.png",
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              // Fallback gradient if image not found
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      AppTheme.colors.newPrimary,
                                                      AppTheme.colors.newPrimary.withOpacity(0.8),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        // Dark Overlay for better text readability
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.3),
                                                Colors.black.withOpacity(0.5),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(FormTheme.borderRadiusL),
                                              topRight: Radius.circular(FormTheme.borderRadiusL),
                                            ),
                                          ),
                                        ),
                                        // Text Overlay
                                        Positioned(
                                          left: 24,
                                          right: 24,
                                          bottom: 20,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Pay Installment",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontFamily: "AppFont",
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withOpacity(0.3),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              if (widget.claimType.isNotEmpty)
                                                Text(
                                                  widget.claimType,
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.9),
                                                    fontSize: 14,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.normal,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black.withOpacity(0.3),
                                                        offset: Offset(0, 1),
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Form Fields Section
                                  Padding(
                                    padding: EdgeInsets.all(FormTheme.spacingXXL),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Amount Field (Read-only)
                                        _buildModernFormField(
                                          label: "Amount*",
                                          child: Container(
                                            width: double.infinity,
                                            height: 52,
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            decoration: FormTheme.containerDecoration(),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.currency_rupee,
                                                  color: FormTheme.primaryColor,
                                                  size: 20,
                                                ),
                                                SizedBox(width: FormTheme.spacingS),
                                                Text(
                                                  "${double.parse(ins_amount).toStringAsFixed(2)}",
                                                  style: FormTheme.inputTextStyle.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: FormTheme.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Payment Field
                                        _buildModernFormField(
                                          label: "Payment*",
                                          child: TextFormField(
                                            controller: paymentController,
                                            cursorColor: FormTheme.primaryColor,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            style: FormTheme.inputTextStyle,
                                            decoration: FormTheme.inputDecoration(
                                              hint: "Enter payment amount",
                                              prefixIcon: Icons.payment,
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
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Balance Field (Read-only)
                                        _buildModernFormField(
                                          label: "Balance*",
                                          child: Container(
                                            width: double.infinity,
                                            height: 52,
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            decoration: FormTheme.containerDecoration(),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.account_balance_wallet,
                                                  color: FormTheme.secondaryColor,
                                                  size: 20,
                                                ),
                                                SizedBox(width: FormTheme.spacingS),
                                                Text(
                                                  "${double.parse(ins_balance).toStringAsFixed(2)}",
                                                  style: FormTheme.inputTextStyle.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: FormTheme.secondaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Bank Name Field
                                        _buildModernFormField(
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
                                            child: Container(
                                              width: double.infinity,
                                              height: 52,
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.account_balance,
                                                    color: selectedBankName == Strings.instance.selectBankName 
                                                        ? FormTheme.hintColor 
                                                        : FormTheme.primaryColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: FormTheme.spacingM),
                                                  Expanded(
                                                    child: Text(
                                                      selectedBankName == Strings.instance.selectBankName 
                                                          ? "Select Bank" 
                                                          : selectedBankName,
                                                      style: TextStyle(
                                                        color: selectedBankName == Strings.instance.selectBankName 
                                                            ? FormTheme.hintColor 
                                                            : FormTheme.secondaryColor,
                                                        fontSize: 14,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down_rounded,
                                                    color: FormTheme.hintColor,
                                                    size: 24,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Challan No Field
                                        _buildModernFormField(
                                          label: "Challan No*",
                                          child: TextFormField(
                                            controller: challanNumberController,
                                            cursorColor: FormTheme.primaryColor,
                                            keyboardType: TextInputType.text,
                                            style: FormTheme.inputTextStyle,
                                            decoration: FormTheme.inputDecoration(
                                              hint: "Enter challan number",
                                              prefixIcon: Icons.receipt,
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Payment Date Field
                                        _buildModernFormField(
                                          label: "Payment Date*",
                                          child: InkWell(
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 52,
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              decoration: FormTheme.containerDecoration(),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: depositedDate == Strings.instance.depositedDate 
                                                        ? FormTheme.hintColor 
                                                        : FormTheme.primaryColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: FormTheme.spacingM),
                                                  Expanded(
                                                    child: Text(
                                                      depositedDate == Strings.instance.depositedDate 
                                                          ? "Select Date" 
                                                          : _formatDate(depositedDate),
                                                      style: TextStyle(
                                                        color: depositedDate == Strings.instance.depositedDate 
                                                            ? FormTheme.hintColor 
                                                            : FormTheme.secondaryColor,
                                                        fontSize: 14,
                                                        fontFamily: "AppFont",
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Description Field
                                        _buildModernFormField(
                                          label: "Description*",
                                          child: TextFormField(
                                            controller: remarksController,
                                            cursorColor: FormTheme.primaryColor,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 3,
                                            style: FormTheme.inputTextStyle,
                                            decoration: FormTheme.inputDecoration(
                                              hint: "Enter description",
                                              prefixIcon: Icons.description,
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Payment Challan Field
                                        _buildModernFormField(
                                          label: "Payment Challan*",
                                          child: InkWell(
                                            onTap: () {
                                              OpenFilePicker();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 52,
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: challanFileName != "NO FILE AVAILABLE" 
                                                    ? FormTheme.primaryColor.withOpacity(0.05)
                                                    : FormTheme.backgroundColor,
                                                borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
                                                border: Border.all(
                                                  color: challanFileName != "NO FILE AVAILABLE" 
                                                      ? FormTheme.primaryColor.withOpacity(0.3)
                                                      : FormTheme.borderColor,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: FormTheme.primaryColor.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(FormTheme.borderRadiusS),
                                                    ),
                                                    child: Icon(
                                                      Icons.attach_file,
                                                      color: FormTheme.primaryColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: FormTheme.spacingM),
                                                  Expanded(
                                                    child: Text(
                                                      challanFileName == "NO FILE AVAILABLE" 
                                                          ? "Select File" 
                                                          : challanFileName,
                                                      style: TextStyle(
                                                        color: challanFileName == "NO FILE AVAILABLE" 
                                                            ? FormTheme.hintColor 
                                                            : FormTheme.secondaryColor,
                                                        fontSize: 14,
                                                        fontFamily: "AppFont",
                                                        fontWeight: challanFileName == "NO FILE AVAILABLE" 
                                                            ? FontWeight.normal 
                                                            : FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (challanFileName != "NO FILE AVAILABLE")
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: FormTheme.primaryColor,
                                                      size: 22,
                                                    )
                                                  else
                                                    Icon(
                                                      Icons.chevron_right,
                                                      color: FormTheme.hintColor,
                                                      size: 20,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingXXXL),
                                        
                                        // Submit Button - Full Width
                                        TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          duration: Duration(milliseconds: 600),
                                          curve: Curves.easeOut,
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: 0.95 + (0.05 * value),
                                              child: Opacity(
                                                opacity: value,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 52,
                                                  decoration: FormTheme.primaryButtonDecoration(),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Validation();
                                                      },
                                                      borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Pay Now",
                                                          style: FormTheme.buttonTextStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        
                                        SizedBox(height: FormTheme.spacingL),
                                        
                                        // Cancel Button - Full Width
                                        Container(
                                          width: double.infinity,
                                          height: 52,
                                          decoration: FormTheme.secondaryButtonDecoration(),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: FormTheme.primaryColor,
                                                    fontSize: 15,
                                                    fontFamily: "AppFont",
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
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
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildModernFormField({String label, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: FormTheme.spacingS),
          child: Text(
            label,
            style: FormTheme.labelStyle,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
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
