import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/TurnoverHistoryModel.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

class TurnOverHistoryItem extends StatefulWidget {
  TurnoverHistoryModel turnoverHistoryModel;
  bool isCurrent;

  TurnOverHistoryItem(this.turnoverHistoryModel, {this.isCurrent = false});

  @override
  _TurnOverHistoryItemState createState() => _TurnOverHistoryItemState();
}

class _TurnOverHistoryItemState extends State<TurnOverHistoryItem> {
  Constants constants;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
  }
  
  @override
  Widget build(BuildContext context) {
    String compName = widget.turnoverHistoryModel.comp_name ?? "";
    String compAddress = widget.turnoverHistoryModel.comp_address ?? "";
    String cityName = widget.turnoverHistoryModel.city_name ?? "";
    String districtName = widget.turnoverHistoryModel.district_name ?? "";
    String stateName = widget.turnoverHistoryModel.state_name ?? "";
    String compStatus = widget.turnoverHistoryModel.comp_status ?? "";
    String appointedAt = widget.turnoverHistoryModel.appointed_at ?? "";
    String compType = widget.turnoverHistoryModel.comp_type ?? "";
    String compLandline = widget.turnoverHistoryModel.comp_landline ?? "";

    // Build location string
    List<String> locationParts = [];
    if (cityName.isNotEmpty && cityName != "null") locationParts.add(cityName);
    if (districtName.isNotEmpty && districtName != "null") locationParts.add(districtName);
    if (stateName.isNotEmpty && stateName != "null") locationParts.add(stateName);
    String location = locationParts.isNotEmpty ? locationParts.join(", ") : (compAddress.isNotEmpty && compAddress != "null" ? compAddress : "Location not available");

    // Format appointed date
    String formattedDate = "";
    if (appointedAt.isNotEmpty && appointedAt != "null") {
      try {
        formattedDate = constants.GetFormatedDate(appointedAt);
      } catch (e) {
        formattedDate = appointedAt;
      }
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isCurrent 
              ? AppTheme.colors.newPrimary.withOpacity(0.3)
              : AppTheme.colors.colorDarkGray.withOpacity(0.2),
          width: widget.isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isCurrent
                ? AppTheme.colors.newPrimary.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status badge
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: widget.isCurrent
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.colors.newPrimary,
                        AppTheme.colors.newPrimary.withOpacity(0.8),
                      ],
                    )
                  : null,
              color: widget.isCurrent ? null : AppTheme.colors.colorLightGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: widget.isCurrent
                        ? AppTheme.colors.newWhite.withOpacity(0.2)
                        : AppTheme.colors.newPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.business,
                      size: 22,
                      color: widget.isCurrent
                          ? AppTheme.colors.newWhite
                          : AppTheme.colors.newPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              compName.isNotEmpty ? compName : "Company Name",
                              style: TextStyle(
                                color: widget.isCurrent
                                    ? AppTheme.colors.newWhite
                                    : AppTheme.colors.newBlack,
                                fontSize: 15,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.isCurrent)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.colors.newWhite.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Current",
                                style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 10,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: widget.isCurrent
                              ? AppTheme.colors.newWhite.withOpacity(0.9)
                              : AppTheme.colors.colorDarkGray,
                          fontSize: 11,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Details Section
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Type & Status
                Row(
                  children: [
                    if (compType.isNotEmpty && compType != "null")
                      Expanded(
                        child: _buildDetailItem(
                          Icons.category,
                          "Type",
                          compType,
                        ),
                      ),
                    if (compType.isNotEmpty && compType != "null" && compStatus.isNotEmpty && compStatus != "null")
                      SizedBox(width: 12),
                    if (compStatus.isNotEmpty && compStatus != "null")
                      Expanded(
                        child: _buildDetailItem(
                          Icons.info_outline,
                          "Status",
                          compStatus,
                        ),
                      ),
                  ],
                ),

                if ((compType.isNotEmpty && compType != "null") || (compStatus.isNotEmpty && compStatus != "null"))
                  SizedBox(height: 12),

                // Appointed Date
                if (formattedDate.isNotEmpty)
                  _buildDetailItem(
                    Icons.calendar_today,
                    "Appointed At",
                    formattedDate,
                  ),

                if (formattedDate.isNotEmpty) SizedBox(height: 12),

                // Address
                if (compAddress.isNotEmpty && compAddress != "null")
                  _buildDetailItem(
                    Icons.location_on,
                    "Address",
                    compAddress,
                  ),

                if (compAddress.isNotEmpty && compAddress != "null") SizedBox(height: 12),

                // Landline
                if (compLandline.isNotEmpty && compLandline != "null")
                  _buildDetailItem(
                    Icons.phone,
                    "Landline",
                    compLandline,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.colors.colorLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTheme.colors.newPrimary),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.colors.newBlack,
                    fontSize: 12,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
