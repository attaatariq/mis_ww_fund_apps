import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ComplaintModel.dart';

class ComplaintItem extends StatefulWidget {
  ComplaintModel complaintModel;

  ComplaintItem(this.complaintModel);

  @override
  _ComplaintItemState createState() => _ComplaintItemState();
}

class _ComplaintItemState extends State<ComplaintItem> {
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        border: Border.all(color: AppTheme.colors.colorDarkGray),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Image(
                    image: AssetImage(
                        "assets/images/complaint_icon.png"),
                    alignment: Alignment.center,
                    height: 15.0,
                    width: 15.0,
                    color: AppTheme.colors.newWhite,
                  ),
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.complaintModel.subject,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 13,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        widget.complaintModel.complaintResponse == "null" ? Icon(Icons.close, color: AppTheme.colors.colorDarkGray, size: 20,): Container()
                      ],
                    ),

                    SizedBox(height: 3,),

                    Text(
                      constants.GetFormatedDate(widget.complaintModel.createdAt),
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
              )
            ],
          ),

          SizedBox(height: 10,),

          Text(
            widget.complaintModel.message,
            textAlign: TextAlign.justify,
            style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 10,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal
            ),
          ),

          widget.complaintModel.complaintResponse == "null" ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              Strings.instance.awaitResponse,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: AppTheme.colors.colorPoor,
                  fontSize: 12,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal
              ),
            ),
          ) : Container(),

          widget.complaintModel.complaintResponse != "null" && widget.complaintModel.complaintResponse != "" ? Container(
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.all(8),
            color: AppTheme.colors.newPrimary.withAlpha(180),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: widget.complaintModel.responderImage != "null" && widget.complaintModel.responderImage != "" ? FadeInImage(
                            image: NetworkImage(""),
                            placeholder: AssetImage("assets/images/placeholder.png"),
                            fit: BoxFit.cover,
                          ) : Image.asset("assets/images/no_image_placeholder.jpg",
                            height: 30.0,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),

                    SizedBox(width: 10,),

                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.complaintModel.responderName != "null" && widget.complaintModel.responderName != "" ? widget.complaintModel.responderName : "",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 3,),

                          Text(
                            widget.complaintModel.respondedAt != "null" && widget.complaintModel.respondedAt != "" ? widget.complaintModel.responderRoleName +", "+ widget.complaintModel.responderSectorName : "",
                            maxLines: 2,
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
                    )
                  ],
                ),

                SizedBox(height: 10,),

                Text(
                  widget.complaintModel.complaintResponse != "null" && widget.complaintModel.complaintResponse != "" ? widget.complaintModel.complaintResponse : "",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal
                  ),
                ),

                SizedBox(height: 10,),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.complaintModel.respondedAt != "null" && widget.complaintModel.respondedAt != "" ? constants.GetFormatedDate(widget.complaintModel.respondedAt) : "",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 10,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          ) : Container()
        ],
      ),
    );
  }
}
