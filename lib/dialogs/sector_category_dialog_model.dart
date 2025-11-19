import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';

class SectorCategoryDialogModel extends StatefulWidget {

  @override
  _SectorCategoryDialogModelState createState() => _SectorCategoryDialogModelState();
}

class _SectorCategoryDialogModelState extends State<SectorCategoryDialogModel> {

  Constants constants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 200,
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
          color: AppTheme.colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),

        child: Container(
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.colors.newPrimary,
                      Color.lerp(AppTheme.colors.newPrimary, Colors.black, 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Please Select Registration Type",
                        style: TextStyle(
                            color: AppTheme.colors.white,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.w600
                        ),),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 0.5,
                        width: double.infinity,
                        color: AppTheme.colors.colorDarkGray,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      _buildDialogOption(
                        onTap: () {
                          Navigator.of(context).pop(constants.selectorCategoryFirstName);
                        },
                        text: constants.selectorCategoryFirstName,
                        icon: Icons.business_center,
                        hasDivider: true,
                      ),

                      _buildDialogOption(
                        onTap: () {
                          Navigator.of(context).pop(constants.selectorCategorySecondName);
                        },
                        text: constants.selectorCategorySecondName,
                        icon: Icons.work_outline,
                        hasDivider: true,
                      ),

                      _buildDialogOption(
                        onTap: () {
                          Navigator.of(context).pop(constants.selectorCategoryThirdName);
                        },
                        text: constants.selectorCategoryThirdName,
                        icon: Icons.badge_outlined,
                        hasDivider: false,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    Function onTap,
    String text,
    IconData icon,
    bool hasDivider,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.newPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: AppTheme.colors.newPrimary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 14,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.colors.colorDarkGray,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            if (hasDivider)
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: AppTheme.colors.colorLightGray,
              ),
          ],
        ),
      ),
    );
  }
}
