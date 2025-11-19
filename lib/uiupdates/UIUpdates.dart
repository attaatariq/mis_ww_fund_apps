import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/colors/colors.dart';

class UIUpdates{
  BuildContext context;
  SimpleFontelicoProgressDialog _dialog;

  UIUpdates(BuildContext context)
  {
    this.context= context;
  }
  void ShowProgressDialog(String message)
  {
    DismissProgresssDialog();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context != null) {
        try {
          _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
          _dialog.show(message: message, type: SimpleFontelicoProgressDialogType.normal,indicatorColor: AppColors().newPrimary);
        } catch (e) {
        }
      }
    });

  }

  void DismissProgresssDialog()
  {
    if(_dialog != null)
    {
      try {
        _dialog.hide();
        _dialog = null;
      } catch (e) {
        _dialog = null;
      }
    }

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

  void ShowSuccess(String message, {Duration duration = const Duration(seconds: 3)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorExelent,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  void ShowError(String message, {Duration duration = const Duration(seconds: 4)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorPoor,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  void ShowWarning(String message, {Duration duration = const Duration(seconds: 3)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorBad,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  void ShowInfo(String message, {Duration duration = const Duration(seconds: 3)})
  {
    _showColoredSnackBar(
      message: message,
      backgroundColor: AppTheme.colors.colorGood,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

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