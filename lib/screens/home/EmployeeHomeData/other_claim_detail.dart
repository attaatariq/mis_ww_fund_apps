import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welfare_claims_app/ImageViewer/ImageViewer.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/constants/Constants.dart';
import 'package:welfare_claims_app/models/ResponseCodeModel.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
import 'package:welfare_claims_app/usersessions/UserSessions.dart';
import 'package:welfare_claims_app/network/api_service.dart';
import 'package:http/http.dart' as http;

class OtherClaimDetail extends StatefulWidget {
  String calim_ID = "";

  OtherClaimDetail(this.calim_ID);

  @override
  _OtherClaimDetailState createState() => _OtherClaimDetailState();
}

class _OtherClaimDetailState extends State<OtherClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  String uniFormDoc="https://inixioworld.live/resources/images/claims/05/receipt-31.png",
      bookVoucherDoc="https://inixioworld.live/resources/images/claims/05/receipt-1.png",
      stationaryVoucherDoc="https://inixioworld.live/resources/images/claims/05/receipt-1.png",
      transportVoucherDoc="https://inixioworld.live/resources/images/claims/05/receipt-1.png",
      residenceVoucherDoc="https://inixioworld.live/resources/images/claims/05/receipt-1.png";
  String for_whom = "-", claim_year = "-", claim_biannual = "-", uniform_charges = "0", books_charges = "0", stationary_charges = "0", tansport_cost = "0",
      stipend_amount = "0", residence_rent = "0", mess_charges = "0", claim_amount = "0", claim_stage = "-", created_at = "-";
  double total_school_basics= 0.0, total_hotel_mass_charges = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
    GetOtherClaimsDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Detail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 50),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: UserSessions.instance.getUserImage != "null" && UserSessions.instance.getUserImage != "" && UserSessions.instance.getUserImage != "NULL" ? FadeInImage(
                                  image: NetworkImage(constants.getImageBaseURL()+UserSessions.instance.getUserImage),
                                  placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                  fit: BoxFit.fill,
                                ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                  height: 40.0,
                                  width: 40,
                                  fit: BoxFit.fill,
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
                                        UserSessions.instance.getUserName,
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
                                        UserSessions.instance.getUserCNIC,
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

                                  Container(
                                    height: 28,
                                    width: 70,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppTheme.colors.colorExelent
                                    ),

                                    child: Center(
                                      child: Text(
                                        claim_stage,
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
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Claim Progress",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Submitted Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(created_at,
                                    textAlign: TextAlign.center,
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
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Claim Stage",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(claim_stage,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Claim Amount",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Center(
                          child: Text(claim_amount+" PKR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newBlack,
                                fontSize: 12,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("School Basics",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Uniform Charge",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(uniform_charges+" PKR",
                                    textAlign: TextAlign.center,
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
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Books Charge",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(books_charges+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Stationary Charges",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(stationary_charges+" PKR",
                                    textAlign: TextAlign.center,
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
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Total Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(total_school_basics.toString()+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Transport Claim",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Transport Charge",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(tansport_cost+" PKR",
                                    textAlign: TextAlign.center,
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
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Duration",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text("6 Months",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Total Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(tansport_cost+" PKR",
                                    textAlign: TextAlign.center,
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

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Hotel & Mess Claims",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Residence Rent",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(residence_rent+" PKR",
                                    textAlign: TextAlign.center,
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
                              height: 40,
                              width: 1,
                              color: AppTheme.colors.colorDarkGray,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Mess Charges",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(mess_charges+" PKR",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 12,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Total Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(total_hotel_mass_charges.toString()+" PKR",
                                    textAlign: TextAlign.center,
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

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Stipend Claims",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.colors.colorLightGray,
                            border: Border.all(width: 1, color: AppTheme.colors.colorDarkGray)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text("Total Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.colors.newBlack,
                                        fontSize: 10,
                                        fontFamily: "AppFont",
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),

                                  Text(stipend_amount+" PKR",
                                    textAlign: TextAlign.center,
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

                      SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.newPrimary
                        ),

                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text("Documents",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.colors.newWhite,
                                  fontSize: 12,
                                  fontFamily: "AppFont",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(uniFormDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: uniFormDoc != null && uniFormDoc != "" && uniFormDoc != "NULL" && uniFormDoc != "null" && uniFormDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(uniFormDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppTheme.colors.newBlack.withAlpha(400),
                                        ),

                                        child: Center(
                                          child: Text("Uniform Voucher",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5,),

                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(bookVoucherDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: bookVoucherDoc != null && bookVoucherDoc != "" && bookVoucherDoc != "NULL" && bookVoucherDoc != "null" && bookVoucherDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(bookVoucherDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppTheme.colors.newBlack.withAlpha(400),
                                        ),

                                        child: Center(
                                          child: Text("Books Voucher",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(stationaryVoucherDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: stationaryVoucherDoc != null && stationaryVoucherDoc != "" && stationaryVoucherDoc != "NULL" && stationaryVoucherDoc != "null" && stationaryVoucherDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(stationaryVoucherDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppTheme.colors.newBlack.withAlpha(400),
                                        ),

                                        child: Center(
                                          child: Text("Stationary Voucher",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5,),

                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(transportVoucherDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: transportVoucherDoc != null && transportVoucherDoc != "" && transportVoucherDoc != "NULL" && transportVoucherDoc != "null" && transportVoucherDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(transportVoucherDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppTheme.colors.newBlack.withAlpha(400),
                                        ),

                                        child: Center(
                                          child: Text("Transport Voucher",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ImageViewer(residenceVoucherDoc)
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: residenceVoucherDoc != null && residenceVoucherDoc != "" && residenceVoucherDoc != "NULL" && residenceVoucherDoc != "null" && residenceVoucherDoc != "N/A" ? FadeInImage(
                                        image: NetworkImage(residenceVoucherDoc),
                                        placeholder: AssetImage("assets/images/no_image_placeholder.jpg"),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ) : Image.asset("assets/images/no_image_placeholder.jpg",
                                        height: 100.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppTheme.colors.newBlack.withAlpha(400),
                                        ),

                                        child: Center(
                                          child: Text("Residence Voucher",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.newWhite,
                                                fontSize: 10,
                                                fontFamily: "AppFont",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5,),

                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 100,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void GetOtherClaimsDetail() async{
    uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
    var url = constants.getApiBaseURL() + constants.buildApiUrl(
        constants.claims + "other_claim_info/", 
        UserSessions.instance.getUserID, 
        additionalPath: widget.calim_ID);
    var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders());
    ResponseCodeModel responseCodeModel = constants.CheckResponseCodesNew(
        response.statusCode, response);
    if (responseCodeModel.status == true) {
      var body = jsonDecode(response.body);
      String code = body["Code"].toString();
      if (code == "1") {
        var data= body["Data"][0];
        for_whom= data["for_whom"].toString();
        claim_year= data["claim_year"].toString();
        claim_biannual= data["claim_biannual"].toString();
        uniform_charges= data["uniform_charges"].toString();
        books_charges= data["books_charges"].toString();
        stationary_charges= data["stationary_charges"].toString();
        tansport_cost= data["tansport_cost"].toString();
        stipend_amount= data["stipend_amount"].toString();
        residence_rent= data["residence_rent"].toString();
        mess_charges= data["mess_charges"].toString();
        claim_amount= data["claim_amount"].toString();
        claim_stage= data["claim_stage"].toString();
        created_at= data["created_at"].toString();
        uniFormDoc= data["uniform_voucher"].toString();
        bookVoucherDoc= data["books_voucher"].toString();
        stationaryVoucherDoc= data["stationary_voucher"].toString();
        transportVoucherDoc= data["transport_voucher"].toString();
        residenceVoucherDoc= data["residence_voucher"].toString();
        total_school_basics= double.parse(uniform_charges)+double.parse(books_charges)+double.parse(stationary_charges);
        total_hotel_mass_charges= double.parse(residence_rent)+double.parse(mess_charges);

        uiUpdates.DismissProgresssDialog();
        setState(() {
        });
      } else {
        var body = jsonDecode(response.body);
        String message = body["Message"].toString();
        uiUpdates.ShowToast(message);
      }
    } else {
      uiUpdates.ShowToast(responseCodeModel.message);
    }
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if(constants.AgentExpiryComperission()){
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle, Strings.instance.expireSessionMessage);
      }
    });
  }
}
