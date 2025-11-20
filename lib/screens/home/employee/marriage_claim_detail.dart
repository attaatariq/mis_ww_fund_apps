import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wwf_apps/views/noting_item.dart';
import 'package:http/http.dart' as http;
import 'package:wwf_apps/models/Note.dart';
import '../../../viewer/ImageViewer.dart';
import '../../../Strings/Strings.dart';
import '../../../network/api_service.dart';
import '../../../colors/app_colors.dart';
import '../../../constants/Constants.dart';
import '../../../models/NoteModel.dart';
import '../../../models/ResponseCodeModel.dart';
import '../../../updates/UIUpdates.dart';
import '../../../sessions/UserSessions.dart';
import '../../../utils/claim_stages_helper.dart';
import 'package:intl/intl.dart';

class MarriageClaimDetail extends StatefulWidget {
  String calim_ID = "";

  MarriageClaimDetail(this.calim_ID);

  @override
  _MarriageClaimDetailState createState() => _MarriageClaimDetailState();
}

class _MarriageClaimDetailState extends State<MarriageClaimDetail> {
  Constants constants;
  UIUpdates uiUpdates;
  String serviceCertificate, affidavit, awards, nikahNama, accumulativeService;
  String created_at = "-",
      claim_stage = "-",
      claim_amount = "-",
      claim_payment = "-",
      claim_dated = "-",
      claim_category = "-",
      daughter_name = "-",
      husband_name = "-",
      daughter_age = "-",
      child_cnic = "-",
      child_image = "-",
      bank_name = "-", account_title="-", account_number="-", account_nature="-", user_image="-",
      user_name="-", user_cnic="-";
  bool isError = false;
  String errorMessage = "";
  List<Note> noteParahList = [];
  List<NoteModel> noteList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    constants = new Constants();
    uiUpdates = new UIUpdates(context);
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
                      "Marriage Claim Details",
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
            child: SingleChildScrollView(
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

                    // Daughter Details Section (if applicable)
                    if (claim_category != "Self" && claim_category != "-")
                      _buildDaughterDetailsSection(),
                    if (claim_category != "Self" && claim_category != "-")
                      SizedBox(height: 16),

                    // Bank Details Section
                    _buildBankDetailsSection(),
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
                    Text(
                      user_cnic,
                      style: TextStyle(
                        color: AppTheme.colors.colorDarkGray,
                        fontSize: 12,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
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
              claim_category,
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
                    "Marriage Date",
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
                Icons.favorite,
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
        ],
      ),
    );
  }

  Widget _buildDaughterDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Daughter Details", Icons.person_outline),
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
              _buildInfoRow("Daughter Name", daughter_name, "Husband Name", husband_name),
              SizedBox(height: 12),
              _buildInfoRow("Daughter Age", daughter_age, "CNIC", child_cnic),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Bank Details", Icons.account_balance),
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
              SizedBox(height: 12),
              _buildInfoRow("Account Number", account_number, "Account Nature", account_nature),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    final List<Map<String, String>> documents = [
      {"title": "Service Certificate", "doc": serviceCertificate},
      {"title": "Affidavit", "doc": affidavit},
      {"title": "Award", "doc": awards},
      {"title": "Nikah Nama", "doc": nikahNama},
      {"title": "Accumulative Service", "doc": accumulativeService},
    ];

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
            final hasDoc = doc["doc"] != null && 
                          doc["doc"] != "" && 
                          doc["doc"] != "NULL" && 
                          doc["doc"] != "null" && 
                          doc["doc"] != "N/A";

            return InkWell(
              onTap: hasDoc
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(constants.getImageBaseURL() + doc["doc"]),
                        ),
                      );
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.colors.newWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasDoc
                        ? AppTheme.colors.newPrimary.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: hasDoc
                          ? FadeInImage(
                              image: NetworkImage(constants.getImageBaseURL() + doc["doc"]),
                              placeholder: AssetImage("archive/images/no_image.jpg"),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "archive/images/no_image.jpg",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                              },
                            )
                          : Image.asset(
                              "archive/images/no_image.jpg",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: hasDoc
                              ? AppTheme.colors.newPrimary
                              : Colors.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          doc["title"],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 10,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Row(
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
                value1,
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
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
                value2,
                style: TextStyle(
                  color: AppTheme.colors.newBlack,
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
        GetMarriageClaimsDetail();
      }
    });
  }

  void GetMarriageClaimsDetail() async {
    try {
      uiUpdates.ShowProgressDialog(Strings.instance.pleaseWait);
      var url = constants.getApiBaseURL() + constants.buildApiUrl(
          constants.claims + "marriage_detail/", 
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
            
            // Handle notings field (may not exist in employer response)
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
            
            user_name= body["user_name"] != null ? body["user_name"].toString() : "-";
            user_image= body["user_image"] != null ? body["user_image"].toString() : "-";
            user_cnic= body["user_cnic"] != null ? body["user_cnic"].toString() : "-";
            claim_stage = body["claim_stage"] != null ? body["claim_stage"].toString() : "-";
            created_at = body["created_at"] != null ? body["created_at"].toString() : "-";
            claim_dated = body["claim_dated"] != null ? body["claim_dated"].toString() : "-";
            // Use beneficiary field from API (fallback to claim_category for backward compatibility)
            claim_category = body["beneficiary"] != null ? body["beneficiary"].toString() : 
                           (body["claim_category"] != null ? body["claim_category"].toString() : "-");
            claim_amount = body["claim_amount"] != null ? body["claim_amount"].toString() : "-";
            claim_payment = body["claim_payment"] != null ? body["claim_payment"].toString() : "-";
            bank_name= body["emp_bank"] != null ? body["emp_bank"].toString() : "-";
            account_number= body["emp_account"] != null ? body["emp_account"].toString() : "-";
            account_title= body["emp_title"] != null ? body["emp_title"].toString() : "-";
            account_nature= body["emp_nature"] != null ? body["emp_nature"].toString() : "-";
            // Handle null values for optional documents
            serviceCertificate = body["claim_certificate"] != null && body["claim_certificate"] != "null" ? body["claim_certificate"].toString() : "";
            affidavit = body["claim_affidavit"] != null && body["claim_affidavit"] != "null" ? body["claim_affidavit"].toString() : "";
            awards = body["claim_award"] != null && body["claim_award"] != "null" ? body["claim_award"].toString() : "";
            nikahNama = body["claim_nikahnama"] != null && body["claim_nikahnama"] != "null" ? body["claim_nikahnama"].toString() : "";
            accumulativeService = body["claim_service"] != null && body["claim_service"] != "null" ? body["claim_service"].toString() : "";
            
            // Handle child_id null check
            String childIdValue = body["child_id"] != null && body["child_id"] != "null" ? body["child_id"].toString() : "";
            husband_name = body["claim_husband"] != null ? body["claim_husband"].toString() : "-";
            
            if (claim_category != "Self" && childIdValue.isNotEmpty) {
              daughter_name = body["child_name"] != null ? body["child_name"].toString() : "-";
              child_cnic = body["child_cnic"] != null ? body["child_cnic"].toString() : "-";
              child_image = body["child_image"] != null && body["child_image"] != "null" ? body["child_image"].toString() : "-";
              String childBirthday = body["child_birthday"] != null && body["child_birthday"] != "null" ? body["child_birthday"].toString() : "";
              if(childBirthday.isNotEmpty && childBirthday != "null") {
                daughter_age = GetDaughterAge(created_at, childBirthday) ?? "-";
              } else {
                daughter_age = "-";
              }
            } else {
              // For Self claims, clear child-related fields
              daughter_name = "-";
              child_cnic = "-";
              child_image = "-";
              daughter_age = "-";
            }
            
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

  String GetDaughterAge(String createdAt, String dob) {
    var createdDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(createdAt);
    var dobDate = new DateFormat("yyyy-MM-dd").parse(dob);
    var finalDOB = createdDate.year - dobDate.year;
    return finalDOB.toString();
  }
}