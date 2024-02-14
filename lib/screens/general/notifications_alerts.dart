import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/alert_list_item.dart';
import 'package:welfare_claims_app/itemviews/notification_list_item.dart';
import 'package:welfare_claims_app/models/AlertModel.dart';
import 'package:welfare_claims_app/models/NotificationModel.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/screens/general/widgets/alerts.dart';
import 'package:welfare_claims_app/screens/general/widgets/notifications.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class NotificationsAndAlerts extends StatefulWidget {
  @override
  _NotificationsAndAlertsState createState() => _NotificationsAndAlertsState();
}

class _NotificationsAndAlertsState extends State<NotificationsAndAlerts> {
  int selectedPosition= 1;
  List<AlertModel> alertList = [];
  List<NotificationModel> notificationList = [];
  Constants constants;
  UIUpdates uiUpdates;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey= GlobalKey<RefreshIndicatorState>();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetNotifications(false);
    GetAlertsAndNotifications(false);
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
                      child: Text("Notifications & Alert's",
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

            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        selectedPosition = 1;
                        setState(() {
                        });
                      },
                      child: Container(
                        color: selectedPosition == 1 ? AppTheme.colors.newPrimary : AppTheme.colors.colorLightGray,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                "Notifications",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: selectedPosition == 1 ? AppTheme.colors.newWhite : AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        selectedPosition = 2;
                        setState(() {
                        });
                      },
                      child: Container(
                        color: selectedPosition == 2 ? AppTheme.colors.newPrimary : AppTheme.colors.colorLightGray,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                "Alerts",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: selectedPosition == 2 ? AppTheme.colors.newWhite : AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    selectedPosition == 1 ? Notifications(notificationList) : Alerts(alertList)
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }

  GetAlertsAndNotifications(bool isRefresh) async {
    var url = constants.getApiBaseURL() + constants.alerts +
        "notices/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        //get alerts
        List<dynamic> entitlements = body["Data"];
        print(entitlements.length);
        if(entitlements.length > 0)
        {
          alertList.clear();
          entitlements.forEach((row) {
            String alert_subject= row["alert_subject"].toString();
            String alert_message= row["alert_message"].toString();
            String alert_recipient= row["alert_recipient"].toString();
            String created_at= row["created_at"].toString();
            alertList.add(new AlertModel(alert_subject, alert_message, alert_recipient, created_at));
          });
        }

        setState(() {
        });
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      if(responseCodeModel.message!="null") {
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    }
  }

  GetNotifications(bool isRefresh) async {
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.alerts +
        "notifications/" + UserSessions.instance.getUserID + "/" +
        UserSessions.instance.getToken;
    var response = await http.get(Uri.parse(url));
    uiUpdates.DismissProgresssDialog();
    print(url+response.body);
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        //get notifications
        List<dynamic> entitlementsNoti = body["Data"];
        if(entitlementsNoti.length > 0)
        {
          notificationList.clear();
          entitlementsNoti.forEach((row) {
            String not_subject= row["not_subject"].toString();
            String not_message= row["not_message"].toString();
            String not_recipient= row["not_recipient"].toString();
            String created_at= row["created_at"].toString();
            notificationList.add(new NotificationModel(not_subject, not_message, not_recipient, created_at));
          });
        }

        setState(() {});
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      if(responseCodeModel.message!="null"){
        uiUpdates.ShowToast(responseCodeModel.message);
      }
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}

