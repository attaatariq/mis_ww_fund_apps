import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/models/WorkerModel.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/views/worker_list_item.dart';
import 'package:wwf_apps/screens/home/employer/add_worker.dart';
import 'package:http/http.dart' as http;
import '../../../Strings/Strings.dart';

class WorkersList extends StatefulWidget {
  @override
  _WorkersListState createState() => _WorkersListState();
}

class _WorkersListState extends State<WorkersList> {
  List<WorkerModel> workersList = [];
  Constants constants;
  UIUpdates uiUpdates;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "Workers",
            subtitle: workersList.isNotEmpty
                ? "${workersList.length} ${workersList.length == 1 ? 'Worker' : 'Workers'}"
                : null,
            actionIcon: Icons.add,
            onActionPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddWorker(),
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    workersList.clear();
                    isLoading = true;
                  });
                  GetWorkersList();
                }
              });
            },
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? _buildErrorState()
                    : workersList.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                workersList.clear();
                                isLoading = true;
                              });
                              await Future.delayed(Duration(milliseconds: 500));
                              GetWorkersList();
                            },
                            color: AppTheme.colors.newPrimary,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              itemCount: workersList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: WorkerListItem(workersList[index]),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              errorMessage.isNotEmpty ? errorMessage : "No Workers Available",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isError = false;
                  isLoading = true;
                });
                GetWorkersList();
              },
              icon: Icon(Icons.refresh, size: 18),
              label: Text("Retry"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppTheme.colors.newPrimary),
                foregroundColor: MaterialStateProperty.all(AppTheme.colors.newWhite),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              "No Workers",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray,
                fontSize: 16,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Workers will appear here once added",
              style: TextStyle(
                color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                fontSize: 14,
                fontFamily: "AppFont",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void GetWorkersList() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      String userId = UserSessions.instance.getUserID;
      String compId = UserSessions.instance.getRefID;

      // Fetch comp_id if not available
      if (compId.isEmpty || compId == "" || compId == "null") {
        compId = await _fetchCompanyID();
      }

      if (compId.isEmpty || compId == "" || compId == "null") {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = "Company ID not found. Please try again.";
        });
        uiUpdates.DismissProgresssDialog();
        return;
      }

      // API endpoint: /employees/index/{user_id}/{comp_id}
      var url = constants.getApiBaseURL() +
                constants.employees +
                "index/" +
                userId + "/" +
                compId;

      var response = await http.get(
        Uri.parse(url),
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 30));

      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);

      uiUpdates.DismissProgresssDialog();

      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";

          if (code == "1" || codeValue == 1) {
            List<dynamic> dataList = body["Data"] != null
                ? (body["Data"] is List ? body["Data"] : [])
                : [];

            workersList.clear();

            if (dataList.isNotEmpty) {
              dataList.forEach((row) {
                workersList.add(WorkerModel(
                  user_id: row["user_id"]?.toString() ?? "",
                  user_name: row["user_name"]?.toString() ?? "",
                  user_image: row["user_image"]?.toString() ?? "",
                  user_cnic: row["user_cnic"]?.toString() ?? "",
                  user_gender: row["user_gender"]?.toString() ?? "",
                  user_email: row["user_email"]?.toString() ?? "",
                  user_contact: row["user_contact"]?.toString() ?? "",
                  emp_id: row["emp_id"]?.toString() ?? "",
                  emp_father: row["emp_father"]?.toString() ?? "",
                  emp_birthday: row["emp_birthday"]?.toString() ?? "",
                  emp_ssno: row["emp_ssno"]?.toString() ?? "",
                  emp_eobino: row["emp_eobino"]?.toString() ?? "",
                  emp_check: row["emp_check"]?.toString() ?? "",
                  emp_address: row["emp_address"]?.toString() ?? "",
                  city_name: row["city_name"]?.toString() ?? "",
                  district_name: row["district_name"]?.toString() ?? "",
                  state_name: row["state_name"]?.toString() ?? "",
                  emp_issued: row["emp_issued"]?.toString() ?? "",
                  emp_expiry: row["emp_expiry"]?.toString() ?? "",
                  emp_about: row["emp_about"]?.toString() ?? "",
                  emp_bank: row["emp_bank"]?.toString() ?? "",
                  emp_title: row["emp_title"]?.toString() ?? "",
                  emp_account: row["emp_account"]?.toString() ?? "",
                  emp_status: row["emp_status"]?.toString() ?? "",
                  appointed_at: row["appointed_at"]?.toString() ?? "",
                  created_at: row["created_at"]?.toString() ?? "",
                  updated_at: row["updated_at"]?.toString() ?? "",
                ));
              });

              setState(() {
                isLoading = false;
                isError = false;
              });
            } else {
              setState(() {
                isLoading = false;
                isError = false;
              });
            }
          } else {
            String message = body["Message"]?.toString() ?? "";
            if (message.isNotEmpty && message != "null") {
              uiUpdates.ShowToast(message);
            }
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = message.isNotEmpty ? message : Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = Strings.instance.somethingWentWrong;
          });
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
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
            uiUpdates.ShowToast(message);
          }

          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = message.isNotEmpty ? message : Strings.instance.notAvail;
          });
        } catch (e) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = Strings.instance.somethingWentWrong;
      });
      uiUpdates.DismissProgresssDialog();
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    }
  }

  Future<String> _fetchCompanyID() async {
    try {
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String code = body["Code"]?.toString() ?? "0";
        if (code == "1" || body["Code"] == 1) {
          var dataObj = body["Data"];
          var account = dataObj["account"];
          if (account != null && account["comp_id"] != null) {
            String compId = account["comp_id"].toString();
            if (compId.isNotEmpty && compId != "null") {
              UserSessions.instance.setRefID(compId);
              return compId;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail
    }
    return "";
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(
            context,
            Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        GetWorkersList();
      }
    });
  }
}

