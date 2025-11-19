import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/views/center_text_list_item.dart';
import 'package:wwf_apps/models/CityModel.dart';

class CompanyTypesDialogModel extends StatefulWidget {
  List<String> list;

  CompanyTypesDialogModel(this.list);

  @override
  _CompanyTypesDialogModelState createState() => _CompanyTypesDialogModelState();
}

class _CompanyTypesDialogModelState extends State<CompanyTypesDialogModel> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 260,
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
          color: AppTheme.colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Container(
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: AppTheme.colors.newPrimary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Select Type",
                        style: TextStyle(
                            color: AppTheme.colors.white,
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
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 0, right: 0, left: 0, bottom: 0),
                          itemBuilder: (_, int index) =>
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pop(widget.list[index]);
                                },
                                  child: CenterTextListItem(widget.list[index])),
                          itemCount: this.widget.list.length,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
