import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/children_list_itemview.dart';
import 'package:wwf_apps/models/ChildrenModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/home/employee/add_child.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:http/http.dart' as http;

class ChildrenList extends StatefulWidget {
  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  List<ChildrenModel> childrenModelList= [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Professional Header
            StandardHeader(
              title: "My Children",
              subtitle: childrenModelList.isNotEmpty
                  ? "${childrenModelList.length} ${childrenModelList.length == 1 ? 'Child' : 'Children'}"
                  : null,
              actionIcon: Icons.add_circle_outline,
              onActionPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddChild()),
                ).then((value) {
                  if (value == true) {
                    childrenModelList.clear();
                    CheckTokenExpiry();
                  }
                });
              },
            ),

            // Content
            Expanded(
              child: isError && childrenModelList.isEmpty
                  ? EmptyStates.noChildren()
                  : childrenModelList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.child_care,
                                size: 80,
                                color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Children Added",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 16,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Add your first child to get started",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                                  fontSize: 14,
                                  fontFamily: "AppFont",
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            childrenModelList.clear();
                            await Future.delayed(Duration(milliseconds: 500));
                            CheckTokenExpiry();
                          },
                          color: AppTheme.colors.newPrimary,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            itemBuilder: (_, int index) =>
                                ChildrenListItemView(constants, childrenModelList[index]),
                            itemCount: childrenModelList.length,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }else{
        GetInformation();
      }
    });
  }

  GetInformation() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      List<String> tagsList = [constants.accountInfo, constants.empChildren];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue?.toString() ?? "0";
          
          if (code == "1" || codeValue == 1) {
            var accountData = body["Data"]["account"];
            List<dynamic> children = accountData["emp_children"] ?? [];
            
            childrenModelList.clear();
            
            if (children.length > 0) {
              children.forEach((element) {
                childrenModelList.add(new ChildrenModel(
                  element["child_id"]?.toString() ?? "",
                  element["emp_id"]?.toString() ?? "",
                  element["child_name"]?.toString() ?? "",
                  element["child_cnic"]?.toString() ?? "",
                  element["child_issued"]?.toString() ?? "",
                  element["child_expiry"]?.toString() ?? "",
                  element["child_gender"]?.toString() ?? "",
                  element["child_birthday"]?.toString() ?? "",
                  element["child_image"]?.toString() ?? "",
                  element["child_identity"]?.toString() ?? "",
                  element["child_upload"]?.toString() ?? "",
                ));
              });

              setState(() {
                isError = false;
              });
            } else {
              setState(() {
                isError = true;
                errorMessage = "No children found";
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? Strings.instance.failedToGetInfo;
            uiUpdates.ShowError(message);
            setState(() {
              isError = true;
              errorMessage = message;
            });
          }
        } catch (e) {
          uiUpdates.ShowError(Strings.instance.somethingWentWrong);
          setState(() {
            isError = true;
            errorMessage = Strings.instance.somethingWentWrong;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"]?.toString() ?? "";
          
          if (message == constants.expireToken) {
            constants.OpenLogoutDialog(
              context,
              Strings.instance.expireSessionTitle,
              Strings.instance.expireSessionMessage,
            );
          } else if (message.isNotEmpty && message != "null") {
            uiUpdates.ShowError(message);
          } else {
            uiUpdates.ShowError(responseCodeModel.message);
          }
          
          setState(() {
            isError = true;
            errorMessage = message.isNotEmpty ? message : Strings.instance.notAvail;
          });
        } catch (e) {
            uiUpdates.ShowError(responseCodeModel.message);
          setState(() {
            isError = true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      setState(() {
        isError = true;
        errorMessage = Strings.instance.somethingWentWrong;
      });
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
