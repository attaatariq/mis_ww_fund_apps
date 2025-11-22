import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

void showInixioProfileDialog(BuildContext context) {
  final constants = Constants();
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage(
                        image: NetworkImage(
                          constants.getImageBaseURL() + "resources/upload/inixio/logo.png",
                        ),
                        placeholder: AssetImage("archive/images/no_image.jpg"),
                        fit: BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "IT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Company Name
                  Text(
                    "Inixio Technologies",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 24,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Tagline
                  Text(
                    "Innovating Digital Solutions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // About Section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.colors.newPrimary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "About Us",
                              style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 16,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Inixio Technologies is a leading software development company specializing in cutting-edge digital solutions. We excel in web development, mobile app development, DevOps, artificial intelligence, and automation services.\n\nOur team of expert developers and engineers is committed to delivering innovative, scalable, and secure solutions that drive business growth and digital transformation.",
                          style: TextStyle(
                            color: AppTheme.colors.newBlack.withOpacity(0.7),
                            fontSize: 13,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Services
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.engineering_outlined,
                              color: AppTheme.colors.newPrimary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Our Services",
                              style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 16,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildServiceItem(Icons.language, "Web Development"),
                        _buildServiceItem(Icons.phone_android, "Mobile App Development"),
                        _buildServiceItem(Icons.cloud_outlined, "DevOps & Cloud Solutions"),
                        _buildServiceItem(Icons.psychology_outlined, "Artificial Intelligence"),
                        _buildServiceItem(Icons.settings_suggest, "Automation Services"),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Contact Information
                  _buildContactButton(
                    icon: Icons.language,
                    label: "Website",
                    value: "inixiotechnologies.com",
                    onTap: () => _launchURL("https://inixiotechnologies.com"),
                  ),
                  
                  SizedBox(height: 12),
                  
                  _buildContactButton(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: "info@inixiotechnologies.com",
                    onTap: () => _launchURL("mailto:info@inixiotechnologies.com"),
                  ),
                  
                  SizedBox(height: 12),
                  
                  _buildContactButton(
                    icon: Icons.phone_outlined,
                    label: "Phone",
                    value: "+92 (333) 665 8622",
                    onTap: () => _launchURL("tel:+923336658622"),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // CEO Section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.colors.newPrimary.withOpacity(0.1),
                          AppTheme.colors.newPrimary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.colors.newPrimary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.colors.newPrimary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.colors.newPrimary.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: FadeInImage(
                              image: NetworkImage(
                                constants.getImageBaseURL() + "resources/upload/inixio/ceo.png",
                              ),
                              placeholder: AssetImage("archive/images/no_image.jpg"),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    color: AppTheme.colors.newPrimary,
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Atta Ullah Tariq",
                                style: TextStyle(
                                  color: AppTheme.colors.newBlack,
                                  fontSize: 16,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Chief Executive Officer",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Full Stack Developer & DevOps Engineer",
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray.withOpacity(0.8),
                                  fontSize: 11,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildServiceItem(IconData icon, String service) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.colors.newPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.colors.newPrimary,
            size: 16,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            service,
            style: TextStyle(
              color: AppTheme.colors.newBlack.withOpacity(0.85),
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildContactButton({
  IconData icon,
  String label,
  String value,
  VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.colors.newPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.colors.newPrimary,
                size: 20,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 13,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
              size: 18,
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

