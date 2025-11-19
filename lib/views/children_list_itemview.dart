import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ChildrenModel.dart';

class ChildrenListItemView extends StatefulWidget {
  ChildrenModel childrenModel;
  Constants constants;

  ChildrenListItemView(this. constants, this.childrenModel);

  @override
  _ChildrenListItemViewState createState() => _ChildrenListItemViewState();
}

class _ChildrenListItemViewState extends State<ChildrenListItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
          color: AppTheme.colors.newPrimary.withAlpha(400),
          borderRadius: BorderRadius.circular(2)
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.childrenModel.child_image != "null" && 
                           widget.childrenModel.child_image != "" && 
                           widget.childrenModel.child_image != "NULL" &&
                           widget.childrenModel.child_image != "-" &&
                           widget.childrenModel.child_image != "N/A" ? FadeInImage(
                      image: NetworkImage(widget.constants.getImageBaseURL()+widget.childrenModel.child_image),
                      placeholder: AssetImage("archive/images/no_image.jpg"),
                      fit: BoxFit.fill,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset("archive/images/no_image.jpg",
                          height: 40.0,
                          width: 40,
                          fit: BoxFit.fill,
                        );
                      },
                    ) : Image.asset("archive/images/no_image.jpg",
                      height: 40.0,
                      width: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.childrenModel.child_name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 13,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(
                            widget.childrenModel.child_cnic,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 10,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ],
                      ),

                      // Container(
                      //   height: 20,
                      //   width: 20,
                      //   child: Icon(Icons.edit, color: AppTheme.colors.newWhite, size: 20,),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
