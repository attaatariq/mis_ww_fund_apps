import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/sessions/UserSessions.dart';

class FeedbackDialog extends StatefulWidget {
  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  TextEditingController feedBackController = new TextEditingController();
  int selectedPosition = 0;
  String selectedFeedback = "";
  String feedbackType = "";
  Constants constants;
  UIUpdates uiUpdates;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
  }

  @override
  void dispose() {
    feedBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppTheme.colors.newWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.colors.newPrimary,
                    AppTheme.colors.newPrimary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.feedback_outlined,
                          color: AppTheme.colors.newWhite,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Send Feedback",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 18,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppTheme.colors.newWhite,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
                    Text(
                      "How would you rate your experience with the app?",
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Rating Buttons - Attached with 0 border radius
                    Row(
                      children: [
                        Expanded(
                          child: _buildRatingButton(
                            1,
                            "Excellent",
                            AppTheme.colors.colorExelent,
                            "archive/images/smile_ex.png",
                            isFirst: true,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildRatingButton(
                            2,
                            "Good",
                            AppTheme.colors.colorGood,
                            "archive/images/smile.png",
                            isFirst: false,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildRatingButton(
                            3,
                            "Bad",
                            AppTheme.colors.colorBad,
                            "archive/images/sad.png",
                            isFirst: false,
                            isLast: false,
                          ),
                        ),
                        Expanded(
                          child: _buildRatingButton(
                            4,
                            "Poor",
                            AppTheme.colors.colorPoor,
                            "archive/images/poor.png",
                            isFirst: false,
                            isLast: true,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Description Question
                    Text(
                      "How would you describe your experience briefly?",
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 16,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Text Field
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 200,
                        maxHeight: 250,
                      ),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.colorLightGray,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: feedBackController,
                        cursorColor: AppTheme.colors.newPrimary,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.colors.newBlack,
                          fontFamily: "AppFont",
                        ),
                        decoration: InputDecoration(
                          hintMaxLines: 4,
                          hintText: "Have feedback? Your feedback help us to improve. We'd love to hear it, but please don't share sensitive information.",
                          hintStyle: TextStyle(
                            fontFamily: "AppFont",
                            color: AppTheme.colors.colorDarkGray,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Submit Button
                    InkWell(
                      onTap: () {
                        Validation();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.colors.newPrimary,
                              AppTheme.colors.newPrimary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.colors.newPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Send Feedback",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Continue without feedback link
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Continue without providing feedback",
                          style: TextStyle(
                            color: AppTheme.colors.colorDarkGray.withOpacity(0.6),
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingButton(int position, String label, Color color, String iconPath, {bool isFirst = false, bool isLast = false}) {
    bool isSelected = selectedPosition == position;
    return InkWell(
      onTap: () {
        SelectedFeedback(position);
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.colors.newBlack : color,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.circular(0) : Radius.circular(0),
            topRight: isLast ? Radius.circular(0) : Radius.circular(0),
            bottomLeft: isFirst ? Radius.circular(0) : Radius.circular(0),
            bottomRight: isLast ? Radius.circular(0) : Radius.circular(0),
          ),
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? AppTheme.colors.newPrimary
                  : color.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            right: BorderSide(
              color: isSelected
                  ? AppTheme.colors.newPrimary
                  : color.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            top: BorderSide(
              color: isSelected
                  ? AppTheme.colors.newPrimary
                  : color.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            bottom: BorderSide(
              color: isSelected
                  ? AppTheme.colors.newPrimary
                  : color.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.colors.newPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(iconPath),
              alignment: Alignment.center,
              height: 24.0,
              width: 24.0,
              color: AppTheme.colors.newWhite,
            ),
            SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 11,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Validation() {
    if (selectedPosition != 0) {
      if (feedBackController.text.isNotEmpty) {
        SendFeedbackToAdmin();
      } else {
        uiUpdates.ShowToast("Please describe your feedback");
      }
    } else {
      uiUpdates.ShowToast("Please select your feedback");
    }
  }

  void SelectedFeedback(int position) {
    setState(() {
      selectedPosition = position;
      if (position == 1) {
        selectedFeedback = "Excellent";
      } else if (position == 2) {
        selectedFeedback = "Good";
      } else if (position == 3) {
        selectedFeedback = "Bad";
      } else if (position == 4) {
        selectedFeedback = "Poor";
      }
    });
  }

  void SendFeedbackToAdmin() async {
    uiUpdates.HideKeyBoard();
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    SetFeedbackType(
      UserSessions.instance.getUserSector,
      UserSessions.instance.getUserRole,
      UserSessions.instance.getUserAccount,
    );
    Map data = {
      "user_id": UserSessions.instance.getUserID,
      "comp_id": UserSessions.instance.getRefID,
      "feed_type": feedbackType,
      "feed_quality": selectedFeedback,
      "feed_message": feedBackController.text.toString(),
    };
    var url = constants.getApiBaseURL() + constants.assessments + "feedback";
    var response = await http.post(
      Uri.parse(url),
      body: data,
      headers: APIService.getDefaultHeaders(),
      encoding: Encoding.getByName("UTF-8"),
    );
    ResponseCodeModel responseCodeModel =
        constants.CheckResponseCodesNew(response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        uiUpdates.ShowToast(Strings.instance.successFeedback);
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        uiUpdates.ShowToast(Strings.instance.failedFeedback);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void SetFeedbackType(String user_sector, String user_role, String user_account) {
    if (user_sector == "7" && user_role == "6") {
      // wwf employee
      feedbackType = "Employee";
    } else if (user_sector == "8" && user_role == "9") {
      // company worker
      feedbackType = "Worker";
    } else if (user_sector == "8" && user_role == "7") {
      //CEO company
      feedbackType = "Company";
    } else if (user_sector == "8" && user_role == "8") {
      //DEO company
      feedbackType = "Company";
    }
  }
}

// Utility function to show feedback dialog
Future<bool> showFeedbackDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return FeedbackDialog();
    },
  ) ?? false;
}

