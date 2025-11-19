import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/models/SelfEducationModel.dart';

class SelfEducationListItem extends StatefulWidget {
  SelfEducationModel selfEducationModel;


  SelfEducationListItem(this.selfEducationModel);

  @override
  _SelfEducationListItemState createState() => _SelfEducationListItemState();
}

class _SelfEducationListItemState extends State<SelfEducationListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
      decoration: BoxDecoration(
          color: AppTheme.colors.newPrimary.withAlpha(400),
          borderRadius: BorderRadius.circular(2)
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.selfEducationModel.edu_level+" ("+widget.selfEducationModel.edu_degree+")",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(" From : "+widget.selfEducationModel.school_name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(" Living : "+widget.selfEducationModel.edu_living,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(" Start : "+widget.selfEducationModel.edu_started,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(" End : "+widget.selfEducationModel.edu_ended,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),

            // Container(
            //   height: 20,
            //   width: 20,
            //   child: Icon(Icons.edit, color: AppTheme.colors.newWhite, size: 20,),
            // )
          ],
        ),
      ),
    );
  }
}
