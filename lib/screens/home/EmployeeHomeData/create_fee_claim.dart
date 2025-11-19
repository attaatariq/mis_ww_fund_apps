import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/child_dialog_model.dart';
import 'package:welfare_claims_app/dialogs/claim_type_dialog_model.dart';
import 'package:welfare_claims_app/models/ChildModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;
import 'package:welfare_claims_app/network/api_service.dart';

class CreateFeeClaim extends StatefulWidget {
  String edu_living="", edu_mess="", edu_transport="", edu_nature="", edu_level="", stip_amount="0";

  CreateFeeClaim(this.edu_living, this.edu_mess, this.edu_transport, this.edu_nature, this.edu_level, this.stip_amount);

  @override
  _CreateFeeClaimState createState() => _CreateFeeClaimState();
}

TextEditingController transportCostCon= TextEditingController();
TextEditingController hostelRentCon= TextEditingController();
TextEditingController messChargesCon= TextEditingController();

TextEditingController tuitionFeeCon= TextEditingController();
TextEditingController regFeeCon= TextEditingController();
TextEditingController prospecFeeCon= TextEditingController();
TextEditingController securityFeeCon= TextEditingController();
TextEditingController libraryFeeCon= TextEditingController();
TextEditingController examFeeCon= TextEditingController();
TextEditingController computerFeeCon= TextEditingController();
TextEditingController spotsFeeCon= TextEditingController();
TextEditingController washingChargesCon= TextEditingController();
TextEditingController developementChargesCon= TextEditingController();
TextEditingController arrearsFeeCon= TextEditingController();
TextEditingController adjustChargesCon= TextEditingController();
TextEditingController reimbursmentCon= TextEditingController();
TextEditingController taxFeeCon= TextEditingController();
TextEditingController lateFeeFineCon= TextEditingController();
TextEditingController otherFineCon= TextEditingController();
TextEditingController otherChargesCon= TextEditingController();
TextEditingController otherFineRemarksCon= TextEditingController();
TextEditingController otherChargesRemarksCon= TextEditingController();

