import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/views/complaint_list_item.dart';
import 'package:wwf_apps/models/ComplaintModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/general/add_complaint.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:http/http.dart' as http;

class Complaints extends StatefulWidget {
  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<ComplaintModel> list= [];
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    refreshKey= GlobalKey<RefreshIndicatorState>();
    GetComplaints(false);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          child: Text("Complaints",
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

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddComplaint()
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.add_box_outlined, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: Column(
                  children: [
                    isError ? Expanded(
                      child: EmptyStateWidget(
                        icon: Icons.receipt_long_outlined,
                        message: 'No Complaints',
                        description: 'You haven\'t submitted any complaints yet.',
                      ),
                    ) : Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: RefreshIndicator(
                          color: AppTheme.colors.newPrimary,
                          key: refreshKey,
                          onRefresh: () async{
                            await GetComplaints(true);
                          },
                          child: ListView.builder(

                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 50),
                            itemBuilder: (_, int index) =>
                                ComplaintItem(list[index]),
                            itemCount: this.list.length,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GetComplaints(bool isRefresh) async {
    if(!isRefresh) {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    }
    var url = constants.getApiBaseURL() + constants.buildApiUrl(
        constants.assessments + "complaints/", 
        UserSessions.instance.getUserID);
    var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    uiUpdates.DismissProgresssDialog();
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"];
//        List<dynamic> entitlements = data["Complaint Responses"];
        List<dynamic> entitlements = data;
        if(entitlements.length > 0)
        {
          list.clear();
          entitlements.forEach((row) {
            String id= row["com_id"].toString();
            String type= row["com_type"].toString();
            String subject= row["com_subject"].toString();
            String message= row["com_message"].toString();
            String complaintResponse= row["com_response"].toString();
            String responderName= row["user_name"].toString();
            String responderImage= row["user_image"].toString();
            String responderSectorName= row["sector_name"].toString();
            String responderRoleName= row["role_name"].toString();
            String respondedAt= row["respond_at"].toString();
            String createdAt= row["created_at"].toString();
            list.add(new ComplaintModel(id, type, subject, message, complaintResponse, responderName, responderImage, responderSectorName, responderRoleName, respondedAt, createdAt));
          });

          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= false;
          });
        }else
        {
          uiUpdates.DismissProgresssDialog();
          setState(() {
            isError= true;
            errorMessage = "Complaints Not Available";
          });
        }
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      if(responseCodeModel.message!="null") {
        uiUpdates.ShowToast(responseCodeModel.message);
      }else{
        setState(() {
          isError= true;
          errorMessage = "Complaints Not Available";
        });
      }
    }
  }
}
