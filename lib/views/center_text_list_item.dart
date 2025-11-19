
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';

class CenterTextListItem extends StatefulWidget {
  String name;

  CenterTextListItem(this.name);

  @override
  _CenterTextListItemState createState() => _CenterTextListItemState();
}

class _CenterTextListItemState extends State<CenterTextListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
      ),
      height: 40,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(widget.name,
              style: TextStyle(
                  color: AppTheme.colors.black,
                  fontSize: 13,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold
              ),),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 0.5,
              width: double.infinity,
              color: AppTheme.colors.colorDarkGray,
            ),
          )
        ],
      ),
    );
  }
}
