import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/FaqModel.dart';

class FaqListItem extends StatefulWidget {
  FaqModel faqModel;

  FaqListItem(this.faqModel);

  @override
  _FaqListItemState createState() => _FaqListItemState();
}

class _FaqListItemState extends State<FaqListItem> {
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
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.colors.colorDarkGray)
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.faqModel.question,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                        constants.GetFormatedDate(widget.faqModel.time),
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
                ),

                Icon(Icons.subject, color: AppTheme.colors.colorDarkGray, size: 20,)
              ],
            ),
          ),

          widget.faqModel.isOpen ? Container(
            padding: EdgeInsets.all(10),
            color: AppTheme.colors.newPrimary.withAlpha(180),
            child: Text(
              widget.faqModel.answer,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: AppTheme.colors.newWhite,
                  fontSize: 12,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal
              ),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
