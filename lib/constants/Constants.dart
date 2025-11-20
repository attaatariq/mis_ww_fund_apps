import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gson/gson.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/colors/app_colors.dart';
import 'package:wwf_apps/dialogs/app_update_dialog.dart';
import 'package:wwf_apps/dialogs/logout_dialog.dart';
import 'package:wwf_apps/models/MonthModel.dart';
import 'package:wwf_apps/models/ProvinceModel.dart';
import 'package:wwf_apps/models/ResponseCodeModel.dart';
import 'package:wwf_apps/screens/auth/login.dart';
import 'package:wwf_apps/screens/general/splash_screen.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

class Constants {
  // APIs base urls
  String ApiBaseURL = "https://mis.wwf.gov.pk/xerox/api/";
  String ImageBaseURL = "https://mis.wwf.gov.pk/xerox/";

  String ConnectionMessage = "Internet Not Connected, Try Again";
  String ErrorOccurMessage = "Error Occur, Try Again";
  String ExceptionOccurMessage = "Exception Occur, Try Again";

  // APIs folder names
  String authentication = "authenticate/";
  String companies = "companies/";
  String employees = "employees/";
  String education = "education/";
  String children = "children/";
  String claims = "claims/";
  String assessments = "interaction/";
  String alerts = "alerts/";
  String homescreen = "homescreen";
  String homeEmployees = "employees";
  String homeCompanies = "companies";

  //expire token enum
  String expireToken = "TOKEN_EXPIRED";

  ///selector category
  String selectorCategoryFirstName = "Register as an Employer / Company";
  String selectorCategorySecondName = "Register as a Worker (Non-WWF Company)";
  String selectorCategoryThirdName = "Register as a WWF Employee";

  ///disability
  String disable = "Yes";
  String notDisable = "No";

  ///turnover
  String current = "Current";
  String previous = "Previous";

  ///education nature
  String underMatric = "Under Matric";
  String postMatric = "Post Matric";

  ///statements
  String profit = "Profit";
  String loss = "Loss";

  ///identity types
  String cnic = "CNIC";
  String bform = "B-Form";

  ///bank account types
  String iban = "IBAN";
  String bban = "BBAN";

  ///living types
  String dayScholar = "Day-Scholar";
  String hostelite = "Hostelite";

  ///payment modes
  String cash = "Cash";
  String draft = "Draft";
  String challan = "Challan";

  ///beneficiary relations
  String son = "Son";
  String widow = "Widow";
  String daughter = "Daughter";

  ///marriage category
  String marriageSelf = "Self";
  String marriageDaughter = "Daughter";

  ///claim type
  String calimSelf = "Self";
  String claimChild = "Child";

  //information api tags
  String userInfo = "user_info";
  String empInfo = "emp_info";
  String compInfo = "comp_info";
  String accountInfo = "account";
  String empEduList = "emp_edu_ls";
  String empChildren = "emp_children";
  String companiesInfo = "companies";
  String statesInfo = "states";
  String districtsInfo = "districts";
  String citiesInfo = "cities";
  String schoolsInfo = "schools";
  String deoInfo = "DEO";
  String contactPersonInfo = "person";
  String inheritorInfo = "inheritors";

  //date Dialog colors
  int dateDialogBg = 0xFF567ef1;
  int dateDialogText = 0xFFFFFFFF;

  String getImageBaseURL() {
    return ImageBaseURL;
  }

  /// Build API URL with user_id but without token (token goes in Authorization header)
  /// Example: buildApiUrl("claims/fee_claim/", user_id) -> "claims/fee_claim/{user_id}/"
  String buildApiUrl(String endpoint, String userId, {String additionalPath = ""}) {
    String url = endpoint;
    if (!url.endsWith("/")) {
      url += "/";
    }
    url += userId;
    if (additionalPath.isNotEmpty) {
      if (!additionalPath.startsWith("/")) {
        url += "/";
      }
      url += additionalPath;
    }
    if (!url.endsWith("/")) {
      url += "/";
    }
    return url;
  }

