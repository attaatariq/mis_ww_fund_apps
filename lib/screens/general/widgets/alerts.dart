import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/itemviews/alert_list_item.dart';
import 'package:welfare_claims_app/models/AlertModel.dart';

class Alerts extends StatefulWidget {
  List<AlertModel> list;

  Alerts(this.list);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.list.length > 0 ? Column(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 60),
                itemBuilder: (_, int index) =>
                    AlertListItem(widget.list[index]),
                itemCount: widget.list.length,
              ),
            ),
          )
        ],
      ) : Center(
        child: Text(
          "Alerts Not Available",
          maxLines: 1,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
