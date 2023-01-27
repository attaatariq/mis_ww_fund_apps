import 'package:flutter/material.dart';
import 'package:welfare_claims_app/models/WPFDistributionModel.dart';

import '../colors/app_colors.dart';
import '../models/InterstDistributionModel.dart';

class InterstDistributionItem extends StatefulWidget {
  InterstDistributionModel interstDistributionModel;

  InterstDistributionItem(this.interstDistributionModel);

  @override
  _InterstDistributionItemState createState() => _InterstDistributionItemState();
}

class _InterstDistributionItemState extends State<InterstDistributionItem> {
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
                      widget.interstDistributionModel.anx_financial,
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
                      "("+widget.interstDistributionModel.anx_received+")",
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
                      widget.interstDistributionModel.anx_dispensed,
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
                      "(Between "+widget.interstDistributionModel.anx_workers+" Workers)",
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
                      widget.interstDistributionModel.anx_transfered,
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
                      widget.interstDistributionModel.anx_mode == "Cash" ? "("+widget.interstDistributionModel.anx_mode +" : "+widget.interstDistributionModel.anx_number+")" : "(Total: "+widget.interstDistributionModel.anx_payment+")",
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
                      widget.interstDistributionModel.anx_paid_at,
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
                      "("+widget.interstDistributionModel.anx_bank+")",
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
