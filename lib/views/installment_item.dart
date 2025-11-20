import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/dialogs/pay_installment_dialog_model.dart';
import 'package:wwf_apps/models/InstallmentModel.dart';
import 'package:wwf_apps/models/PayInstallmentDeatailModel.dart';
import 'package:wwf_apps/screens/general/image_viewer.dart';
import 'package:wwf_apps/screens/home/employee/pay_installment.dart';

class InstallmentItem extends StatefulWidget {
  InstallmentModel installmentModel;
  final parentFunction;

  InstallmentItem(this.installmentModel, this.parentFunction);

  @override
  _InstallmentItemState createState() => _InstallmentItemState();
}

class _InstallmentItemState extends State<InstallmentItem> {
  Constants constants;

  @override
  void initState() {
    super.initState();
    constants= new Constants();
  }

  bool get isPaid => widget.installmentModel.ins_balance == "0.00" || 
                     widget.installmentModel.ins_balance == "0" ||
                     (double.tryParse(widget.installmentModel.ins_balance ?? "1") ?? 1) <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid 
              ? AppTheme.colors.colorExelent.withOpacity(0.3)
              : AppTheme.colors.newPrimary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Installment Number and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isPaid 
                            ? AppTheme.colors.colorExelent.withOpacity(0.1)
                            : AppTheme.colors.newPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isPaid ? Icons.check_circle : Icons.pending,
                        color: isPaid 
                            ? AppTheme.colors.colorExelent
                            : AppTheme.colors.newPrimary,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.installmentModel.ins_number ?? "Installment",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 16,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: AppTheme.colors.colorDarkGray,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Due Date: ${widget.installmentModel.ins_duedate ?? "N/A"}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppTheme.colors.colorDarkGray,
                                  fontSize: 11,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.normal,
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
              if (!isPaid)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PayInstallment(widget.installmentModel)
                      )).then((value) => {
                        if(value != null){
                          if(value){
                            widget.parentFunction()
                          }
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.colors.colorExelent,
                            AppTheme.colors.colorExelent.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colors.colorExelent.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.payment,
                            color: AppTheme.colors.newWhite,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "PAY NOW",
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (isPaid)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.colorExelent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.colors.colorExelent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.colors.colorExelent,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "PAID",
                        style: TextStyle(
                          color: AppTheme.colors.colorExelent,
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

          // Financial Details
          Row(
            children: [
              Expanded(
                child: _buildAmountCard(
                  "Total Amount",
                  widget.installmentModel.ins_amount ?? "0.00",
                  Icons.account_balance_wallet,
                  AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildAmountCard(
                  "Paid",
                  widget.installmentModel.ins_payment ?? "0.00",
                  Icons.payment,
                  AppTheme.colors.colorExelent,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildAmountCard(
                  "Balance",
                  widget.installmentModel.ins_balance ?? "0.00",
                  Icons.balance,
                  isPaid ? AppTheme.colors.colorExelent : Colors.orange,
                ),
              ),
            ],
          ),

          // Bank Details (if paid)
          if (isPaid && widget.installmentModel.ins_bank_name != null && 
              widget.installmentModel.ins_bank_name != "null" && 
              widget.installmentModel.ins_bank_name.isNotEmpty)
            Column(
              children: [
                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.colorExelent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.colors.colorExelent.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance,
                            size: 16,
                            color: AppTheme.colors.colorExelent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Payment Details",
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 13,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bank Name",
                                  style: TextStyle(
                                    color: AppTheme.colors.colorDarkGray,
                                    fontSize: 11,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  widget.installmentModel.ins_bank_name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppTheme.colors.newBlack,
                                    fontSize: 12,
                                    fontFamily: "AppFont",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.installmentModel.ins_challan_no != null && 
                              widget.installmentModel.ins_challan_no != "null" &&
                              widget.installmentModel.ins_challan_no.isNotEmpty)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Challan No",
                                    style: TextStyle(
                                      color: AppTheme.colors.colorDarkGray,
                                      fontSize: 11,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.installmentModel.ins_challan_no,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppTheme.colors.newBlack,
                                      fontSize: 12,
                                      fontFamily: "AppFont",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (widget.installmentModel.ins_challan != null && 
                          widget.installmentModel.ins_challan != "null" &&
                          widget.installmentModel.ins_challan != "" &&
                          widget.installmentModel.ins_challan != "-")
                        Column(
                          children: [
                            SizedBox(height: 12),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ImageViewer(constants.getImageBaseURL()+widget.installmentModel.ins_challan)
                                  ));
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.newPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.colors.newPrimary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.receipt,
                                        size: 16,
                                        color: AppTheme.colors.newPrimary,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "View Challan",
                                        style: TextStyle(
                                          color: AppTheme.colors.newPrimary,
                                          fontSize: 12,
                                          fontFamily: "AppFont",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
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

          // Remarks (if available)
          if (widget.installmentModel.ins_remarks != null && 
              widget.installmentModel.ins_remarks != "null" &&
              widget.installmentModel.ins_remarks.isNotEmpty &&
              widget.installmentModel.ins_remarks != "-")
            Column(
              children: [
                SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: 16,
                      color: AppTheme.colors.colorDarkGray,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Remarks",
                            style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 11,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.installmentModel.ins_remarks,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(String label, String amount, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.colors.colorDarkGray,
                    fontSize: 10,
                    fontFamily: "AppFont",
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            amount + " PKR",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<PayInstallmentDetailModel> OpenPaymentDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: PayInstalmentDialogModel(widget.installmentModel),
          );
        }
    );
  }

  StartPayInstallment(PayInstallmentDetailModel value) {

  }
}
