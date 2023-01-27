import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';

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
    Future.delayed(const Duration(milliseconds: 100), () {
      _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
      _dialog.show(message: message, type: SimpleFontelicoProgressDialogType.normal);
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
      _dialog.hide();
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
    // Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: AppTheme.colors.newPrimary,
    //     textColor: Colors.white,
    //     fontSize: 14.0
    // );
    // Toast.show(message, context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}