import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/views/notification_list_item.dart';
import 'package:wwf_apps/models/NotificationModel.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';

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
      ) : EmptyStates.noNotifications(),
    );
  }
}