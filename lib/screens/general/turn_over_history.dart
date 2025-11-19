import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/turn_over_history_item.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/models/TurnoverHistoryModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:welfare_claims_app/widgets/empty_state_widget.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:http/http.dart' as http;

class TurnOverHistory extends StatefulWidget {
  @override
  _TurnOverHistoryState createState() => _TurnOverHistoryState();
}

class _TurnOverHistoryState extends State<TurnOverHistory> {
  String comp_name="-", comp_type="-", comp_landline="-", comp_fax_no="-", comp_logo="-", comp_address= "-";

  Constants constants;
  UIUpdates uiUpdates;
  bool isError= false;
  String errorMessage="";
  List<TurnoverHistoryModel> list= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetTurnOverHistory();
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
                      child: Text("History",
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
            
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.colors.colorDarkGray),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Currently Employee",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 13,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 20,),

                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: comp_logo != "null" && comp_logo != "" && comp_logo != "-" && comp_logo != "NULL" ? FadeInImage(
                                    image: NetworkImage(constants.getImageBaseURL()+comp_logo),
                                    placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                    fit: BoxFit.fill,
                                  ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                    height: 60.0,
                                    width: 60,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comp_name,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 15,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Text(
                                    comp_type,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppTheme.colors.colorDarkGray,
                                        fontSize: 13,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          SizedBox(height: 20,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(Icons.call, size: 15, color: AppTheme.colors.newPrimary,),

                                SizedBox(width: 10,),

                                Text(
                                  comp_landline,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(Icons.local_print_shop_outlined, size: 15, color: AppTheme.colors.newPrimary,),

                                SizedBox(width: 10,),

                                Text(
                                  comp_fax_no,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 15, color: AppTheme.colors.newPrimary,),

                                SizedBox(width: 10,),

                                Text(
                                  comp_address,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 13,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Previous Employment",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 13,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    isError ? Expanded(
                      child: EmptyStateWidget(
                        icon: Icons.history_outlined,
                        message: 'No History Available',
                        description: 'Previous employment history will appear here once available.',
                      ),
                    ) : Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (_, int index) =>
                              TurnOverHistoryItem(list[index]),
                          itemCount: this.list.length,
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
    );
  }

  void GetTurnOverHistory() async{
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.companies + "turnovers/", 
          UserSessions.instance.getUserID, 
          additionalPath: "7/4");
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
          response.statusCode, response);
      
      if (responseCodeModel.status == true) {
        try {
          var body = jsonDecode(response.body);
          dynamic codeValue = body["Code"];
          String code = codeValue != null ? codeValue.toString() : "0";
          
          if (code == "1" || codeValue == 1) {
            var data= body["Data"];
            if(data != null) {
              var currentEmployee= data["current"];
              if(currentEmployee != null && currentEmployee.length > 0) {
                var currentComp= currentEmployee[0];
                comp_name = currentComp["comp_name"] != null ? currentComp["comp_name"].toString() : "-";
                comp_type = currentComp["comp_type"] != null ? currentComp["comp_type"].toString() : "-";
                comp_landline = currentComp["comp_landline"] != null ? currentComp["comp_landline"].toString() : "-";
                comp_fax_no = currentComp["comp_fax_no"] != null ? currentComp["comp_fax_no"].toString() : "-";
                comp_logo = currentComp["comp_logo"] != null ? currentComp["comp_logo"].toString() : "-";
                comp_address= currentComp["comp_address"] != null ? currentComp["comp_address"].toString() : "-";
              }

              // Previous employment
              List<dynamic> entitlements = data["previous"] != null ? data["previous"] : [];
              if(entitlements.length > 0)
              {
                list.clear();
                entitlements.forEach((row) {
                  String comp_name= row["comp_name"] != null ? row["comp_name"].toString() : "";
                  String comp_address= row["comp_address"] != null ? row["comp_address"].toString() : "";
                  String city_name= row["city_name"] != null ? row["city_name"].toString() : "";
                  list.add(new TurnoverHistoryModel(comp_name, comp_address+", "+city_name));
                });

                setState(() {
                  isError= false;
                });
              }else
              {
                setState(() {
                  isError= true;
                  errorMessage = Strings.instance.notAvail;
                });
              }
            } else {
              setState(() {
                isError= true;
                errorMessage = Strings.instance.notAvail;
              });
            }
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"] != null ? body["Message"].toString() : "";
          
          if(message == constants.expireToken){
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
          }else if(message.isNotEmpty && message != "null"){
            uiUpdates.ShowToast(message);
          } else {
            setState(() {
              isError= true;
              errorMessage = Strings.instance.notAvail;
            });
          }
        } catch (e) {
          setState(() {
            isError= true;
            errorMessage = Strings.instance.notAvail;
          });
        }
      }
    } catch (e) {
      setState(() {
        isError= true;
        errorMessage = Strings.instance.notAvail;
      });
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
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
