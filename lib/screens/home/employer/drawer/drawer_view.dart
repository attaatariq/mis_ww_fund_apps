import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/screens/general/complaints.dart';
import 'package:wwf_apps/screens/general/faqs.dart';
import 'package:wwf_apps/screens/general/notifications_alerts.dart';
import 'package:wwf_apps/screens/general/send_feedback.dart';
import 'package:wwf_apps/screens/home/employer/contact_person.dart';
import 'package:wwf_apps/screens/home/employer/death_claim_list.dart';
import 'package:wwf_apps/screens/home/employer/estate_claims.dart';
import 'package:wwf_apps/screens/home/employer/hajj_claims.dart';
import 'package:wwf_apps/screens/home/employer/verifications.dart';
import 'package:wwf_apps/screens/home/employer/marriage_claims.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

import '../create_person.dart';
import '../stenotypist.dart';
import '../annexure2_create.dart';
import '../annexure1_create.dart';
import '../deo_detail.dart';
import '../annexure1_list.dart';
import '../annexure2_list.dart';

class EmployerDrawerView extends StatefulWidget {
  @override
  _EmployerDrawerViewState createState() => _EmployerDrawerViewState();
}

class _EmployerDrawerViewState extends State<EmployerDrawerView> {
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
                  _buildSectionHeader("Management"),

                  _buildMenuItem(
                    icon: Icons.person_outline,
                    iconAsset: "archive/images/stenotypist.png",
                    title: "Data Entry Operator",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DeoDetail()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.contact_phone_outlined,
                    iconAsset: "archive/images/person.png",
                    title: "Contact Person",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ContactPerson()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.verified_user_outlined,
                    iconAsset: "archive/images/verified.png",
                    title: "Workers Verification",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EmployeeVerification()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    iconAsset: "archive/images/bell.png",
                    title: "Notifications",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NotificationsAndAlerts()
                      ));
                    },
                  ),

                  _buildSectionHeader("Claims"),

                  _buildMenuItem(
                    icon: Icons.favorite,
                    iconAsset: "archive/images/merriage.png",
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
                    iconAsset: "archive/images/death.png",
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
                    iconAsset: "archive/images/estate.png",
                    title: "Estate Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EstateClaimList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.mosque,
                    iconAsset: "archive/images/hajj.png",
                    title: "Hajj Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HajjClaimList()
                      ));
                    },
                  ),

                  _buildSectionHeader("Contribute Us"),

                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    iconAsset: "archive/images/annexure.png",
                    title: "WPF Distribution Sheet",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => WpfDistributionList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    iconAsset: "archive/images/annexure.png",
                    title: "Interest Distribution Sheet",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => InterstDistributionList()
                      ));
                    },
                  ),

                  _buildSectionHeader("Settings"),

                  _buildMenuItem(
                    icon: Icons.business_outlined,
                    iconAsset: "archive/images/company.png",
                    title: "Company Detail",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddContactPerson()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.person_outline,
                    iconAsset: "archive/images/profile.png",
                    title: "My Profile",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddContactPerson()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    iconAsset: "archive/images/key.png",
                    title: "Change Password",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddContactPerson()
                      ));
                    },
                  ),

                  _buildSectionHeader("Preferences"),

                  _buildMenuItem(
                    icon: Icons.report_problem_outlined,
                    iconAsset: "archive/images/complaint.png",
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
                    iconAsset: "archive/images/feedback.png",
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
                    iconAsset: "archive/images/faqs.png",
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
