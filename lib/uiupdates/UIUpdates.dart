import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/colors/colors.dart';

class UIUpdates{
  BuildContext context;
  //ProgressDialog progressDialog;
  SimpleFontelicoProgressDialog _dialog;

  UIUpdates(BuildContext context)
  {
    this.context= context;
  }
  void ShowProgressDialog(String message)
  {
    // Dismiss any existing dialog first to prevent multiple dialogs
    DismissProgresssDialog();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context != null) {
        try {
          _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
          _dialog.show(message: message, type: SimpleFontelicoProgressDialogType.normal,indicatorColor: AppColors().newPrimary);
        } catch (e) {
          print('Error showing progress dialog: $e');
        }
      }
    });

    // progressDialog= new ProgressDialog(context, isDismissible: false, type: ProgressDialogType.Normal);
    // progressDialog.style(
    //     message: message,
    //     borderRadius: 10.0,
    //     backgroundColor: Colors.white,
    //     progressWidget: CircularProgressIndicator(
    //       valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.colors.newPrimary),
    //       strokeWidth: 3,
    //     ),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     progress: 0.0,
    //     maxProgress: 100.0,
    //     progressTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600)
    // );
    // progressDialog.show();
  }

  void DismissProgresssDialog()
  {
    if(_dialog != null)
    {
      try {
        _dialog.hide();
        _dialog = null;
      } catch (e) {
        print('Error dismissing progress dialog: $e');
        _dialog = null;
      }
    }

    // if(progressDialog != null)
    //   {
    //     progressDialog.hide();
    //   }
  }

  void HideKeyBoard()
  {
    FocusScope.of(context).unfocus();
  }

  void ShowToast(String message)
  {
    final snackBar = SnackBar(
      content: Text(message,
        style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 14,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold
        ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show success message with green background and check icon
  void ShowSuccess(String message, {Duration duration = const Duration(seconds: 3)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorExelent,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  /// Show error message with red background and error icon
  void ShowError(String message, {Duration duration = const Duration(seconds: 4)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorPoor,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  /// Show warning message with orange background and warning icon
  void ShowWarning(String message, {Duration duration = const Duration(seconds: 3)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorBad,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  /// Show info message with blue background and info icon
  void ShowInfo(String message, {Duration duration = const Duration(seconds: 3)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorGood,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  /// Internal method to show colored snackbar with icon
  void _showColoredSnackBar({
    String message,
    Color backgroundColor,
    IconData icon,
    Duration duration = const Duration(seconds: 3),
  })
  {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: AppTheme.colors.newWhite, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      elevation: 4,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}