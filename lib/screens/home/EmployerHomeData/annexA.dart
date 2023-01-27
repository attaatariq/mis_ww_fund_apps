import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/banks_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/income_statement_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/logout_dialog.dart';
import 'package:welfare_claims_app/dialogs/month_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/payment_mode_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/year_dialog_model.dart';
import 'package:welfare_claims_app/models/MonthModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/home/EmployerHomeData/annex3A.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class AnnexA extends StatefulWidget {
  @override
  _AnnexAState createState() => _AnnexAState();
}

TextEditingController netProfitController= TextEditingController();
TextEditingController wppfAmountController= TextEditingController();
TextEditingController category1wORKERController= TextEditingController();
TextEditingController category2wORKERController= TextEditingController();
TextEditingController category3wORKERController= TextEditingController();
TextEditingController amountFix1CategoryController= TextEditingController();
TextEditingController amountFix2CategoryController= TextEditingController();
TextEditingController amountFix3CategoryController= TextEditingController();
TextEditingController amountPaidCompanyController= TextEditingController();
TextEditingController amountEarnedBotController= TextEditingController();
TextEditingController totalInterstController= TextEditingController();
TextEditingController investedByCoController= TextEditingController();
TextEditingController investedByBOTController= TextEditingController();
TextEditingController amountContributedController= TextEditingController();
TextEditingController challanNumberController= TextEditingController();
TextEditingController totalPaymentController= TextEditingController();

