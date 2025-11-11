import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/screens/general/change_password.dart';
import 'package:welfare_claims_app/screens/general/complaints.dart';
import 'package:welfare_claims_app/screens/general/faqs.dart';
import 'package:welfare_claims_app/screens/general/my_profile.dart';
import 'package:welfare_claims_app/screens/general/notifications_alerts.dart';
import 'package:welfare_claims_app/screens/general/send_feedback.dart';
import 'package:welfare_claims_app/screens/general/turn_over_history.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_beneficiary.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_child.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_child_education.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/add_self_education.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/beneficiary_detail.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/childrens_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/death_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/death_claim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/education_claim_types.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/employee_turnover.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/estate_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/hajj_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/hajj_claim_detail.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/marriage_calim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/marriage_claim.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/education_claim_list.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/self_education_list.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';

class EmployeeDrawerView extends StatefulWidget {
  @override
  _EmployeeDrawerViewState createState() => _EmployeeDrawerViewState();
}

class _EmployeeDrawerViewState extends State<EmployeeDrawerView> {
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
      color: AppTheme.colors.white,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.newPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.colors.newWhite,
                        border: Border.all(
                          color: AppTheme.colors.newWhite,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: UserSessions.instance.getUserImage != "null" && 
                               UserSessions.instance.getUserImage != "" && 
                               UserSessions.instance.getUserImage != "NULL" && 
                               UserSessions.instance.getUserImage != "N/A" 
                          ? FadeInImage(
                              image: NetworkImage(constants.getImageBaseURL() + UserSessions.instance.getUserImage),
                              placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/no_image_placeholder.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/images/no_image_placeholder.jpg",
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      UserSessions.instance.getUserName,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          color: AppTheme.colors.newWhite.withOpacity(0.9),
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            UserSessions.instance.getUserCNIC,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.newWhite.withOpacity(0.9),
                              fontSize: 13,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  _buildSectionHeader("Claims"),

                  _buildMenuItem(
                    icon: Icons.school,
                    iconAsset: "assets/images/educational.png",
                    title: "Educational Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EducationClaimList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.favorite,
                    iconAsset: "assets/images/merriage.png",
                    title: "Marriage Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MarriageClaimList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    iconAsset: "assets/images/death.png",
                    title: "Death Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DeathClaimList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.home_work,
                    iconAsset: "assets/images/estate_claim.png",
                    title: "Estate Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EstateClaim()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.mosque,
                    iconAsset: "assets/images/hajj_icon.png",
                    title: "Hajj Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HajjClaim()
                      ));
                    },
                  ),


                  _buildSectionHeader("Information"),

                  _buildMenuItem(
                    icon: Icons.school_outlined,
                    iconAsset: "assets/images/education.png",
                    title: "Self Education",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SelfEducationList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.child_care,
                    iconAsset: "assets/images/childrens.png",
                    title: "Children's",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ChildrenList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.add_circle_outline,
                    iconAsset: "assets/images/child_education.png",
                    title: "Add Children Education",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddChildEducation()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.account_circle_outlined,
                    iconAsset: "assets/images/beneficiary.png",
                    title: "Beneficiary",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BeneficiaryDetail()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.swap_horiz,
                    iconAsset: "assets/images/employee_turnover.png",
                    title: "Turn-Over",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EmployeeTurnOver()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.history,
                    iconAsset: "assets/images/turn_over_history.png",
                    title: "Turn-Over History",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TurnOverHistory()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    iconAsset: "assets/images/bell.png",
                    title: "Notifications",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NotificationsAndAlerts()
                      ));
                    },
                  ),

                  _buildSectionHeader("Settings"),

                  _buildMenuItem(
                    icon: Icons.person_outline,
                    iconAsset: "assets/images/profile.png",
                    title: "My Profile",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyProfile()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    iconAsset: "assets/images/key.png",
                    title: "Change Password",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ChangePassword()
                      ));
                    },
                  ),

                  _buildSectionHeader("Preferences"),

                  _buildMenuItem(
                    icon: Icons.report_problem_outlined,
                    iconAsset: "assets/images/complaint.png",
                    title: "Complaints",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Complaints()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.feedback_outlined,
                    iconAsset: "assets/images/feedback.png",
                    title: "Send Feedback",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SendFeedback()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    iconAsset: "assets/images/faqs.png",
                    title: "FAQs",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FAQs()
                      ));
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.colors.newPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.colors.newPrimary,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for menu items
  Widget _buildMenuItem({
    IconData icon,
    String iconAsset,
    String title,
    VoidCallback onTap,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.newPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: iconAsset != null
                          ? Image.asset(
                              iconAsset,
                              height: 18,
                              width: 18,
                              color: AppTheme.colors.newPrimary,
                            )
                          : Icon(
                              icon,
                              color: AppTheme.colors.newPrimary,
                              size: 18,
                            ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.colors.newBlack,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.colors.colorDarkGray,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: AppTheme.colors.colorLightGray.withOpacity(0.5),
        ),
      ],
    );
  }
}
