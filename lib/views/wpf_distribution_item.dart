import 'package:flutter/material.dart';
import 'package:wwf_apps/models/WPFDistributionModel.dart';

import '../colors/app_colors.dart';

class WPFDistributionItem extends StatefulWidget {
  WPFDistributionModel wpfDistributionModel;

  WPFDistributionItem(this.wpfDistributionModel);

  @override
  _WPFDistributionItemState createState() => _WPFDistributionItemState();
}

class _WPFDistributionItemState extends State<WPFDistributionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colors.colorDarkGray),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Financial Year",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),

                    Text(
                      widget.wpfDistributionModel.anx_financial,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      "("+widget.wpfDistributionModel.anx_received+")",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Distributions",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),

                    Text(
                      widget.wpfDistributionModel.anx_dispensed,
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
                      "(Between "+widget.wpfDistributionModel.anx_workers+" Workers)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contributions",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),

                    Text(
                      widget.wpfDistributionModel.anx_transfered,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      widget.wpfDistributionModel.anx_mode == "Cash" ? "("+widget.wpfDistributionModel.anx_mode +" : "+widget.wpfDistributionModel.anx_number+")" : "(WWF 2%: "+widget.wpfDistributionModel.anx_percent+")",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transfer at",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),

                    Text(
                      widget.wpfDistributionModel.anx_paid_at,
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
                      "("+widget.wpfDistributionModel.anx_bank+")",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 10,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
