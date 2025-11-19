import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/child_dialog_model.dart';
import 'package:wwf_apps/dialogs/claim_type_dialog_model.dart';
import 'package:wwf_apps/models/ChildModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class CreateOtherClaim extends StatefulWidget {
  String edu_living="", edu_mess="", edu_transport="", edu_nature="", edu_level="", stip_amount="0";

  CreateOtherClaim(this.edu_living, this.edu_mess, this.edu_transport, this.edu_nature, this.edu_level, this.stip_amount);

  @override
  _CreateOtherClaimState createState() => _CreateOtherClaimState();
}

TextEditingController transportCostCon= TextEditingController();
TextEditingController hostelRentCon= TextEditingController();
TextEditingController messChargesCon= TextEditingController();

TextEditingController uniformChargesCon= TextEditingController();
TextEditingController booksChargesCon= TextEditingController();
TextEditingController stationaryChargesCon= TextEditingController();
TextEditingController stipendAmountCon= TextEditingController();

class _CreateOtherClaimState extends State<CreateOtherClaim> {
  String transportVoucherPath="", transportVoucherName=Strings.instance.transportVoucher, residenceVoucherPath="", residenceVoucherName=Strings.instance.residenceVoucher,
      uniformVoucherPath="", uniformVoucherName=Strings.instance.uniformVoucherDoc, booksVoucherPath="", booksVoucherName=Strings.instance.booksVoucherDoc,
      stationaryVoucherPath="", stationaryVoucherName=Strings.instance.stationaryVoucherDoc;
  Constants constants;
  UIUpdates uiUpdates;
  List<ChildModel> childModelList= [];
  String selectedStartDate= Strings.instance.selectedStartedDate, selectedEndDate= Strings.instance.selectedEndedDate;
  String selectedChild= Strings.instance.selectedChild, selectedClaimType, selectedChildID="";
  bool isTransport= false, isMessInclude= false, isDayScholar= false, isUnderMatric= false, isEducationAvailable= true;

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

    if(widget.edu_nature == constants.underMatric){
      isUnderMatric= true;
    }else{
      isUnderMatric= false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
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
                      child: Text("Other Claim",
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
                            isUnderMatric ? Container(  ///// school basics container
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
                                        child: Text("School Basics Claim",
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
                                                            controller: uniformChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Uniform Charges",
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
                                                            controller: booksChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Books Charges",
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
                                                            controller: stationaryChargesCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Stationary Charges",
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

                                  InkWell(
                                    onTap: ()
                                    {
                                      OpenFilePicker(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      height: 45,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                                      ),
                                      child: Center(
                                        child: Text(uniformVoucherName,
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
                                      margin: EdgeInsets.only(top: 10),
                                      height: 45,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                                      ),
                                      child: Center(
                                        child: Text(booksVoucherName,
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
                                      margin: EdgeInsets.only(top: 10),
                                      height: 45,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                                      ),
                                      child: Center(
                                        child: Text(stationaryVoucherName,
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

                            !isUnderMatric ? Container(  ///// school basics container
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
                                        child: Text("Stipend Amount",
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
                                                            controller: stipendAmountCon,
                                                            cursorColor: AppTheme.colors.newPrimary,
                                                            keyboardType: TextInputType.number,
                                                            maxLines: 1,
                                                            textInputAction: TextInputAction.next,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.colors.newBlack
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: "Stipend Amount",
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
                            ) : Container(),

                            !isTransport ? Container(  ///// transport container
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
                                      OpenFilePicker(4);
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

                            isDayScholar ? Container( //// hostel and mess container
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

                                  !isMessInclude ? Container(
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
                                      OpenFilePicker(5);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 30),
                                      height: 45,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppTheme.colors.newBlack, width: 1,)
                                      ),
                                      child: Center(
                                        child: Text(residenceVoucherName,
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
                      ): Container()
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
          uniformVoucherName = file.name;
          uniformVoucherPath = file.path;
        }else if(position == 2) {
          booksVoucherName = file.name;
          booksVoucherPath = file.path;
        }else if(position == 3) {
          stationaryVoucherName = file.name;
          stationaryVoucherPath = file.path;
        }else if(position == 4) {
          transportVoucherName = file.name;
          transportVoucherPath = file.path;
        }else if(position == 5) {
          residenceVoucherName = file.name;
          residenceVoucherPath = file.path;
        }
      });
    } else {
      uiUpdates.ShowToast("Failed To Get File, Try Again");
    }
  }

  void CheckEducationDetail(bool isChildSelected, String refID) async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url;
    if(!isChildSelected) {
      url = constants.getApiBaseURL() + constants.claims + "edu_check/" + UserSessions.instance.getUserID + "/emp_id--" + refID;
    } else {
      url = constants.getApiBaseURL() + constants.claims + "edu_check/" + UserSessions.instance.getUserID + "/child_id--" + selectedChildID;
    }

    var response = await http.get(url);
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

  void Validation() {

  }
}
