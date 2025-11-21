import 'package:flutter/material.dart';
import 'package:wwf_apps/models/InterstDistributionModel.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/viewer/ImageViewer.dart';

class InterstDistributionItem extends StatefulWidget {
  InterstDistributionModel interstDistributionModel;

  InterstDistributionItem(this.interstDistributionModel);

  @override
  _InterstDistributionItemState createState() => _InterstDistributionItemState();
}

class _InterstDistributionItemState extends State<InterstDistributionItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants = new Constants();
  }

  @override
  Widget build(BuildContext context) {
    String anxYear = widget.interstDistributionModel.anx_year ?? "";
    String anxFinancial = widget.interstDistributionModel.anx_financial ?? "";
    String anxReceived = widget.interstDistributionModel.anx_received ?? "";
    String anxDispensed = widget.interstDistributionModel.anx_dispensed ?? "";
    String anxWorkers = widget.interstDistributionModel.anx_workers ?? "";
    String anxTransfered = widget.interstDistributionModel.anx_transfered ?? "";
    String anxBank = widget.interstDistributionModel.anx_bank ?? "";
    String anxPayment = widget.interstDistributionModel.anx_payment ?? "";
    String anxPaidAt = widget.interstDistributionModel.anx_paid_at ?? "";
    String anxProof = widget.interstDistributionModel.anx_proof ?? "";
    String anxMode = widget.interstDistributionModel.anx_mode ?? "";
    String anxNumber = widget.interstDistributionModel.anx_number ?? "";
    String anxStatement = widget.interstDistributionModel.anx_statement ?? "";
    String compName = widget.interstDistributionModel.comp_name ?? "";
    String compLogo = widget.interstDistributionModel.comp_logo ?? "";

    bool isValidLogo = compLogo != null &&
                      compLogo.isNotEmpty &&
                      compLogo != "null" &&
                      compLogo != "-" &&
                      compLogo != "N/A";

    bool isValidProof = anxProof != null &&
                        anxProof.isNotEmpty &&
                        anxProof != "null" &&
                        anxProof != "-" &&
                        anxProof != "N/A";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF2196F3).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2196F3).withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Company Info
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2196F3),
                  Color(0xFF2196F3).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.5),
                topRight: Radius.circular(14.5),
              ),
            ),
            child: Row(
              children: [
                // Company Logo
                if (isValidLogo)
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.newWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.colors.newWhite.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadeInImage(
                        image: NetworkImage(constants.getImageBaseURL() + compLogo),
                        placeholder: AssetImage("archive/images/no_image.jpg"),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "archive/images/no_image.jpg",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                if (isValidLogo) SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.newWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Annexure-II",
                          style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        compName.isNotEmpty ? compName : "Company Name",
                        style: TextStyle(
                          color: AppTheme.colors.newWhite,
                          fontSize: 15,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                // Financial Year & Statement
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        Icons.calendar_today,
                        "Financial Year",
                        anxFinancial.isNotEmpty ? anxFinancial : "N/A",
                        Color(0xFF2196F3),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.assessment,
                        "Statement",
                        anxStatement.isNotEmpty ? anxStatement : "N/A",
                        anxStatement == "Profit" ? Color(0xFF4CAF50) : Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Year & Received Date
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        Icons.date_range,
                        "Year",
                        anxYear.isNotEmpty ? anxYear : "N/A",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoRow(
                        Icons.event,
                        "Received",
                        anxReceived.isNotEmpty ? constants.GetFormatedDate(anxReceived) : "N/A",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Financial Summary
                _buildSectionHeader("Financial Summary"),
                SizedBox(height: 12),

                // Dispensed Amount
                _buildFinancialCard(
                  Icons.account_balance_wallet,
                  "Total Dispensed",
                  anxDispensed.isNotEmpty ? _formatAmount(anxDispensed) : "0.00 PKR",
                  Color(0xFF4CAF50),
                ),

                SizedBox(height: 12),

                // Workers Count
                _buildInfoCard(
                  Icons.people,
                  "Workers",
                  anxWorkers.isNotEmpty ? anxWorkers : "0",
                  Color(0xFF2196F3),
                ),

                SizedBox(height: 12),

                // Transfered Amount
                _buildFinancialCard(
                  Icons.swap_horiz,
                  "Total Transfered",
                  anxTransfered.isNotEmpty ? _formatAmount(anxTransfered) : "0.00 PKR",
                  Color(0xFFFF9800),
                ),

                // Payment Amount (if available)
                if (anxPayment.isNotEmpty && anxPayment != "null" && anxPayment != "0.00") ...[
                  SizedBox(height: 12),
                  _buildFinancialCard(
                    Icons.payments,
                    "Total Payment",
                    _formatAmount(anxPayment),
                    Color(0xFF9C27B0),
                  ),
                ],

                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),

                // Payment Information
                _buildSectionHeader("Payment Information"),
                SizedBox(height: 12),

                // Payment Mode & Number
                if (anxMode.isNotEmpty && anxMode != "null")
                  _buildInfoRow(
                    Icons.payment,
                    "Payment Mode",
                    anxMode,
                  ),
                if (anxMode.isNotEmpty && anxMode != "null") SizedBox(height: 8),
                if (anxNumber != null && anxNumber.isNotEmpty && anxNumber != "null")
                  _buildInfoRow(
                    Icons.confirmation_number,
                    "Payment Number",
                    anxNumber,
                  ),

                SizedBox(height: 12),

                // Bank & Paid At
                if (anxBank != null && anxBank.isNotEmpty && anxBank != "null") ...[
                  _buildInfoRow(
                    Icons.account_balance,
                    "Bank",
                    anxBank,
                  ),
                  SizedBox(height: 8),
                ],
                if (anxPaidAt != null && anxPaidAt.isNotEmpty && anxPaidAt != "null")
                  _buildInfoRow(
                    Icons.calendar_today,
                    "Paid At",
                    constants.GetFormatedDate(anxPaidAt),
                  ),

                // Proof Document
                if (isValidProof) ...[
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                  SizedBox(height: 12),
                  _buildSectionHeader("Proof Document"),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(
                            constants.getImageBaseURL() + anxProof,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFF2196F3).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Color(0xFF2196F3),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "View Proof Document",
                              style: TextStyle(
                                color: Color(0xFF2196F3),
                                fontSize: 13,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF2196F3),
                            size: 16,
                          ),
                        ],
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

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.colors.newBlack,
            fontSize: 15,
            fontFamily: "AppFont",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
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
                    color: color,
                    fontSize: 16,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          Icon(icon, size: 14, color: Color(0xFF2196F3)),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    if (amount.isEmpty || amount == "null" || amount == "-") {
      return "0.00 PKR";
    }
    try {
      double value = double.parse(amount);
      return constants.ConvertMappedNumber(amount) + " PKR";
    } catch (e) {
      return amount + " PKR";
    }
  }
}
