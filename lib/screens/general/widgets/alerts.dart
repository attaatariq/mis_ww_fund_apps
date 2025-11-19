import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/views/alert_list_item.dart';
import 'package:wwf_apps/models/AlertModel.dart';
import 'package:wwf_apps/widgets/empty_state_widget.dart';

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
      ) : EmptyStates.noAlerts(),
    );
  }
}
