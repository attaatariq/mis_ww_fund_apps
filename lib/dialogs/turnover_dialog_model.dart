import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';

class TurnoverDialogModel extends StatefulWidget {

  @override
  _TurnoverDialogModelState createState() => _TurnoverDialogModelState();
}

class _TurnoverDialogModelState extends State<TurnoverDialogModel> {

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
        height: 120,
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
                      child: Text("Company",
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
                          Navigator.of(context).pop(constants.current);
                        },
                        child: Container(
                          color: Colors.white,
                          height: 40,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(constants.current,
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
                          Navigator.of(context).pop(constants.previous);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                          ),
                          height: 40,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(constants.previous,
                                  style: TextStyle(
                                      color: AppTheme.colors.colorAccent,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),
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