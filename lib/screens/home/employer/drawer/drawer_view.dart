import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/screens/general/complaints.dart';
import 'package:wwf_apps/screens/general/faqs.dart';
import 'package:wwf_apps/screens/general/notifications_screen.dart';
import 'package:wwf_apps/screens/general/notices_news_screen.dart';
import 'package:wwf_apps/dialogs/feedback_dialog.dart';
import 'package:wwf_apps/screens/home/employer/contact_person.dart';
import 'package:wwf_apps/screens/home/employer/death_claim_list.dart';
import 'package:wwf_apps/screens/home/employer/estate_claims.dart';
import 'package:wwf_apps/screens/home/employer/hajj_claims.dart';
import 'package:wwf_apps/screens/home/employer/education_claims.dart';
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
import '../workers_list.dart';
import '../add_worker.dart';
import '../employer_settings.dart';

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
                      textAlign: TextAlign.center,
                      maxLines: 2,
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
                  _buildSectionHeader("Team"),

                  _buildMenuItem(
                    icon: Icons.people_outline,
                    iconAsset: "archive/images/employee.png",
                    title: "Employees",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ContactPerson()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.construction_outlined,
                    iconAsset: "archive/images/worker.png",
                    title: "Workers",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => WorkersList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.person_add_outlined,
                    iconAsset: "archive/images/deo.png",
                    title: "DEO",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DeoDetail()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.verified_user_outlined,
                    iconAsset: "archive/images/verification.png",
                    title: "Verifications",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EmployeeVerification()
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
                    icon: Icons.favorite_border,
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
                    iconAsset: "archive/images/pilgrimage.png",
                    title: "Hajj Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HajjClaimList()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.school,
                    iconAsset: "archive/images/user_book.png",
                    title: "Education Claim",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EducationClaimList()
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
                    icon: Icons.settings_outlined,
                    iconAsset: "archive/images/settings.png",
                    title: "Settings",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EmployerSettings()
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
                      showFeedbackDialog(context);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    iconAsset: "archive/images/bell.png",
                    title: "Notifications",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NotificationsScreen()
                      ));
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.article_outlined,
                    iconAsset: "archive/images/notice.png",
                    title: "Notices & News",
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NoticesNewsScreen()
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.colors.newPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppTheme.colors.newPrimary.withOpacity(0.8),
          fontSize: 11,
          fontFamily: "AppFont",
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    IconData icon,
    String iconAsset,
    String title,
    VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: AppTheme.colors.newPrimary.withOpacity(0.08),
          highlightColor: AppTheme.colors.newPrimary.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newPrimary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: iconAsset != null
                        ? Image.asset(
                            iconAsset,
                            height: 16,
                            width: 16,
                            color: AppTheme.colors.newPrimary,
                          )
                        : Icon(
                            icon,
                            color: AppTheme.colors.newPrimary,
                            size: 16,
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack.withOpacity(0.85),
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.colors.colorDarkGray.withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
