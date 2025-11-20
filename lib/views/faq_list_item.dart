import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/models/FaqModel.dart';

class FaqListItem extends StatefulWidget {
  FaqModel faqModel;

  FaqListItem(this.faqModel);

  @override
  _FaqListItemState createState() => _FaqListItemState();
}

class _FaqListItemState extends State<FaqListItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.faqModel.isOpen
              ? AppTheme.colors.newPrimary.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: widget.faqModel.isOpen ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.faqModel.isOpen
                ? AppTheme.colors.newPrimary.withOpacity(0.1)
                : Colors.black.withOpacity(0.06),
            blurRadius: widget.faqModel.isOpen ? 12 : 8,
            offset: Offset(0, widget.faqModel.isOpen ? 4 : 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Question Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.faqModel.isOpen
                        ? AppTheme.colors.newPrimary.withOpacity(0.1)
                        : AppTheme.colors.colorDarkGray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: widget.faqModel.isOpen
                        ? AppTheme.colors.newPrimary
                        : AppTheme.colors.colorDarkGray,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.faqModel.faq_question ?? "Question",
                        maxLines: widget.faqModel.isOpen ? null : 2,
                        overflow: widget.faqModel.isOpen ? null : TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.colors.newBlack,
                          fontSize: 15,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      if (widget.faqModel.faq_type != null && widget.faqModel.faq_type.isNotEmpty)
                        SizedBox(height: 4),
                      if (widget.faqModel.faq_type != null && widget.faqModel.faq_type.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.faqModel.faq_type,
                            style: TextStyle(
                              color: AppTheme.colors.newPrimary,
                              fontSize: 10,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                AnimatedRotation(
                  turns: widget.faqModel.isOpen ? 0.5 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: widget.faqModel.isOpen
                        ? AppTheme.colors.newPrimary
                        : AppTheme.colors.colorDarkGray,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Answer Section (Expandable)
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Divider(
                    color: AppTheme.colors.newPrimary.withOpacity(0.2),
                    height: 1,
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.newPrimary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.colors.newPrimary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.colors.newPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.faqModel.faq_answer ?? "",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.faqModel.created_at != null && widget.faqModel.created_at.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppTheme.colors.colorDarkGray,
                          ),
                          SizedBox(width: 4),
                          Text(
                            constants.GetFormatedDateWithoutTime(widget.faqModel.created_at),
                            style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 11,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            crossFadeState: widget.faqModel.isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

