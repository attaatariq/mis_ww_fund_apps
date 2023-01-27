import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/employee_verification_dialog.dart';
import 'package:welfare_claims_app/models/EmployeeVerificationModel.dart';

class EmployeeVerificationItem extends StatefulWidget {
  EmployeeVerificationModel model;
  int position;
  final parentFunction;

  EmployeeVerificationItem(this.model, this.position, this.parentFunction);

  @override
  _EmployeeVerificationItemState createState() => _EmployeeVerificationItemState();
}

class _EmployeeVerificationItemState extends State<EmployeeVerificationItem> {
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
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colors.colorDarkGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.model.user_image != "null" && widget.model.user_image != "" && widget.model.user_image != "-" && widget.model.user_image != "NULL" ? FadeInImage(
                    image: NetworkImage(constants.getImageBaseURL()+widget.model.user_image),
                    placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                    fit: BoxFit.fill,
                  ) : Image.asset("assets/images/no_image_placeholder.jpg",
                    height: 40.0,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              SizedBox(width: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.user_name,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 13,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    widget.model.emp_about,
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
              )
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CNIC",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.model.user_cnic,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  color: AppTheme.colors.colorDarkGray,
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Appointment Date",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.model.appointed_at,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SSN",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.model.emp_ssno,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  color: AppTheme.colors.colorDarkGray,
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EOBI",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.model.emp_eobino,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: (){
              OpenEmployeeVerificationDialog(context).then((value) => {
                if(value != null){
                  if(value){
                    widget.parentFunction(widget.position)
                  }
                }
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 40,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,
              child: Center(
                child: Text(
                  "VERIFY",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> OpenEmployeeVerificationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: EmployeeVerificationDialog(widget.model),
          );
        }
    );
  }
}