  String getConnectionMessage() {
    return ConnectionMessage;
  }

  String getApiBaseURL() {
    return ApiBaseURL;
  }

  String getErrorOccurMessage() {
    return ErrorOccurMessage;
  }

  String getExceptionOccurMessage() {
    return ExceptionOccurMessage;
  }

  Future<bool> CheckConnectivity(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a network.
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // no network.
      return false;
    }
  }

  Future<String> CheckConnectivityType(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return "mobile";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "wifi";
    } else if (connectivityResult == ConnectivityResult.none) {
      return "none";
    }
  }

  Future<String> GetIPAddress(BuildContext context) async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }

  Future<String> getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }

  Future<String> GetDeviceInfo(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.toString();
    }
  }

  Future<String> GetPlatForm(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "Android " + androidInfo.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "IOS " + iosInfo.systemVersion;
    }
  }

  bool IsValidEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  String GetSubStringBody(http.Response response) {
    final prefix = 'ï»¿';
    var body = response.body;
    if (body.startsWith(prefix)) {
      body = body.substring(prefix.length);
      return body;
    } else {
      return response.body;
    }
  }

  String ConvertMapToJson(Map<String, String> map) {
    String data = gsonEncode(map);
    return data;
  }

  List<String> GetCompanyTypes() {
    List<String> companyTypesList = [];
    companyTypesList.add("Government");
    companyTypesList.add("Private");
    companyTypesList.add("Public Sector");
    companyTypesList.add("Multinational");
    return companyTypesList;
  }

  List<String> GetUnderMatricLevels() {
    List<String> underMatricLevlsList = [];
    underMatricLevlsList.add("Playgroup");
    underMatricLevlsList.add("Nursery");
    underMatricLevlsList.add("Kindergarten");
    underMatricLevlsList.add("Primary");
    underMatricLevlsList.add("Middle");
    underMatricLevlsList.add("Matriculation");
    return underMatricLevlsList;
  }

  List<String> GetPostMatricLevels() {
    List<String> postMatricLevlsList = [];
    postMatricLevlsList.add("Intermediate");
    postMatricLevlsList.add("Bachelor");
    postMatricLevlsList.add("Masters");
    postMatricLevlsList.add("Doctorate");
    postMatricLevlsList.add("Post Doctoral");
    return postMatricLevlsList;
  }

  List<MonthModel> GetMonthModel() {
    List<MonthModel> monthModelList = [];
    monthModelList.add(new MonthModel("01", "January"));
    monthModelList.add(new MonthModel("02", "February"));
    monthModelList.add(new MonthModel("03", "March"));
    monthModelList.add(new MonthModel("04", "April"));
    monthModelList.add(new MonthModel("05", "May"));
    monthModelList.add(new MonthModel("06", "June"));
    monthModelList.add(new MonthModel("07", "July"));
    monthModelList.add(new MonthModel("08", "August"));
    monthModelList.add(new MonthModel("09", "September"));
    monthModelList.add(new MonthModel("10", "October"));
    monthModelList.add(new MonthModel("11", "November"));
    monthModelList.add(new MonthModel("12", "December"));
    return monthModelList;
  }

  List<String> GetBanksModel() {
    List<String> bankModelList = [];
    bankModelList.add("Al Baraka Bank Pakistan");
    bankModelList.add("Allied Bank");
    bankModelList.add("Askari Bank");
    bankModelList.add("Bank Alfalah");
    bankModelList.add("Bank Al-Habib");
    bankModelList.add("BankIslami Pakistan");
    bankModelList.add("United Bank");
    bankModelList.add("Dubai Islamic Bank");
    bankModelList.add("Faysal Bank");
    bankModelList.add("Habib Bank");
    bankModelList.add("Habib Metropolitan Bank");
    bankModelList.add("MCB Bank");
    bankModelList.add("MCB Islamic Bank");
    bankModelList.add("Meezan Bank");
    bankModelList.add("National Bank of Pakistan");
    bankModelList.add("Bank of Punjab");
    bankModelList.add("Sindh Bank");
    bankModelList.add("Bank of Khyber");
    bankModelList.add("Bank of Azad Jammu & Kashmir");
    bankModelList.add("Industrial Development Bank");
    bankModelList.add("Zarai Taraqiati Bank");
    bankModelList.add("Faysal Bank");
    bankModelList.add("First Women Bank");
    bankModelList.add("Soneri Bank");
    bankModelList.add("Summit Bank Bank");
    bankModelList.add("Silk Bank");
    return bankModelList;
  }

  List<String> GetCompaniesModel() {
    List<String> companierModelList = [];
    companierModelList.add("Amazon Private Limited");
    companierModelList.add("PTCL Private Limited");
    companierModelList.add("The Coca Cola Limited.");
    companierModelList.add("The Orient PVT. LTD.");
    companierModelList.add("Wallmart Private Limited.");
    companierModelList.add("Workers Welfare Fund");
    return companierModelList;
  }


  List<String> GetYearModel() {
    List<String> yearsModelList = [];
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDate = formatter.format(now);
    for (int i = int.parse(formattedDate); i >= 2000; i--) {
      yearsModelList.add(i.toString());
    }
    return yearsModelList;
  }

  List<String> GetFinancialYearModel() {
    List<String> financialYearsModelList = [];
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDate = formatter.format(now);
    for (int i = int.parse(formattedDate); i >= 2000; i--) {
      financialYearsModelList.add((i-1).toString()+"-"+i.toString());
    }
    return financialYearsModelList;
  }

  List<String> GetComplaintTypes() {
    List<String> typeList = [];
    typeList.add("Criticize Management");
    typeList.add("Payment and Installments");
    return typeList;
  }

  ResponseCodeModel CheckResponseCodes(int code) {
    if (code == 200) {
      return new ResponseCodeModel("OK", true);
    } else if (code == 400) {
      return new ResponseCodeModel("Bad Request Error", false);
    } else if (code == 404) {
      return new ResponseCodeModel("Page Not Found", false);
    } else if (code == 500) {
      return new ResponseCodeModel("Internal Server Error", false);
    }
  }

  ResponseCodeModel CheckResponseCodesNew(int code, http.Response response) {
    String message = "";
    if (code == 200) {
      message = "OK";
      return new ResponseCodeModel(message, true);
    } else if (code == 400) {
      try {
        var body = jsonDecode(response.body);
        message = body["Message"].toString();
      } catch (e) {
        message = "Bad Request Error";
      }
      return new ResponseCodeModel(message, false);
    } else if (code == 404) {
      try {
        var body = jsonDecode(response.body);
        message = body["Message"].toString();
      } catch (e) {
        message = "Page Not Found";
      }
      return new ResponseCodeModel(message, false);
    } else if (code == 500) {
      try {
        var body = jsonDecode(response.body);
        message = body["Message"].toString();
      } catch (e) {
        message = "Internal Server Error";
      }
      return new ResponseCodeModel("Internal Server Error", false);
    }
  }

  LogoutUser(BuildContext context) {
    UserSessions.instance.setUserID("");
    UserSessions.instance.setUserName("");
    UserSessions.instance.setUserCNIC("");
    UserSessions.instance.setUserEmail("");
    UserSessions.instance.setUserNumber("");
    UserSessions.instance.setUserImage("");
    UserSessions.instance.setUserAbout("");
    UserSessions.instance.setToken("");
    UserSessions.instance.setUserAccount("");
    UserSessions.instance.setUserSector("");
    UserSessions.instance.setUserRole("");
    UserSessions.instance.setRefID("");
    UserSessions.instance.setEmployeeID("");
    UserSessions.instance.setDeoID(false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  OpenLogoutDialog(BuildContext context, String title, String message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: LogoutDialog(title, message),
          );
        });
  }

  bool AgentExpiryComperission() {
    var agentDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(UserSessions.instance.getAgentExpiry);
    var now = new DateTime.now();

    if (agentDate.compareTo(now) > 0) {
      return false;
    } else {
      return true;
    }
  }

  String GetFormatedDate(String date) {
    DateTime todayDate = DateTime.parse(date);
    String formatedDate = formatDate(
        todayDate, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ' ', am]);
    return formatedDate;
  }

  String GetFormatedDateWithoutTime(String date) {
    DateTime todayDate = DateTime.parse(date);
    String formatedDate = formatDate(todayDate, [yyyy, '-', mm, '-', dd]);
    return formatedDate;
  }

  void ShowNotification(RemoteMessage message) {
    String title = message.data['title'].toString();
    String noti_message = message.data['message'].toString();
    String type = message.data['type'].toString();
    RemoteNotification notification = message.notification;
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        noti_message,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
//            channel.description,
            color: AppTheme.colors.newPrimary,
            playSound: true,
            icon: '@mipmap/launcher_icon',
          ),
        ));
  }

  void CheckForNewUpdate(BuildContext context) async {
    // Skip update check if app is not yet published on Play Store
    // Set this to true once app is published
    const bool isAppPublished = false;
    
    if (!isAppPublished) {
      return;
    }
    
    try {
      final newVersion = NewVersion(
          androidId: "pk.gov.wwf.apps",
          iOSId: "pk.gov.wwf.apps");
      final status = await newVersion.getVersionStatus();
      if (status != null && status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          allowDismissal: false,
          versionStatus: status,
          dialogTitle: "UPDATE!!!",
          dialogText: "Please update the app from " +
              "${status.localVersion}" +
              " to " +
              "${status.storeVersion}",
          dismissAction: () {
            SystemNavigator.pop();
          },
          updateButtonText: "Lets update",
        );
      }
    } catch (e) {
      // Silently handle Play Store lookup failures
    }
  }

  void CheckForNewUpdate1(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      final newVersion = NewVersion(
        androidId: "com.snapchat.android",
        //androidId: "pk.gov.wwf.apps",
        //iOSId: "pk.gov.wwf.apps"
      );
      final status = await newVersion.getVersionStatus();
      if (status != null) {
        var doubleLocalVersion = ConvertedNumber(version);
        var doubleStoreVersion = ConvertedNumber(status.storeVersion);
        if (doubleLocalVersion < doubleStoreVersion) {
        } else {
        }
      }
    } catch (e) {
      // Silently handle Play Store lookup failures
    }
  }

  Future<String> OpenUpdateDialog(BuildContext context, String url) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AppUpdateDialog(url),
          );
        });
  }

  double ConvertedNumber(String version) {
    var splitString = version.split(".");
    if (splitString.length >= 3) {
      if (int.parse(splitString[2]) > 5) {
        int totalSecDigi = (int.parse(splitString[1]) + 1);
        String newStringVersion =
            splitString[0] + "." + totalSecDigi.toString();
        return double.parse(newStringVersion);
      } else {
        String newStringVersion = splitString[0] + "." + splitString[1];
        return double.parse(newStringVersion);
      }
    } else {
      return double.parse(version);
    }
  }

  String formatter(String currentBalance) {
    try {
      double value = double.parse(currentBalance);

      if (value < 1000000) {
        // less than a million
        return value.toStringAsFixed(2);
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // less than 100 million
        double result = value / 1000000;
        return result.toStringAsFixed(2) + "M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // less than 100 billion
        double result = value / (1000000 * 10 * 100);
        return result.toStringAsFixed(2) + "B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // less than 100 trillion
        double result = value / (1000000 * 10 * 100 * 100);
        return result.toStringAsFixed(2) + "T";
      }
    } catch (e) {
    }
  }

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  String ConvertMappedNumber(String amount) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';
    return amount.replaceAllMapped(reg, mathFunc);
  }

  bool CheckDataNullSafety(String data) {
    if (data.isNotEmpty &&
        data != "null" &&
        data != "Null" &&
        data != "NULL" &&
        data != "") {
      return true;
    } else {
      return false;
    }
  }
}
