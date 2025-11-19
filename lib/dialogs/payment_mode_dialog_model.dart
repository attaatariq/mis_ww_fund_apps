import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';

class PaymentModeDialogModel extends StatefulWidget {

  @override
  _PaymentModeDialogModelState createState() => _PaymentModeDialogModelState();
}

class _PaymentModeDialogModelState extends State<PaymentModeDialogModel> {

  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 163,
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
          color: AppTheme.colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Container(
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Payment Mode",
                        style: TextStyle(
                            color: AppTheme.colors.white,
                            fontSize: 13,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 0.5,
                        width: double.infinity,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop(constants.cash);
                        },
                        child: Container(
                          height: 40,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(constants.cash,
                                  style: TextStyle(
                                      color: AppTheme.colors.colorAccent,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: AppTheme.colors.colorDarkGray,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop(constants.challan);
                        },
                        child: Container(
                          height: 40,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(constants.challan,
                                  style: TextStyle(
                                      color: AppTheme.colors.colorAccent,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: AppTheme.colors.colorDarkGray,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop(constants.draft);
                        },
                        child: Container(
                          height: 40,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(constants.draft,
                                  style: TextStyle(
                                      color: AppTheme.colors.colorAccent,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: AppTheme.colors.colorDarkGray,
                                ),
                              )
                            ],
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
      ),
    );
  }
}
