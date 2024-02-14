import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/itemviews/notification_list_item.dart';
import 'package:welfare_claims_app/models/NotificationModel.dart';

class Notifications extends StatefulWidget {
  List<NotificationModel> list;

  Notifications(this.list);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.list.length > 0 ?Column(
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (_, int index) =>
                    NotificationListItem(widget.list[index]),
                itemCount: widget.list.length,
              ),
            ),
          )
        ],
      ) : Center(
        child: Text(
          "Notifications Not Available",
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