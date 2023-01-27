import 'package:flutter/material.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/itemviews/note_item.dart';

import '../colors/app_colors.dart';
import '../models/NoteModel.dart';

class NotingItem extends StatefulWidget {
  NoteModel noteModel;
  Constants constants;

  NotingItem(this.noteModel, this.constants);

  @override
  _NotingItemState createState() => _NotingItemState();
}

class _NotingItemState extends State<NotingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      color: AppTheme.colors.colorExelentLight,
      child: Column(
        children: [
          Row(
            children: [
              Material(
                elevation: 5,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.colorExelentLight,
                    border: Border.all(width: 0.5, color: AppTheme.colors.colorExelentDark),
                  ),

                  child: Icon(Icons.arrow_upward, size: 18, color: AppTheme.colors.colorExelentDark,),
                ),
              ),

              SizedBox(width: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Marked To: "+widget.noteModel.user_name_to,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppTheme.colors.colorExelentDark,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(widget.noteModel.role_name_to+" – "+widget.noteModel.sector_name_to,
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

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemBuilder: (_, int index) =>
                NoteItem(widget.noteModel.noteList[index]),
            itemCount: widget.noteModel.noteList.length,
          ),

          SizedBox(
            height: 15,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Marked By: "+widget.noteModel.user_name_by,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.colorExelentDark,
                      fontSize: 11,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal
                  ),
                ),

                Text(widget.noteModel.role_name_by+" – "+widget.noteModel.sector_name_by,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal
                  ),
                ),

                Text(widget.constants.GetFormatedDate(widget.noteModel.created_at),
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
          )
        ],
      ),
    );
  }
}
