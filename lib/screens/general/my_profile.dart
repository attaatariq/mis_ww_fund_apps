import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/screens/general/edit_my_profile.dart';
import 'package:wwf_apps/screens/home/employee/verification_scrutiny_screen.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:wwf_apps/widgets/standard_header.dart';
import 'package:wwf_apps/dialogs/inixio_profile_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Constants constants;
  UIUpdates uiUpdates;
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userName = UserSessions.instance.getUserName ?? "";
    String userImage = UserSessions.instance.getUserImage ?? "";
    String userEmail = UserSessions.instance.getUserEmail ?? "";
    String userCNIC = UserSessions.instance.getUserCNIC ?? "";
    String userNumber = UserSessions.instance.getUserNumber ?? "";
    String userAbout = UserSessions.instance.getUserAbout ?? "";
    String userAccount = UserSessions.instance.getUserAccount ?? "";
    String userSector = UserSessions.instance.getUserSector ?? "";
    String userRole = UserSessions.instance.getUserRole ?? "";
    String userID = UserSessions.instance.getUserID ?? "";
    String empID = UserSessions.instance.getEmployeeID ?? "";
    String refID = UserSessions.instance.getRefID ?? "";
    String agentExpiry = UserSessions.instance.getAgentExpiry ?? "";

    bool isValidImage = userImage != "null" &&
                       userImage != "" &&
                       userImage != "NULL" &&
                       userImage != "-" &&
                       userImage != "N/A";

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          StandardHeader(
            title: "My Profile",
            actionIcon: Icons.edit,
            onActionPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EditProfile()
              )).then((value) {
                setState(() {});
              });
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Card
                  _buildProfileHeaderCard(userName, userImage, userEmail, userCNIC, isValidImage),

                  SizedBox(height: 16),

                  // Verification Status Card
                  _buildVerificationStatusCard(),

                  SizedBox(height: 16),

                  // About Section
                  if (userAbout.isNotEmpty && userAbout != "null" && userAbout != "-" && userAbout != "N/A")
                    _buildAboutCard(userAbout),

                  // Personal Information Section
                  _buildPersonalInfoCard(userName, userEmail, userNumber, userCNIC),

                  // Account Information Section
                  _buildAccountInfoCard(userAccount, userSector, userRole, userID, empID, refID),

                  // Additional Information (if available)
                  if (agentExpiry.isNotEmpty && agentExpiry != "null" && agentExpiry != "-")
                    _buildAdditionalInfoCard(agentExpiry),

                  SizedBox(height: 16),

                  // Footer - Powered by Inixio
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _buildInixioFooter(),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInixioFooter() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showInixioProfileDialog(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Powered by Inixio
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Powered by ",
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Inixio Technologies",
                    style: TextStyle(
                      color: AppTheme.colors.newPrimary,
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new,
                    color: AppTheme.colors.newPrimary,
                    size: 14,
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.1),
              ),
              
              SizedBox(height: 12),
              
              // Version and Copyright
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Version $appVersion",
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray.withOpacity(0.7),
                          fontSize: 11,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "© ${DateTime.now().year} WWF-Pakistan. All rights reserved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray.withOpacity(0.6),
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Developed & Maintained by Inixio Technologies",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray.withOpacity(0.6),
                      fontSize: 10,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(String name, String image, String email, String cnic, bool isValidImage) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.colors.newPrimary,
            AppTheme.colors.newPrimary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 24),
          // Profile Image
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.colors.newWhite.withOpacity(0.3),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: isValidImage
                  ? FadeInImage(
                      image: NetworkImage(constants.getImageBaseURL() + image),
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
          // Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              name.isNotEmpty ? name : "N/A",
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 22,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
          // Email
          if (email.isNotEmpty && email != "null" && email != "-")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, size: 14, color: AppTheme.colors.newWhite.withOpacity(0.9)),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      email,
                      style: TextStyle(
                        color: AppTheme.colors.newWhite.withOpacity(0.9),
                        fontSize: 13,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          // CNIC
          if (cnic.isNotEmpty && cnic != "null" && cnic != "-")
            Padding(
              padding: EdgeInsets.only(top: 4, left: 20, right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.badge_outlined, size: 14, color: AppTheme.colors.newWhite.withOpacity(0.9)),
                  SizedBox(width: 6),
                  Text(
                    cnic,
                    style: TextStyle(
                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAboutCard(String about) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "About",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 16,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            about,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(String name, String email, String number, String cnic) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Personal Information",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 16,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow(Icons.person, "Full Name", name.isNotEmpty ? name : "N/A"),
          if (email.isNotEmpty && email != "null" && email != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.email_outlined, "Email Address", email),
          ],
          if (number.isNotEmpty && number != "null" && number != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.phone_outlined, "Contact Number", number),
          ],
          if (cnic.isNotEmpty && cnic != "null" && cnic != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.badge_outlined, "CNIC", cnic),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard(String account, String sector, String role, String userID, String empID, String refID) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 18,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Account Information",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 16,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow(Icons.perm_identity, "User ID", userID.isNotEmpty ? userID : "N/A"),
          if (account.isNotEmpty && account != "null" && account != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.account_balance_wallet_outlined, "Account Type", account),
          ],
          if (sector.isNotEmpty && sector != "null" && sector != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.business_outlined, "Sector", sector),
          ],
          if (role.isNotEmpty && role != "null" && role != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.work_outline, "Role", role),
          ],
          if (empID.isNotEmpty && empID != "null" && empID != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.badge, "Employee ID", empID),
          ],
          if (refID.isNotEmpty && refID != "null" && refID != "-") ...[
            SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            SizedBox(height: 12),
            _buildInfoRow(Icons.business_center_outlined, "Company ID", refID),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoCard(String agentExpiry) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Additional Information",
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 16,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow(Icons.event_outlined, "Agent Expiry", agentExpiry),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.colors.colorLightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.colors.newPrimary,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
                  fontSize: 14,
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
    );
  }

  Widget _buildVerificationStatusCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50).withOpacity(0.1),
            Color(0xFF2196F3).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.colors.newPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScrutinyScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.verified_user,
                    color: AppTheme.colors.newPrimary,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Verification",
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 16,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "View your verification status and progress",
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.colors.newPrimary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
