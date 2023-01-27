import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/AlertModel.dart';

class AlertListItem extends StatefulWidget {
  AlertModel alertModel;

  AlertListItem(this.alertModel);

  @override
  _AlertListItemState createState() => _AlertListItemState();
}

class _AlertListItemState extends State<AlertListItem> {
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
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colors.colorDarkGray),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Center(
                  child: Image(
                    image: AssetImage(
                        "assets/images/danger.png"),
                    alignment: Alignment.center,
                    height: 15.0,
                    width: 15.0,
                    color: AppTheme.colors.newWhite,
                  ),
                ),
              ),

              SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.alertModel.subject,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 2,),

                  Text(
                    constants.GetFormatedDate(widget.alertModel.dateTime),
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
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              widget.alertModel.message,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 12,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}
