import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';

class LogoutDialog extends StatefulWidget {
  String title, message;

  LogoutDialog(this.title, this.message);

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.title,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              decorationThickness: 2,
                              color: AppTheme.colors.black,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        SizedBox(height: 10,),

                        Padding(
                          padding: const EdgeInsets.only(right: 25.0, left: 25),
                          child: Text(widget.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                decorationThickness: 2,
                                color: AppTheme.colors.black,
                                fontSize: 14,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Constants constant= new Constants();
                Navigator.pop(context);
                constant.LogoutUser(context);
              },
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppTheme.colors.newPrimary,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
                ),

                child: Center(
                  child: Text("Logout",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        decorationThickness: 2,
                        color: AppTheme.colors.white,
                        fontSize: 14,
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
    );
  }
}