import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/TurnoverHistoryModel.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

class TurnOverHistoryItem extends StatefulWidget {
  TurnoverHistoryModel turnoverHistoryModel;

  TurnOverHistoryItem(this.turnoverHistoryModel);

  @override
  _TurnOverHistoryItemState createState() => _TurnOverHistoryItemState();
}

class _TurnOverHistoryItemState extends State<TurnOverHistoryItem> {
  Constants constants;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colors.colorDarkGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.circular(50),
                ),

                child: Center(
                  child: Icon(Icons.work_outline, size: 20, color: AppTheme.colors.newWhite,)
                ),
              ),

              SizedBox(width: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.turnoverHistoryModel.name,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 13,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    widget.turnoverHistoryModel.location,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
