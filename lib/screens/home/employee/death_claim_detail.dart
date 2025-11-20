import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wwf_apps/views/noting_item.dart';
import 'package:http/http.dart' as http;
import '../../../viewer/ImageViewer.dart';
import '../../../Strings/Strings.dart';
import '../../../colors/app_colors.dart';
import '../../../constants/Constants.dart';
import '../../../models/Note.dart';
import '../../../models/NoteModel.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../network/api_service.dart';
import '../../../utils/claim_stages_helper.dart';

class DeathClaimDetail extends StatefulWidget {
  String calim_ID = "";

  DeathClaimDetail(this.calim_ID);

  @override
  _DeathClaimDetailState createState() => _DeathClaimDetailState();
}

class _DeathClaimDetailState extends State<DeathClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  String eobiPension, affidavitNotClaimed, affidavitNotMarried, awards, deathCertificate, pensionBook, condonation, claimEobiPension;
  String created_at = "-",
      claim_stage = "-",
      claim_amount = "-",
      claim_dated = "-",
      eobiNo = "-",
      bank_name = "-", account_title="-", account_number="-", user_image="-",
      user_name="-", user_cnic="-";
  // Beneficiary fields
  String bene_name = "-", bene_cnic = "-", bene_relation = "-", bene_contact = "-",
      bene_guardian = "-", bene_address = "-", bene_city = "-", bene_district = "-",
      bene_state = "-", bene_bank = "-", bene_nature = "-", bene_title = "-",
      bene_account = "-", bene_issued = "-", bene_expiry = "-";
  bool isError = false;
  String errorMessage = "";
  List<Note> noteParahList = [];
  List<NoteModel> noteList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants= new Constants();
    uiUpdates= new UIUpdates(context);
    CheckTokenExpiry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Modern Header with Shadow
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.newPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppTheme.colors.newWhite,
                          size: 22,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Death Claim Details",
                      style: TextStyle(
                        color: AppTheme.colors.newWhite,
                        fontSize: 18,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: isError
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppTheme.colors.colorDarkGray.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            errorMessage.isNotEmpty ? errorMessage : Strings.instance.notAvail,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.colors.colorDarkGray,
                              fontSize: 14,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isError = false;
                              });
                              CheckTokenExpiry();
                            },
                            icon: Icon(Icons.refresh, size: 18),
                            label: Text("Retry"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppTheme.colors.newPrimary),
                              foregroundColor: MaterialStateProperty.all(AppTheme.colors.newWhite),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        isError = false;
                        noteList.clear();
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      CheckTokenExpiry();
                    },
                    color: AppTheme.colors.newPrimary,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // User Info Card
                            _buildUserInfoCard(),
                            SizedBox(height: 16),

                            // Status Card
                            _buildStatusCard(),
                            SizedBox(height: 16),

                            // Claim Overview
                            _buildClaimOverview(),
                            SizedBox(height: 16),

                            // Employee Bank Details Section
                            _buildEmployeeBankDetailsSection(),
                            SizedBox(height: 16),

                            // Beneficiary Details Section
                            _buildBeneficiaryDetailsSection(),
                            SizedBox(height: 16),

                            // Documents Section
                            _buildDocumentsSection(),
                            SizedBox(height: 16),

                            // Notes Section
                            if (noteList.isNotEmpty) _buildNotesSection(),
                            if (noteList.isNotEmpty) SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Helper Methods for Professional UI

  Widget _buildUserInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.newWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppTheme.colors.newPrimary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: user_image != "null" &&
                  user_image != "" &&
                  user_image != "NULL" &&
                  user_image != "-" &&
                  user_image != "N/A"
                  ? FadeInImage(
                      image: NetworkImage(constants.getImageBaseURL() + user_image),
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user_name,
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
                      Icons.badge_outlined,
                      size: 14,
                      color: AppTheme.colors.colorDarkGray,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user_cnic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.colors.colorDarkGray,
                          fontSize: 12,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.colors.colorExelent,
            ),
            child: Text(
              "Death Claim",
              style: TextStyle(
                color: AppTheme.colors.newWhite,
                fontSize: 11,
                fontFamily: "AppFont",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Column(
      children: [
        ClaimStagesHelper.buildDetailStatusCard(claim_stage),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.colors.newPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppTheme.colors.newPrimary,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Submitted Date",
                    style: TextStyle(
                      color: AppTheme.colors.colorDarkGray,
                      fontSize: 11,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    created_at,
                    style: TextStyle(
                      color: AppTheme.colors.newBlack,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClaimOverview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.colors.newPrimary,
            AppTheme.colors.newPrimary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.newPrimary.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Death Date",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    claim_dated,
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.calendar_today,
                color: AppTheme.colors.newWhite.withOpacity(0.8),
                size: 28,
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppTheme.colors.newWhite.withOpacity(0.3), height: 1),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Claim Amount",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "PKR $claim_amount",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 20,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.account_balance_wallet,
                color: AppTheme.colors.newWhite.withOpacity(0.8),
                size: 32,
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: AppTheme.colors.newWhite.withOpacity(0.3), height: 1),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EOBI Number",
                    style: TextStyle(
                      color: AppTheme.colors.newWhite.withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    eobiNo,
                    style: TextStyle(
                      color: AppTheme.colors.newWhite,
                      fontSize: 14,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.credit_card,
                color: AppTheme.colors.newWhite.withOpacity(0.8),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeBankDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Employee Bank Details", Icons.account_balance),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow("Bank Name", bank_name, "Account Title", account_title),
              if (bank_name != "-" || account_title != "-")
                SizedBox(height: 12),
              if (bank_name != "-" || account_title != "-")
                Divider(color: Colors.grey.withOpacity(0.1), height: 1),
              if (bank_name != "-" || account_title != "-")
                SizedBox(height: 12),
              _buildInfoRow("Account Number", account_number, "EOBI Number", eobiNo),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBeneficiaryDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Beneficiary Details", Icons.person_outline),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.colors.newWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow("Beneficiary Name", bene_name, "Relation", bene_relation),
              if ((bene_name != "-" && bene_name.isNotEmpty) || (bene_relation != "-" && bene_relation.isNotEmpty))
                SizedBox(height: 12),
              _buildInfoRow("CNIC", bene_cnic, "Contact", bene_contact),
              if ((bene_cnic != "-" && bene_cnic.isNotEmpty) || (bene_contact != "-" && bene_contact.isNotEmpty))
                SizedBox(height: 12),
              if ((bene_cnic != "-" && bene_cnic.isNotEmpty) || (bene_contact != "-" && bene_contact.isNotEmpty))
                Divider(color: Colors.grey.withOpacity(0.1), height: 1),
              if ((bene_cnic != "-" && bene_cnic.isNotEmpty) || (bene_contact != "-" && bene_contact.isNotEmpty))
                SizedBox(height: 12),
              if (bene_guardian != "-" && bene_guardian.isNotEmpty)
                _buildInfoRow("Guardian", bene_guardian, "CNIC Issue Date", bene_issued != "-" ? bene_issued : ""),
              if (bene_guardian != "-" && bene_guardian.isNotEmpty)
                SizedBox(height: 12),
              if (bene_expiry != "-" && bene_expiry.isNotEmpty)
                _buildInfoRow("CNIC Expiry", bene_expiry, "Address", bene_address != "-" ? bene_address : ""),
              if (bene_expiry == "-" && bene_address != "-" && bene_address.isNotEmpty)
                _buildInfoRow("Address", bene_address, "", ""),
              if (bene_expiry == "-" && bene_address != "-" && bene_address.isNotEmpty)
                SizedBox(height: 12),
              if ((bene_city != "-" && bene_city.isNotEmpty) || (bene_district != "-" && bene_district.isNotEmpty))
                _buildInfoRow("City", bene_city != "-" ? bene_city : "", "District", bene_district != "-" ? bene_district : ""),
              if ((bene_city != "-" && bene_city.isNotEmpty) || (bene_district != "-" && bene_district.isNotEmpty))
                SizedBox(height: 12),
              if (bene_state != "-" && bene_state.isNotEmpty)
                _buildInfoRow("State/Province", bene_state, "", ""),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                SizedBox(height: 16),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                Divider(color: Colors.grey.withOpacity(0.2), height: 2),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                SizedBox(height: 12),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                _buildSectionSubHeader("Beneficiary Bank Details", Icons.account_balance_outlined),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                SizedBox(height: 12),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                _buildInfoRow("Bank Name", bene_bank != "-" ? bene_bank : "", "Account Title", bene_title != "-" ? bene_title : ""),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                SizedBox(height: 12),
              if ((bene_bank != "-" && bene_bank.isNotEmpty) || (bene_account != "-" && bene_account.isNotEmpty))
                _buildInfoRow("Account Number", bene_account != "-" ? bene_account : "", "Account Nature", bene_nature != "-" ? bene_nature : ""),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    final List<Map<String, String>> allDocuments = [
      {"title": "EOBI Pension Card", "doc": eobiPension},
      {"title": "Claim EOBI Pension", "doc": claimEobiPension},
      {"title": "Affidavit Not Claimed", "doc": affidavitNotClaimed},
      {"title": "Affidavit Not Married", "doc": affidavitNotMarried},
      {"title": "Award", "doc": awards},
      {"title": "Death Certificate", "doc": deathCertificate},
      {"title": "Pension Book", "doc": pensionBook},
      {"title": "Condonation", "doc": condonation},
    ];

    // Filter out documents that don't exist
    final List<Map<String, String>> documents = allDocuments.where((doc) {
      final docPath = doc["doc"];
      return docPath != null && 
             docPath != "" && 
             docPath != "NULL" && 
             docPath != "null" && 
             docPath != "N/A";
    }).toList();

    if (documents.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Documents", Icons.folder_outlined),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            final docPath = doc["doc"] ?? "";

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(constants.getImageBaseURL() + docPath),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.colors.newWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.colors.newPrimary.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.colors.newPrimary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage(
                          image: NetworkImage(constants.getImageBaseURL() + docPath),
                          placeholder: AssetImage("archive/images/no_image.jpg"),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey.withOpacity(0.1),
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey.withOpacity(0.5),
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppTheme.colors.newPrimary.withOpacity(0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            doc["title"] ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.colors.newWhite,
                              fontSize: 11,
                              fontFamily: "AppFont",
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.newWhite.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.visibility,
                            size: 16,
                            color: AppTheme.colors.newPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Notes", Icons.note_alt_outlined),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemBuilder: (_, int index) => NotingItem(noteList[index], constants),
          itemCount: noteList.length,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.colors.newPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppTheme.colors.newPrimary,
          ),
        ),
        SizedBox(width: 12),
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

  Widget _buildSectionSubHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.colors.newPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.colors.newPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.colors.newPrimary,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    // Skip empty rows
    if ((value1.isEmpty || value1 == "-") && (value2.isEmpty || value2 == "-")) {
      return SizedBox.shrink();
    }
    
    if (label2.isEmpty && value2.isEmpty) {
      // Single column layout
      if (value1.isEmpty || value1 == "-") {
        return SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label1,
            style: TextStyle(
              color: AppTheme.colors.colorDarkGray,
              fontSize: 11,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value1,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 13,
              fontFamily: "AppFont",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    
    // Two column layout - only show if at least one value is not empty
    if ((value1.isEmpty || value1 == "-") && (value2.isEmpty || value2 == "-")) {
      return SizedBox.shrink();
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                (value1.isEmpty || value1 == "-") ? "N/A" : value1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: (value1.isEmpty || value1 == "-") ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                  fontSize: 13,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  color: AppTheme.colors.colorDarkGray,
                  fontSize: 11,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                (value2.isEmpty || value2 == "-") ? "N/A" : value2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: (value2.isEmpty || value2 == "-") ? AppTheme.colors.colorDarkGray : AppTheme.colors.newBlack,
                  fontSize: 13,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void CheckTokenExpiry() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (constants.AgentExpiryComperission()) {
        constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
            Strings.instance.expireSessionMessage);
      } else {
        GetDeathClaimsDetail();
      }
    });
  }

  void GetDeathClaimsDetail() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "deceased_detail/", 
          UserSessions.instance.getUserID, 
          additionalPath: widget.calim_ID);
      
      var response = await http.get(Uri.parse(url), headers: APIService.getDefaultHeaders()).timeout(Duration(seconds: 30));
      
      ResponseCodeModel responseCodeModel = constants.CheckResponseCodes(response.statusCode);
      
      if (responseCodeModel.status == true) {
        try {
          var bodyData = jsonDecode(response.body);
          String code = bodyData["Code"].toString();
          
          if (code == "1") {
            var body = bodyData["Data"];
            // Handle notings field (may be null or empty)
            if (body["notings"] != null) {
              List<dynamic> noteListData = body["notings"];
              if (noteListData.isNotEmpty) {
                noteList.clear();
                noteListData.forEach((element) {
                  noteParahList.clear();
                  List<dynamic> noteParaListData = element["note_paras"] != null ? element["note_paras"] : [];
                  if (noteParaListData.isNotEmpty) {
                    noteParaListData.forEach((element1) {
                      String para_no = element1["para_no"] != null ? element1["para_no"].toString() : "";
                      String remarks = element1["remarks"] != null ? element1["remarks"].toString() : "";
                      noteParahList.add(Note(para_no, remarks));
                    });
                  }
                  String user_name_to = element["user_name_to"] != null ? element["user_name_to"].toString() : "";
                  String role_name_to = element["role_name_to"] != null ? element["role_name_to"].toString() : "";
                  String sector_name_to = element["sector_name_to"] != null ? element["sector_name_to"].toString() : "";
                  String user_name_by = element["user_name_by"] != null ? element["user_name_by"].toString() : "";
                  String role_name_by = element["role_name_by"] != null ? element["role_name_by"].toString() : "";
                  String sector_name_by = element["sector_name_by"] != null ? element["sector_name_by"].toString() : "";
                  String noting_created_at = element["created_at"] != null ? element["created_at"].toString() : "";
                  noteList.add(NoteModel(
                      user_name_to,
                      role_name_to,
                      sector_name_to,
                      user_name_by,
                      role_name_by,
                      sector_name_by,
                      noting_created_at,
                      noteParahList));
                });
              }
            }
            
            // User information
            user_name= body["user_name"] != null ? body["user_name"].toString() : "-";
            user_image= body["user_image"] != null ? body["user_image"].toString() : "-";
            user_cnic= body["user_cnic"] != null ? body["user_cnic"].toString() : "-";
            
            // Claim information
            claim_stage = body["claim_stage"] != null ? body["claim_stage"].toString() : "-";
            created_at = body["created_at"] != null ? body["created_at"].toString() : "-";
            claim_dated = body["claim_dated"] != null ? body["claim_dated"].toString() : "-";
            claim_amount = body["claim_amount"] != null ? body["claim_amount"].toString() : "-";
            
            // Employee information
            eobiNo = body["emp_eobino"] != null ? body["emp_eobino"].toString() : "-";
            bank_name= body["emp_bank"] != null ? body["emp_bank"].toString() : "-";
            account_number= body["emp_account"] != null ? body["emp_account"].toString() : "-";
            account_title= body["emp_title"] != null ? body["emp_title"].toString() : "-";
            
            // Documents - handle null values
            eobiPension = body["emp_eobi_card"] != null && body["emp_eobi_card"] != "null" ? body["emp_eobi_card"].toString() : "";
            affidavitNotClaimed = body["claim_affidavit_1"] != null && body["claim_affidavit_1"] != "null" ? body["claim_affidavit_1"].toString() : "";
            affidavitNotMarried = body["claim_affidavit_2"] != null && body["claim_affidavit_2"] != "null" ? body["claim_affidavit_2"].toString() : "";
            awards = body["claim_award"] != null && body["claim_award"] != "null" ? body["claim_award"].toString() : "";
            deathCertificate = body["claim_certificate"] != null && body["claim_certificate"] != "null" ? body["claim_certificate"].toString() : "";
            pensionBook = body["claim_book"] != null && body["claim_book"] != "null" ? body["claim_book"].toString() : "";
            condonation = body["claim_condonation"] != null && body["claim_condonation"] != "null" ? body["claim_condonation"].toString() : "";
            
            // Add missing claim_eobipension field
            claimEobiPension = body["claim_eobipension"] != null && body["claim_eobipension"] != "null" ? body["claim_eobipension"].toString() : "";
            
            // Beneficiary information
            bene_name = body["bene_name"] != null ? body["bene_name"].toString() : "-";
            bene_cnic = body["bene_cnic"] != null ? body["bene_cnic"].toString() : "-";
            bene_relation = body["bene_relation"] != null ? body["bene_relation"].toString() : "-";
            bene_contact = body["bene_contact"] != null ? body["bene_contact"].toString() : "-";
            bene_guardian = body["bene_guardian"] != null ? body["bene_guardian"].toString() : "-";
            bene_address = body["bene_address"] != null ? body["bene_address"].toString() : "-";
            bene_city = body["bene_city"] != null ? body["bene_city"].toString() : "-";
            bene_district = body["bene_district"] != null ? body["bene_district"].toString() : "-";
            bene_state = body["bene_state"] != null ? body["bene_state"].toString() : "-";
            bene_bank = body["bene_bank"] != null ? body["bene_bank"].toString() : "-";
            bene_nature = body["bene_nature"] != null ? body["bene_nature"].toString() : "-";
            bene_title = body["bene_title"] != null ? body["bene_title"].toString() : "-";
            bene_account = body["bene_account"] != null ? body["bene_account"].toString() : "-";
            bene_issued = body["bene_issued"] != null ? body["bene_issued"].toString() : "-";
            bene_expiry = body["bene_expiry"] != null ? body["bene_expiry"].toString() : "-";
            
            setState(() {
              isError = false;
            });
          } else {
            uiUpdates.ShowToast(Strings.instance.failedToGetInfo);
            setState(() {
              isError = true;
              errorMessage = Strings.instance.notFound;
            });
          }
        } catch (e) {
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
          setState(() {
            isError = true;
            errorMessage = Strings.instance.somethingWentWrong;
          });
        }
      } else {
        try {
          var body = jsonDecode(response.body);
          String message = body["Message"] != null ? body["Message"].toString() : "";
          
          if (message == constants.expireToken) {
            constants.OpenLogoutDialog(context, Strings.instance.expireSessionTitle,
                Strings.instance.expireSessionMessage);
          } else if (message.isNotEmpty && message != "null") {
            uiUpdates.ShowToast(message);
          } else {
            uiUpdates.ShowToast(responseCodeModel.message);
          }
        } catch (e) {
          uiUpdates.ShowToast(responseCodeModel.message);
        }
      }
    } catch (e) {
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      setState(() {
        isError = true;
        errorMessage = Strings.instance.somethingWentWrong;
      });
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      uiUpdates.DismissProgresssDialog();
    }
  }
}
