import 'package:flutter/material.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/dialogs/pay_installment_dialog_model.dart';
import 'package:welfare_claims_app/models/InstallmentModel.dart';
import 'package:welfare_claims_app/models/PayInstallmentDeatailModel.dart';
import 'package:welfare_claims_app/screens/general/image_viewer.dart';
import 'package:welfare_claims_app/screens/home/EmployeeHomeData/pay_installment.dart';

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
    // TODO: implement initState
    super.initState();
    constants= new Constants();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 20,),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colors.colorDarkGray),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary,
                  borderRadius: BorderRadius.circular(50),
                ),

                child: Center(
                  child: Image(
                    image: AssetImage(
                        "assets/images/installment.png"),
                    alignment: Alignment.center,
                    height: 20.0,
                    width: 20.0,
                    color: AppTheme.colors.newWhite,
                  ),
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.installmentModel.ins_number,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newBlack,
                              fontSize: 13,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(
                          widget.installmentModel.ins_duedate,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 10,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),

                    widget.installmentModel.ins_balance != "0.00" ? InkWell(
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
                      child: Container(
                        height: 28,
                        width: 70,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppTheme.colors.colorExelent
                        ),

                        child: Center(
                          child: Text(
                            "PAY NOW",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 10,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              )
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Balance",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.installmentModel.ins_amount+" PKR",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  color: AppTheme.colors.colorDarkGray,
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.installmentModel.ins_balance == "0.00" ? InkWell(
                        onTap :(){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ImageViewer(constants.getImageBaseURL()+widget.installmentModel.ins_challan)
                          ));
                        },
                        child: Text(
                          "View Challan",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppTheme.colors.newPrimary,
                              fontSize: 12,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ): Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          widget.installmentModel.ins_bank_name.toString() != "null"  ? Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Name",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.installmentModel.ins_bank_name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Challan No",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.installmentModel.ins_challan_no,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ) : Container(),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Remarks",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.colorDarkGray,
                            fontSize: 8,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      Text(
                        widget.installmentModel.ins_remarks,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppTheme.colors.newBlack,
                            fontSize: 12,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
