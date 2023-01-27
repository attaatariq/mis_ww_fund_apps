import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/banks_dialog_model.dart';
import 'package:welfare_claims_app/models/CommpanyWorkerBankInformationModel.dart';
import 'package:welfare_claims_app/screens/SectorInformationForms/Employee/EmployeeInformationForm.dart';
import 'package:welfare_claims_app/screens/general/splash_screen.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';

class WWFEmployeeSecondTab extends StatefulWidget {

  final parentFunction;

  WWFEmployeeSecondTab(this.parentFunction);

  @override
  _WWFEmployeeSecondTabState createState() => _WWFEmployeeSecondTabState();
}

TextEditingController wWAccountTitleController= TextEditingController();
TextEditingController wWAccountNumberController= TextEditingController();

class _WWFEmployeeSecondTabState extends State<WWFEmployeeSecondTab> {
  String selectedBankName= Strings.instance.selectBankName;
  UIUpdates uiUpdates;
  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUpdates= new UIUpdates(context);
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 15),
      color: AppTheme.colors.newWhite,
      child: SingleChildScrollView(
        child: Column(
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
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: wWAccountTitleController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Account Title",
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
                                controller: wWAccountNumberController,
                                cursorColor: AppTheme.colors.newPrimary,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.colors.newBlack
                                ),
                                decoration: InputDecoration(
                                  hintText: "Account Number",
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
              margin: EdgeInsets.only(top: 30, bottom: 60),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        widget.parentFunction(3);
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
                        widget.parentFunction(2);
                      },
                      child: InkWell(
                        onTap: (){
                          Validation();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          height: 45,
                          color: AppTheme.colors.newPrimary,
                          child: Center(
                            child: Text("Next",
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
                  ),
                ],
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

  void Validation() {
    if(wWAccountTitleController.text.toString() != ""){
      if(wWAccountNumberController.text.toString() != ""){
        if(selectedBankName != Strings.instance.selectBankName){
          CreateBankModel();
        }else{
          uiUpdates.ShowToast(Strings.instance.selectBankName);
        }
      }else{
        uiUpdates.ShowToast(Strings.instance.selectAccountNumber);
      }
    }else{
      uiUpdates.ShowToast(Strings.instance.selectAccountTitle);
    }
  }

  void CreateBankModel() {
    CompanyWorkerBankInformationModel companyWorkerBankInformationModel= new CompanyWorkerBankInformationModel(selectedBankName,
        wWAccountTitleController.text.toString(), wWAccountNumberController.text.toString());
    EmployeeInformationForm.companyWorkerBankInformationModel = companyWorkerBankInformationModel;
    ////call Function
    widget.parentFunction(2);
  }
}