class _AnnexAState extends State<AnnexA> {
  String totalNumberofEmployees="", totalEmployeeCategoryAmount="";
  String selectedYear= Strings.instance.selectYear, selectedStatement= Strings.instance.selectStatement,
      selectedReceivedDate = Strings.instance.selectReceivedDate, selectFinancialYear = Strings.instance.selectFinancialYear,
      selectClosingMonth=Strings.instance.selectClosingMonth, selectModeOfPayment=Strings.instance.selectModeOfPayment,
      selectBankName= Strings.instance.selectBankName, selectedPaymentDate = Strings.instance.selectPaymentDate;
  String selectedClosingMonthNo="";
  String logoFilePath="", logoFileName="Upload Challan";
  var numberMask = new MaskTextInputFormatter(mask: '###########',);
  List<String> yearsModelList= [];
  UIUpdates uiUpdates;
  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUpdates= new UIUpdates(context);
    constants= new Constants();
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.appBlackColors,
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
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.white, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Add Annex-A",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.white,
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
                margin: EdgeInsets.only(left: 30, right: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          OpenYearDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectedYear = value;
                              });
                            }
                          });
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
                                                child: Text(selectedYear,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedYear == Strings.instance.selectYear ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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

                      InkWell(
                        onTap: (){
                          OpenStatementDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectedStatement = value;
                              });
                            }
                          });
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
                                                child: Text(selectedStatement,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedStatement == Strings.instance.selectStatement ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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

                      InkWell(
                        onTap: (){
                          _selectDate(context, 0);
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
                                                child: Text(selectedReceivedDate,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedReceivedDate == Strings.instance.selectReceivedDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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
                        onTap: (){
                          OpenYearDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectFinancialYear = value;
                              });
                            }
                          });
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
                                                child: Text(selectFinancialYear,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectFinancialYear == Strings.instance.selectFinancialYear ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: netProfitController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Net Profit",
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
                                          controller: wppfAmountController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "WPPF Amount",
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
                                          controller: category1wORKERController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Category 1 Worker",
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
                                          controller: category2wORKERController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Category 2 Worker",
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
                                          controller: category3wORKERController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Category 3 Worker",
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
                                          controller: amountFix1CategoryController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Category 1 Amount",
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
                                          controller: amountFix2CategoryController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Category 2 Amount",
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
                                          controller: amountFix3CategoryController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Category 3 Amount",
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
                                          controller: amountPaidCompanyController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Amount Paid by Company",
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
                                          controller: amountEarnedBotController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Amount Earned/Paid by BOT",
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
                                          controller: totalInterstController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Total Interest",
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
                          OpenMonthDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectClosingMonth = value.monthName;
                                selectedClosingMonthNo= value.monthNumber;
                              });
                            }
                          });
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
                                                child: Text(selectClosingMonth,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectClosingMonth == "Select Closing Month" ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: investedByCoController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Invested by CO",
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
                                          controller: investedByBOTController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Invested by BOT",
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
                                          controller: amountContributedController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Amount Contributed",
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
                          OpenPaymentModeDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectModeOfPayment = value;
                              });
                            }
                          });
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
                                                child: Text(selectModeOfPayment,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectModeOfPayment == Strings.instance.selectModeOfPayment ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: challanNumberController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Challan Number",
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
                          OpenBankDialog(context).then((value) {
                            if(value != null){
                              setState(() {
                                selectBankName = value;
                              });
                            }
                          });
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
                                                child: Text(selectBankName,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectBankName == "Bank Name" ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: totalPaymentController,
                                          cursorColor: AppTheme.colors.newPrimary,
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.colors.white
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Total Payment",
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
                                                child: Text(selectedPaymentDate,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedPaymentDate == Strings.instance.selectPaymentDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.white,
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
                          OpenFilePicker();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.colors.white, width: 1,)
                          ),
                          child: Center(
                            child: Text(logoFileName,
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

                      InkWell(
                        onTap: (){
                          CheckConnectivity();
                          //Validation();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15, bottom: 60),
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Add",
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> OpenYearDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: YearsDialogModel(constants.GetYearModel()),
          );
        }
    );
  }

  Future<String> OpenStatementDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: IncomeStatementDialogModel(),
          );
        }
    );
  }

  Future<String> OpenPaymentModeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: PaymentModeDialogModel(),
          );
        }
    );
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

    MaterialColor myColor = MaterialColor(0xFF2cc285, color);
    MaterialColor myColorWhite = MaterialColor(0xFFFFFFFF, color);
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
        if(position == 0) {
          selectedReceivedDate = selectedDate.toString();
        }else{
          selectedPaymentDate = selectedDate.toString();
        }
      });
  }

  Future<MonthModel> OpenMonthDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: MonthDialogModel(constants.GetMonthModel()),
          );
        }
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
        logoFileName= file.name;
        logoFilePath= file.path;
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void Validation() {
    if(selectedYear != Strings.instance.selectYear){
      if(selectedStatement != Strings.instance.selectStatement){
        if(selectedReceivedDate != Strings.instance.selectReceivedDate){
          if(selectFinancialYear != Strings.instance.selectFinancialYear){
            if(netProfitController.text.isNotEmpty){
              if(wppfAmountController.text.isNotEmpty){
                if(wppfAmountController.text.isNotEmpty){
                  if(category1wORKERController.text.isNotEmpty){
                    if(category2wORKERController.text.isNotEmpty){
                      if(category3wORKERController.text.isNotEmpty){
                        if(amountFix1CategoryController.text.isNotEmpty){
                          if(amountFix2CategoryController.text.isNotEmpty){
                            if(amountFix3CategoryController.text.isNotEmpty){
                              if(amountPaidCompanyController.text.isNotEmpty){
                                if(amountEarnedBotController.text.isNotEmpty){
                                  if(totalInterstController.text.isNotEmpty){
                                    if(selectClosingMonth != Strings.instance.selectClosingMonth){
                                      if(investedByCoController.text.isNotEmpty){
                                        if(investedByBOTController.text.isNotEmpty){
                                          if(amountContributedController.text.isNotEmpty){
                                            if(selectModeOfPayment != Strings.instance.selectModeOfPayment){
                                              if(challanNumberController.text.isNotEmpty){
                                                if(totalPaymentController.text.isNotEmpty){
                                                  if(selectBankName != Strings.instance.selectBankName){
                                                    if(selectedPaymentDate != Strings.instance.selectPaymentDate){
                                                      if(logoFilePath.isNotEmpty){
                                                        CheckConnectivity();
                                                      }else{
                                                        uiUpdates.ShowToast(Strings.instance.uploadChallan);
                                                      }
                                                    }else{
                                                      uiUpdates.ShowToast(Strings.instance.selectPaymentDate);
                                                    }
                                                  }else{
                                                    uiUpdates.ShowToast(Strings.instance.selectBankName);
                                                  }
                                                }else{
                                                  uiUpdates.ShowToast(Strings.instance.totalPaymentNotEmpty);
                                                }
                                              }else{
                                                uiUpdates.ShowToast(Strings.instance.chalanNumberNotEmpty);
                                              }
                                            }else{
                                              uiUpdates.ShowToast(Strings.instance.selectModeOfPayment);
                                            }
                                          }else{
                                            uiUpdates.ShowToast(Strings.instance.amountContributedNotEmpty);
                                          }
                                        }else{
                                          uiUpdates.ShowToast(Strings.instance.investedByBOTNotEmpty);
                                        }
                                      }else{
                                        uiUpdates.ShowToast(Strings.instance.investedByCONotEmpty);
                                      }
                                    }else{
                                      uiUpdates.ShowToast(Strings.instance.selectClosingMonth);
                                    }
                                  }else{
                                    uiUpdates.ShowToast(Strings.instance.totaInterstNotEmpty);
                                  }
                                }else{
                                  uiUpdates.ShowToast(Strings.instance.amountEarnedPaidBOTNotEmpty);
                                }
                              }else{
                                uiUpdates.ShowToast(Strings.instance.amountPaidCompanyNotEmpty);
                              }
                            }else{
                              uiUpdates.ShowToast(Strings.instance.category3AmountNotEmpty);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.category2AmountNotEmpty);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.category1AmountNotEmpty);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.category3WorkerNotEmpty);
                      }
                    }else{
                      uiUpdates.ShowToast(Strings.instance.category2WorkerNotEmpty);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.category1WorkerNotEmpty);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.wppfNotEmpty);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.wppfNotEmpty);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.netProfitNotEmpty);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.selectFinancialYear);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.selectReceivedDate);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectStatement);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectYear);
    }
  }

  void CheckConnectivity() async{
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        AddAnnexA()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }

  void AddAnnexA() async{
    totalNumberofEmployees = (int.parse(category1wORKERController.text.toString()) + int.parse(category2wORKERController.text.toString()) + int.parse(category3wORKERController.text.toString())).toString();
    totalEmployeeCategoryAmount= (int.parse(amountFix1CategoryController.text.toString()) + int.parse(amountFix2CategoryController.text.toString()) + int.parse(amountFix3CategoryController.text.toString())).toString();
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog("Please Wait...");
    var url = constants.getApiBaseURL()+constants.companies+"annexa";
    print(UserSessions.instance.getUserID+" : "+UserSessions.instance.getToken);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['comp_id'] = UserSessions.instance.getRefID;
    request.fields['user_id'] = UserSessions.instance.getUserID;
    request.fields['user_token'] = UserSessions.instance.getToken;
    request.fields['year'] = selectedYear;
    request.fields['statement'] = selectedStatement;
    request.fields['received'] = selectedReceivedDate;
    request.fields['financial'] = selectFinancialYear;
    request.fields['net_profit'] = netProfitController.text.toString();
    request.fields['allocated'] = wppfAmountController.text.toString();
    request.fields['count_cat1'] = category1wORKERController.text.toString();
    request.fields['count_cat2'] = category2wORKERController.text.toString();
    request.fields['count_cat3'] = category3wORKERController.text.toString();
    request.fields['amount1'] = amountFix1CategoryController.text.toString();
    request.fields['amount2'] = amountFix2CategoryController.text.toString();
    request.fields['amount3'] = amountFix3CategoryController.text.toString();
    request.fields['paid_com'] = amountPaidCompanyController.text.toString();

    request.fields['paid_bot'] = amountEarnedBotController.text.toString();
    request.fields['interest'] = totalInterstController.text.toString();
    request.fields['closing'] = selectedClosingMonthNo;
    request.fields['invest_co'] = investedByCoController.text.toString();
    request.fields['invest_bot'] = investedByBOTController.text.toString();
    request.fields['workers'] = totalNumberofEmployees;
    request.fields['dispense'] = totalEmployeeCategoryAmount;
    request.fields['transfered'] = amountContributedController.text.toString();
    request.fields['pay_mode'] = selectModeOfPayment;
    request.fields['challan_no'] = challanNumberController.text.toString();
    request.fields['bank'] = selectBankName;
    request.fields['payment'] = totalPaymentController.text.toString();
    request.fields['pay_date'] = selectedPaymentDate;
    request.files.add(
        http.MultipartFile(
            'proof',
            File(logoFilePath).readAsBytes().asStream(),
            File(logoFilePath).lengthSync(),
            filename: logoFilePath.split("/").last
        )
    );

    var response = await request.send();
    try{
      final resp= await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodes(response.statusCode);
      uiUpdates.DismissProgresssDialog();
      print(resp.body);
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.annexAAdded);
          var dataObject = body["Data"].toString();
          UserSessions.instance.setRefID(dataObject);
          Navigator.pop(context);
        } else {
          uiUpdates.ShowToast(Strings.instance.annexAFiled);
        }
      } else {
        var body = jsonDecode(resp.body);
        String message = body["Message"].toString();
        if(message == constants.expireToken){
          constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
        }else{
          uiUpdates.ShowToast(message);
        }
      }
    }catch(e){
      uiUpdates.DismissProgresssDialog();
      print(e);
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
