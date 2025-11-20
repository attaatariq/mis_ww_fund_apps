import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/ChildrenModel.dart';

class ChildrenListItemView extends StatefulWidget {
  ChildrenModel childrenModel;
  Constants constants;

  ChildrenListItemView(this.constants, this.childrenModel);

  @override
  _ChildrenListItemViewState createState() => _ChildrenListItemViewState();
}

class _ChildrenListItemViewState extends State<ChildrenListItemView> {
  String _calculateAge(String birthday) {
    if (birthday == null || birthday.isEmpty || birthday == "null" || birthday == "-" || birthday == "0000-00-00") {
      return "N/A";
    }
    
    try {
      var birthDate = DateFormat("yyyy-MM-dd").parse(birthday);
      var today = DateTime.now();
      var age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return "$age ${age == 1 ? 'Year' : 'Years'}";
    } catch (e) {
      return "N/A";
    }
  }

  String _formatDate(String date) {
    if (date == null || date.isEmpty || date == "null" || date == "-" || date == "0000-00-00") {
      return "N/A";
    }
    
    try {
      var parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      return DateFormat("MMM dd, yyyy").format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    String childImage = widget.childrenModel.child_image ?? "";
    String childName = widget.childrenModel.child_name ?? "";
    String childCnic = widget.childrenModel.child_cnic ?? "";
    String childGender = widget.childrenModel.child_gender ?? "";
    String childBirthday = widget.childrenModel.child_birthday ?? "";
    String childIdentity = widget.childrenModel.child_identity ?? "";
    
    bool isValidImage = childImage != "null" && 
                       childImage != "" && 
                       childImage != "NULL" &&
                       childImage != "-" &&
                       childImage != "N/A";
    
    String age = _calculateAge(childBirthday);
    String formattedBirthday = _formatDate(childBirthday);
    
    IconData genderIcon = childGender.toLowerCase() == "male" 
        ? Icons.male 
        : childGender.toLowerCase() == "female" 
            ? Icons.female 
            : Icons.person;
    
    Color genderColor = childGender.toLowerCase() == "male" 
        ? Colors.blue 
        : childGender.toLowerCase() == "female" 
            ? Colors.pink 
            : AppTheme.colors.colorDarkGray;
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child Image
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.colors.newPrimary.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.colors.newPrimary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: isValidImage
                    ? FadeInImage(
                        image: NetworkImage(widget.constants.getImageBaseURL() + childImage),
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
            
            SizedBox(width: 16),
            
            // Child Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Gender
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          childName.isNotEmpty ? childName : "Child",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 16,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: genderColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              genderIcon,
                              size: 14,
                              color: genderColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              childGender.isNotEmpty ? childGender : "N/A",
                              style: TextStyle(
                                color: genderColor,
                                fontSize: 11,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  // CNIC
                  if (childCnic.isNotEmpty && childCnic != "-" && childCnic != "null")
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: AppTheme.colors.colorDarkGray,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            childCnic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 6),
                  
                  // Age and Birthday
                  Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: 14,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                      SizedBox(width: 6),
                      Text(
                        age,
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (formattedBirthday != "N/A") ...[
                        Text(
                          " • ",
                          style: TextStyle(
                            color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            formattedBirthday,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.colorDarkGray.withOpacity(0.8),
                              fontSize: 11,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  SizedBox(height: 6),
                  
                  // Identity Type
                  if (childIdentity.isNotEmpty && childIdentity != "-" && childIdentity != "null")
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 14,
                          color: AppTheme.colors.colorDarkGray,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            childIdentity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 11,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
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
    );
  }
}
