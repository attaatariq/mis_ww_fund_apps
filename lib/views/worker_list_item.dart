import 'package:flutter/material.dart';
import 'package:wwf_apps/models/WorkerModel.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';

class WorkerListItem extends StatefulWidget {
  WorkerModel workerModel;

  WorkerListItem(this.workerModel);

  @override
  _WorkerListItemState createState() => _WorkerListItemState();
}

class _WorkerListItemState extends State<WorkerListItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.workerModel.user_name ?? "";
    String userImage = widget.workerModel.user_image ?? "";
    String userCNIC = widget.workerModel.user_cnic ?? "";
    String userGender = widget.workerModel.user_gender ?? "";
    String userContact = widget.workerModel.user_contact ?? "";
    String empId = widget.workerModel.emp_id ?? "";
    String empStatus = widget.workerModel.emp_status ?? "";
    String empAbout = widget.workerModel.emp_about ?? "";
    String cityName = widget.workerModel.city_name ?? "";
    String districtName = widget.workerModel.district_name ?? "";
    String stateName = widget.workerModel.state_name ?? "";
    String empCheck = widget.workerModel.emp_check ?? "";

    bool isValidImage = userImage != null &&
                        userImage.isNotEmpty &&
                        userImage != "null" &&
                        userImage != "-" &&
                        userImage != "N/A";

    // Build location string
    List<String> locationParts = [];
    if (cityName.isNotEmpty && cityName != "null") locationParts.add(cityName.trim());
    if (districtName.isNotEmpty && districtName != "null") locationParts.add(districtName.trim());
    if (stateName.isNotEmpty && stateName != "null") locationParts.add(stateName.trim());
    String location = locationParts.isNotEmpty
        ? locationParts.join(", ")
        : "Location not available";

    // Status color
    Color statusColor = empStatus == "Active"
        ? Color(0xFF4CAF50)
        : Color(0xFFFF9800);

    // Check status color
    Color checkColor = empCheck == "Pending"
        ? Color(0xFFFF9800)
        : empCheck == "Approved"
            ? Color(0xFF4CAF50)
            : Color(0xFFF44336);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.colors.newPrimary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.colors.newPrimary,
                  AppTheme.colors.newPrimary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.5),
                topRight: Radius.circular(14.5),
              ),
            ),
            child: Row(
              children: [
                // Profile Image
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.colors.newWhite.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: isValidImage
                        ? FadeInImage(
                            image: NetworkImage(constants.getImageBaseURL() + userImage),
                            placeholder: AssetImage("archive/images/no_image.jpg"),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "archive/images/no_image.jpg",
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            "archive/images/no_image.jpg",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName.isNotEmpty ? userName : "Worker Name",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 16,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 12,
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              userCNIC.isNotEmpty ? userCNIC : "N/A",
                              style: TextStyle(
                                color: AppTheme.colors.newWhite.withOpacity(0.9),
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badges
                Row(
                  children: [
                    if (empStatus.isNotEmpty && empStatus != "null")
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: statusColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              empStatus,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (empStatus.isNotEmpty && empStatus != "null" && empCheck.isNotEmpty && empCheck != "null")
                      SizedBox(width: 8),
                    if (empCheck.isNotEmpty && empCheck != "null")
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: checkColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: checkColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: checkColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              empCheck,
                              style: TextStyle(
                                color: checkColor,
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Employee ID
                if (empId.isNotEmpty && empId != "null")
                  _buildInfoRow(
                    Icons.badge,
                    "Employee ID",
                    empId,
                  ),
                if (empId.isNotEmpty && empId != "null") SizedBox(height: 12),

                // Gender
                if (userGender.isNotEmpty && userGender != "null")
                  _buildInfoRow(
                    userGender == "Male" ? Icons.male : Icons.female,
                    "Gender",
                    userGender,
                  ),
                if (userGender.isNotEmpty && userGender != "null") SizedBox(height: 12),

                // Contact
                if (userContact.isNotEmpty && userContact != "null")
                  _buildInfoRow(
                    Icons.phone,
                    "Contact",
                    userContact,
                  ),
                if (userContact.isNotEmpty && userContact != "null") SizedBox(height: 12),

                // Location
                _buildInfoRow(
                  Icons.location_on,
                  "Location",
                  location,
                ),

                // About
                if (empAbout.isNotEmpty && empAbout != "null") ...[
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                  SizedBox(height: 12),
                  Text(
                    "About",
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.colorLightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      empAbout,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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