class _CreateFeeClaimState extends State<CreateFeeClaim> {
  String transportVoucherPath="", transportVoucherName=Strings.instance.transportVoucher, hostelVoucherPath="", hostelVoucherName=Strings.instance.hostelVoucher,
      applicationFormDocPath="", applicationFormDocName=Strings.instance.applicationFormDoc, resultCardDocPath="", resultCardDocName=Strings.instance.resultCardDoc,
      feeVoucherPath="", feeVoucherName=Strings.instance.feeVoucher;
  String selectedStartDate= Strings.instance.selectedStartedDate, selectedEndDate= Strings.instance.selectedEndedDate;
  String selectedChild= Strings.instance.selectedChild, selectedClaimType, selectedChildID="", companyID="";
  Constants constants;
  UIUpdates uiUpdates;
  List<ChildModel> childModelList= [];
  bool isTransport= false, isMessInclude= false, isDayScholar= false, isEducationAvailable= true;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    selectedClaimType= constants.calimSelf;
    SetSelfDefualtScreenView();
    GetInformation();
  }

  void SetSelfDefualtScreenView() {
    if(widget.edu_transport == "Yes"){
      isTransport= true;
    }else{
      isTransport= false;
    }

    if(widget.edu_mess == "Yes"){
      isMessInclude= true;
    }else{
      isMessInclude= false;
    }

    if(widget.edu_living == constants.dayScholar){
      isDayScholar= true;
    }else{
      isDayScholar= false;
    }
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
                      child: Text("Fee Claim",
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
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 60),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          ClaimTypeModeDialog(context).then((value) => {
                            setState(() {
                              if(value != null){
                                selectedClaimType= value;
                                if(selectedClaimType == constants.calimSelf){
                                  CheckEducationDetail(false, UserSessions.instance.getRefID);
                                }
                              }
                            })
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
                                                child: Text(selectedClaimType,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedClaimType == Strings.instance.selectedclaim ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                      
                      selectedClaimType == constants.claimChild ? InkWell(
                        onTap: (){
                          if(childModelList.length > 0) {
                            OpenChildDialog(context).then((value) =>
                            {
                              if(value != null){
                                setState(() {
                                  selectedChildID = value.id;
                                  selectedChild = value.name;
                                  CheckEducationDetail(true, selectedChildID);
                                })
                              }
                            });
                          }else{
                            uiUpdates.ShowToast(Strings.instance.addChildFirst);
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
                                                child: Text(selectedStartDate,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedStartDate == Strings.instance.selectedStartedDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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
                          _selectDate(context, 2);
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
                                                child: Text(selectedEndDate,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: selectedEndDate == Strings.instance.selectedEndedDate ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
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

                      isEducationAvailable ? Container(
                        child: Column(
                          children: [
                            Container(  ///// transport container
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),

                                  Container(
                                    height: 30,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppTheme.colors.newPrimary
                                    ),

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                        child: Text("Institute Fee Claim",
                                          textAlign: TextAlign.start,
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

                                  SizedBox(height: 10,),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: tuitionFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Tuition Fee",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: regFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Registration Fee",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: prospecFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Prospectus Fee",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: securityFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Security Fee",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: libraryFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Library Fee",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: examFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Examination Fee",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: computerFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Computer Fee",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: spotsFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Sports Fee",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: washingChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Washing Charges",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: developementChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Development Charges",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: arrearsFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Fee Arrears",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: adjustChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Adjustment Charges",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: reimbursmentCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Reimbursment",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: taxFeeCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Tax on Fee",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: lateFeeFineCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Late Fee Fine",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: otherFineCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Other Fine",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: otherChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Other Charges",
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
                                      ),

                                      SizedBox(width: 10,),

                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: otherFineRemarksCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.text,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Other Fine Remarks",
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
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
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
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: TextField(
                                                            controller: otherChargesRemarksCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.text,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Other Charges Remarks",
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
                                      ),

                                      SizedBox(width: 10,),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            isTransport ? Container(  ///// transport container
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),

                                  Container(
                                    height: 30,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppTheme.colors.newPrimary
                                    ),

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                        child: Text("Transport Claim",
                                          textAlign: TextAlign.start,
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

                                  SizedBox(height: 10,),

                                  Container(
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
                                                      controller: transportCostCon,
                                                      cursorColor: AppTheme.colors.newPrimary,
                                                      keyboardType: TextInputType.number,
                                                      maxLines: 1,
                                                      textInputAction: TextInputAction.next,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme.colors.newBlack
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: "Transport Cost",
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
                                        child: Text(transportVoucherName,
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
                                ],
                              ),
                            ) : Container(),

                            !isDayScholar ? Container( //// hostel and mess container
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),

                                  Container(
                                    height: 30,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppTheme.colors.newPrimary
                                    ),

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                        child: Text("Hostel & Mess Claim",
                                          textAlign: TextAlign.start,
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

                                  SizedBox(height: 10,),

                                  Container(
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
                                                      controller: hostelRentCon,
                                                      cursorColor: AppTheme.colors.newPrimary,
                                                      keyboardType: TextInputType.number,
                                                      maxLines: 1,
                                                      textInputAction: TextInputAction.next,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme.colors.newBlack
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: "Hostel Rent",
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

                                  isMessInclude ? Container(
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
                                                      controller: messChargesCon,
                                                      cursorColor: AppTheme.colors.newPrimary,
                                                      keyboardType: TextInputType.number,
                                                      maxLines: 1,
                                                      textInputAction: TextInputAction.next,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme.colors.newBlack
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: "Mess Charges",
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
                                  ) : Container(),

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
                                        child: Text(hostelVoucherName,
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
                                ],
                              ),
                            ) : Container(),

                            Container( //// attachments container
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),

                                  Container(
                                    height: 30,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppTheme.colors.newPrimary
                                    ),

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                        child: Text("Attachments",
                                          textAlign: TextAlign.start,
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
                                        child: Text(applicationFormDocName,
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
                                        child: Text(resultCardDocName,
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
                                        child: Text(feeVoucherName,
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
                                ],
                              ),
                            ),

                            SizedBox(height: 30,),

                            InkWell(
                              onTap: (){
                                Validation();
                              },
                              child: Material(
                                elevation: 10,
                                shadowColor: AppTheme.colors.colorLightGray,
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: AppTheme.colors.newPrimary,
                                      borderRadius: BorderRadius.circular(2)
                                  ),
                                  child: Center(
                                    child: Text("Create",
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
                      ) : Container()
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
        if(position == 1){
          selectedStartDate = selectedDate.toString();
        }else if(position == 2){
          selectedEndDate = selectedDate.toString();
        }
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

  Future<String> ClaimTypeModeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: ClaimTypeDialogModel(),
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
          transportVoucherName = file.name;
          transportVoucherPath = file.path;
        }else if(position == 2) {
          hostelVoucherName = file.name;
          hostelVoucherPath = file.path;
        }else if(position == 3) {
          applicationFormDocName = file.name;
          applicationFormDocPath = file.path;
        }else if(position == 4) {
          resultCardDocName = file.name;
          resultCardDocPath = file.path;
        }else if(position == 5) {
          feeVoucherName = file.name;
          feeVoucherPath = file.path;
        }
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  GetInformation() async{
    List<String> tagsList= [constants.accountInfo, constants.empChildren];
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "api_tags": jsonEncode(tagsList).toString(),
    };
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.authentication+"information";
    var response = await http.post(Uri.parse(url), body: data, headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        var accounts= data["account"];
        companyID= accounts["comp_id"];
        List<dynamic> childrens= accounts["emp_children"];
        ///childrens
        if(childrens.length > 0){
          childrens.forEach((element) {
            childModelList.add(new ChildModel(element["child_id"], element["child_name"]));
          });
        }
      } else {
        uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void CheckEducationDetail(bool isChildSelected, String refID) async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url;
    if(!isChildSelected) {
      url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "edu_check/", 
          UserSessions.instance.getUserID, 
          additionalPath: "emp_id--" + refID);
    }else {
      url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "edu_check/", 
          UserSessions.instance.getUserID, 
          additionalPath: "child_id--" + selectedChildID);
    }

    var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
        if(data != null){
          isEducationAvailable = true;
          widget.edu_living= data["edu_living"].toString();
          widget.edu_mess= data["edu_mess"].toString();
          widget.edu_transport= data["edu_transport"].toString();
          widget.edu_nature= data["edu_nature"].toString();
          widget.edu_level= data["edu_level"].toString();
          widget.stip_amount= data["stip_amount"].toString();
          setState(() {
            SetSelfDefualtScreenView();
          });
        }else{
          uiUpdates.DismissProgresssDialog();
          setState(() {
            isEducationAvailable = false;
          });
          if(!isChildSelected) {
            uiUpdates.ShowToast(Strings.instance.please_add_education_first);
          }else{
            uiUpdates.ShowToast(Strings.instance.please_add_child_education_first);
          }
        }
      } else {
        uiUpdates.DismissProgresssDialog();
        setState(() {
          isEducationAvailable = false;
        });
        if(!isChildSelected) {
          uiUpdates.ShowToast(Strings.instance.please_add_education_first);
        }else{
          uiUpdates.ShowToast(Strings.instance.please_add_child_education_first);
        }
      }
    } else {
      uiUpdates.DismissProgresssDialog();
      setState(() {
        isEducationAvailable = false;
      });
      if(!isChildSelected) {
        uiUpdates.ShowToast(Strings.instance.please_add_education_first);
      }else{
        uiUpdates.ShowToast(Strings.instance.please_add_child_education_first);
      }
    }
  }

  void CreateFeeClaim() async{
    uiUpdates.HideKeyBoard();
    int trannsportCost= 0, messCharges= 0;
    if(transportCostCon.text.toString() != ""){
      trannsportCost= int.parse(transportCostCon.text.toString());
    }
    if(messChargesCon.text.toString() != ""){
      messCharges= int.parse(messChargesCon.text.toString());
    }
    String totalClaimAmount = GetTotalClaimAmount(trannsportCost, messCharges);

    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL()+constants.claims+"fee_claim";
    var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['user_id'] = UserSessions.instance.getUserID;
      // Token now sent in Authorization header, not in fields
      APIService.addAuthHeaderToMultipartRequest(request);
      request.fields['emp_id'] = UserSessions.instance.getRefID;
      request.fields['company_1'] = companyID;
      if(selectedClaimType == constants.calimSelf) { /// data for self claim
        request.fields['child_id'] = "";
      }else{ /// data for child claim
        request.fields['child_id'] = selectedChildID;
      }
      request.fields['claim_category'] = selectedClaimType;
      request.fields['claim_from'] = selectedStartDate;
      request.fields['claim_to'] = selectedEndDate;
      request.fields['tuition_fee'] = tuitionFeeCon.text.toString();
      request.fields['reg_fee'] = regFeeCon.text.toString();
      request.fields['pros_fee'] = prospecFeeCon.text.toString();
      request.fields['security_fee'] = securityFeeCon.text.toString();
      request.fields['lib_fee'] = libraryFeeCon.text.toString();
      request.fields['exam_fee'] = examFeeCon.text.toString();
      request.fields['comp_fee'] = computerFeeCon.text.toString();
      request.fields['sports_fee'] = spotsFeeCon.text.toString();
      request.fields['wash_fee'] = washingChargesCon.text.toString();
      request.fields['dev_fee'] = developementChargesCon.text.toString();
      request.fields['fee_arrs'] = arrearsFeeCon.text.toString();
      request.fields['adjust_fee'] = adjustChargesCon.text.toString();
      request.fields['reimb_amount'] = reimbursmentCon.text.toString();
      request.fields['late_fee'] = lateFeeFineCon.text.toString();
      request.fields['fine_amount'] = otherFineCon.text.toString();
      request.fields['other_fee'] = otherChargesCon.text.toString();
      request.fields['remarks_fine'] = otherFineRemarksCon.text.toString();
      request.fields['remarks_other'] = otherChargesRemarksCon.text.toString();
      request.fields['transport_cost'] = trannsportCost.toString();
      if(!isDayScholar){
        request.fields['hostel_rent'] = hostelRentCon.text.toString();
        request.fields['hostel_mess'] = messCharges.toString();
      }else{
        request.fields['hostel_rent'] = "0";
        request.fields['hostel_mess'] = "0";
      }
      request.fields['fee_tax'] = taxFeeCon.text.toString();
      request.fields['total_amount'] = totalClaimAmount;

      //add files
      if(isTransport) {
        request.files.add(
            http.MultipartFile(
                'transport_voucher',
                File(transportVoucherPath).readAsBytes().asStream(),
                File(transportVoucherPath).lengthSync(),
                filename: transportVoucherPath
                    .split("/")
                    .last
            )
        );
      }else{
        request.fields['transport_voucher'] = "";
      }

      if(!isDayScholar && isMessInclude) {
        request.files.add(
            http.MultipartFile(
                'hostel_voucher',
                File(hostelVoucherPath).readAsBytes().asStream(),
                File(hostelVoucherPath).lengthSync(),
                filename: hostelVoucherPath
                    .split("/")
                    .last
            )
        );
      }else{
        request.fields['hostel_voucher'] = "";
      }

      request.files.add(
          http.MultipartFile(
              'application_form',
              File(applicationFormDocPath).readAsBytes().asStream(),
              File(applicationFormDocPath).lengthSync(),
              filename: applicationFormDocPath
                  .split("/")
                  .last
          )
      );

      request.files.add(
          http.MultipartFile(
              'result_card',
              File(resultCardDocPath).readAsBytes().asStream(),
              File(resultCardDocPath).lengthSync(),
              filename: resultCardDocPath
                  .split("/")
                  .last
          )
      );

      request.files.add(
          http.MultipartFile(
              'fee_voucher',
              File(feeVoucherPath).readAsBytes().asStream(),
              File(feeVoucherPath).lengthSync(),
              filename: feeVoucherPath
                  .split("/")
                  .last
          )
      );

    var response = await request.send();
    uiUpdates.DismissProgresssDialog();
    try {
      final resp = await http.Response.fromStream(response);
      ResponseCodeModel responseCodeModel= constants.CheckResponseCodesNew(response.statusCode, resp);
      uiUpdates.DismissProgresssDialog();
      if (responseCodeModel.status == true) {
        var body = jsonDecode(resp.body);
        String code = body["Code"].toString();
        if (code == "1") {
          uiUpdates.ShowToast(Strings.instance.beneficiaryMessage);
          Navigator.pop(context);
        } else {
          uiUpdates.ShowToast(Strings.instance.failedbeneficiary);
        }
      } else {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    }catch(e){
      uiUpdates.ShowToast(e);
    }
  }

  String GetTotalClaimAmount(int trannsportCost, int messCharges) {
    int totalAmount= int.parse(tuitionFeeCon.text.toString()) + int.parse(regFeeCon.text.toString()) +
        int.parse(prospecFeeCon.text.toString()) + int.parse(regFeeCon.text.toString()) + int.parse(prospecFeeCon.text.toString()) +
        int.parse(securityFeeCon.text.toString()) + int.parse(libraryFeeCon.text.toString()) + int.parse(examFeeCon.text.toString()) +
        int.parse(computerFeeCon.text.toString()) + int.parse(spotsFeeCon.text.toString()) + int.parse(washingChargesCon.text.toString()) +
        int.parse(developementChargesCon.text.toString()) + int.parse(arrearsFeeCon.text.toString()) + int.parse(adjustChargesCon.text.toString()) +
        int.parse(reimbursmentCon.text.toString()) + int.parse(taxFeeCon.text.toString()) + int.parse(lateFeeFineCon.text.toString()) +
        int.parse(otherFineCon.text.toString()) + int.parse(otherChargesCon.text.toString()) + trannsportCost + messCharges;

    return totalAmount.toString();
  }

  void Validation() {
    if(selectedStartDate != ""){
      if(selectedEndDate != ""){
        if(tuitionFeeCon.text.toString() != ""){
          if(regFeeCon.text.toString() != ""){
            if(prospecFeeCon.text.toString() != ""){
              if(securityFeeCon.text.toString() != ""){
                if(libraryFeeCon.text.toString() != ""){
                  if(examFeeCon.text.toString() != ""){
                    if(computerFeeCon.text.toString() != ""){
                      if(spotsFeeCon.text.toString() != ""){
                        if(washingChargesCon.text.toString() != ""){
                          if(developementChargesCon.text.toString() != ""){
                            if(arrearsFeeCon.text.toString() != ""){
                              if(adjustChargesCon.text.toString() != ""){
                                if(reimbursmentCon.text.toString() != ""){
                                  if(taxFeeCon.text.toString() != ""){
                                    if(lateFeeFineCon.text.toString() != ""){
                                      if(otherFineCon.text.toString() != ""){
                                        if(otherChargesCon.text.toString() != ""){
                                          if(otherFineRemarksCon.text.toString() != ""){
                                            if(otherChargesRemarksCon.text.toString() != ""){
                                              if(applicationFormDocPath != ""){
                                                if(resultCardDocPath != ""){
                                                  if(feeVoucherPath != ""){
                                                    if (!isDayScholar){
                                                      if (isMessInclude) {
                                                        if (hostelRentCon
                                                            .text
                                                            .toString() !=
                                                            "") {
                                                          if(hostelVoucherPath != null) {
                                                            if (isTransport) {
                                                              if (transportCostCon
                                                                  .text
                                                                  .toString() !=
                                                                  "") {
                                                                if (transportVoucherPath !=
                                                                    "") {
                                                                  if (selectedClaimType ==
                                                                      constants
                                                                          .claimChild) {
                                                                    /// data for self claim
                                                                    if (selectedChildID ==
                                                                        "") {
                                                                      CheckInternet();
                                                                    } else {
                                                                      uiUpdates
                                                                          .ShowToast(
                                                                          Strings
                                                                              .instance
                                                                              .selectChild);
                                                                    }
                                                                  } else {
                                                                    /// data for child claim
                                                                    CheckInternet();
                                                                  }
                                                                } else {
                                                                  uiUpdates
                                                                      .ShowToast(
                                                                      Strings
                                                                          .instance
                                                                          .transportVoucher);
                                                                }
                                                              } else {
                                                                uiUpdates
                                                                    .ShowToast(
                                                                    Strings
                                                                        .instance
                                                                        .selectTransPortCost);
                                                              }
                                                            } else {
                                                              if (selectedClaimType ==
                                                                  constants
                                                                      .claimChild) {
                                                                /// data for self claim
                                                                if (selectedChildID ==
                                                                    "") {
                                                                  CheckInternet();
                                                                } else {
                                                                  uiUpdates
                                                                      .ShowToast(
                                                                      Strings
                                                                          .instance
                                                                          .selectChild);
                                                                }
                                                              } else {
                                                                /// data for child claim
                                                                CheckInternet();
                                                              }
                                                            }
                                                          }else{
                                                            uiUpdates
                                                                .ShowToast(
                                                                Strings
                                                                    .instance
                                                                    .hostelVoucher);
                                                          }
                                                        } else {
                                                          uiUpdates
                                                              .ShowToast(
                                                              Strings
                                                                  .instance
                                                                  .selectMessCharges);
                                                        }
                                                      } else {
                                                        if (isTransport) {
                                                          if (transportCostCon
                                                              .text
                                                              .toString() !=
                                                              "") {
                                                            if (transportVoucherPath !=
                                                                "") {
                                                              if (selectedClaimType ==
                                                                  constants
                                                                      .claimChild) {
                                                                /// data for self claim
                                                                if (selectedChildID ==
                                                                    "") {
                                                                  CheckInternet();
                                                                } else {
                                                                  uiUpdates
                                                                      .ShowToast(
                                                                      Strings
                                                                          .instance
                                                                          .selectChild);
                                                                }
                                                              } else {
                                                                /// data for child claim
                                                                CheckInternet();
                                                              }
                                                            } else {
                                                              uiUpdates
                                                                  .ShowToast(
                                                                  Strings
                                                                      .instance
                                                                      .transportVoucher);
                                                            }
                                                          } else {
                                                            uiUpdates
                                                                .ShowToast(
                                                                Strings
                                                                    .instance
                                                                    .selectTransPortCost);
                                                          }
                                                        } else {
                                                          if (selectedClaimType ==
                                                              constants
                                                                  .claimChild) {
                                                            /// data for self claim
                                                            if (selectedChildID ==
                                                                "") {
                                                              CheckInternet();
                                                            } else {
                                                              uiUpdates
                                                                  .ShowToast(
                                                                  Strings
                                                                      .instance
                                                                      .selectChild);
                                                            }
                                                          } else {
                                                            /// data for child claim
                                                            CheckInternet();
                                                          }
                                                        }
                                                      }
                                                    } else{
                                                      if (isTransport) {
                                                        if (transportCostCon
                                                            .text
                                                            .toString() !=
                                                            "") {
                                                          if (transportVoucherPath !=
                                                              "") {
                                                            if (selectedClaimType ==
                                                                constants
                                                                    .claimChild) {
                                                              /// data for self claim
                                                              if (selectedChildID ==
                                                                  "") {
                                                                CheckInternet();
                                                              } else {
                                                                uiUpdates
                                                                    .ShowToast(
                                                                    Strings
                                                                        .instance
                                                                        .selectChild);
                                                              }
                                                            } else {
                                                              /// data for child claim
                                                              CheckInternet();
                                                            }
                                                          } else {
                                                            uiUpdates
                                                                .ShowToast(
                                                                Strings
                                                                    .instance
                                                                    .transportVoucher);
                                                          }
                                                        } else {
                                                          uiUpdates
                                                              .ShowToast(
                                                              Strings
                                                                  .instance
                                                                  .selectTransPortCost);
                                                        }
                                                      } else {
                                                        if (selectedClaimType ==
                                                            constants
                                                                .claimChild) {
                                                          /// data for self claim
                                                          if (selectedChildID ==
                                                              "") {
                                                            CheckInternet();
                                                          } else {
                                                            uiUpdates
                                                                .ShowToast(
                                                                Strings
                                                                    .instance
                                                                    .selectChild);
                                                          }
                                                        } else {
                                                          /// data for child claim
                                                          CheckInternet();
                                                        }
                                                      }
                                                    }
                                                  }else{
                                                    uiUpdates.ShowToast(Strings.instance.feeVoucher);
                                                  }
                                                }else{
                                                  uiUpdates.ShowToast(Strings.instance.resultCardDoc);
                                                }
                                              }else{
                                                uiUpdates.ShowToast(Strings.instance.applicationFormDoc);
                                              }
                                            }else{
                                              uiUpdates.ShowToast(Strings.instance.selectOtherChargesRemarks);
                                            }
                                          }else{
                                            uiUpdates.ShowToast(Strings.instance.selectOtherFineRemarks);
                                          }
                                        }else{
                                          uiUpdates.ShowToast(Strings.instance.selectOtherCharges);
                                        }
                                      }else{
                                        uiUpdates.ShowToast(Strings.instance.selectOtherFine);
                                      }
                                    }else{
                                      uiUpdates.ShowToast(Strings.instance.selectLateFeeFine);
                                    }
                                  }else{
                                    uiUpdates.ShowToast(Strings.instance.selectTaxFee);
                                  }
                                }else{
                                  uiUpdates.ShowToast(Strings.instance.selectReimbursment);
                                }
                              }else{
                                uiUpdates.ShowToast(Strings.instance.selectAdjCharges);
                              }
                            }else{
                              uiUpdates.ShowToast(Strings.instance.selectFeeArrears);
                            }
                          }else{
                            uiUpdates.ShowToast(Strings.instance.selectDevelopCharges);
                          }
                        }else{
                          uiUpdates.ShowToast(Strings.instance.selectWashCharges);
                        }
                      }else{
                        uiUpdates.ShowToast(Strings.instance.selectSpotsFee);
                      }
                    }else{
                      uiUpdates.ShowToast(Strings.instance.selectComptFee);
                    }
                  }else{
                    uiUpdates.ShowToast(Strings.instance.selectExamFee);
                  }
                }else{
                  uiUpdates.ShowToast(Strings.instance.selectLibraryFee);
                }
              }else{
                uiUpdates.ShowToast(Strings.instance.selectSecurityFee);
              }
            }else{
              uiUpdates.ShowToast(Strings.instance.selectProsFee);
            }
          }else{
            uiUpdates.ShowToast(Strings.instance.selectRegFee);
          }
        }else{
          uiUpdates.ShowToast(Strings.instance.selectTutionFee);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectEndDate);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectStartDate);
    }
  }

  void CheckInternet() {
    constants.CheckConnectivity(context).then((value) => {
      if(value){
        CreateFeeClaim()
      }else{
        uiUpdates.ShowToast(Strings.instance.internetNotConnected)
      }
    });
  }
}
