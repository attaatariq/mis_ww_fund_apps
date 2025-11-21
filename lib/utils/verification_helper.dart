import 'dart:convert';
import 'package:wwf_apps/constants/Constants.dart';
import 'package:wwf_apps/network/api_service.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';
import 'package:http/http.dart' as http;

class VerificationHelper {
  static bool _isScrutinized = false;
  static bool _isChecked = false;

  static Future<bool> checkIfScrutinized() async {
    if (_isChecked) {
      return _isScrutinized;
    }

    try {
      String userId = UserSessions.instance.getUserID;
      String empId = UserSessions.instance.getEmployeeID;

      if (empId.isEmpty || empId == "" || empId == "null") {
        // Try to fetch from information API
        empId = await _fetchEmployeeID();
      }

      if (empId.isEmpty || empId == "" || empId == "null") {
        // If no emp_id, assume scrutinized (might be WWF employee)
        _isScrutinized = true;
        _isChecked = true;
        return true;
      }

      Constants constants = new Constants();
      
      // API endpoint: /companies/is_verified/{user_id}/{emp_id}
      var url = constants.getApiBaseURL() +
                constants.companies +
                "is_verified/" +
                userId + "/" +
                empId;

      var response = await http.get(
        Uri.parse(url),
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        dynamic codeValue = body["Code"];
        String code = codeValue != null ? codeValue.toString() : "0";

        if (code == "1" || codeValue == 1) {
          var messageData = body["Message"];
          if (messageData != null && messageData is Map) {
            String empCheck = messageData["emp_check"]?.toString() ?? "";
            _isScrutinized = empCheck == "Scrutinized";
            _isChecked = true;
            return _isScrutinized;
          }
        }
      }

      // On error, assume not scrutinized to be safe
      _isScrutinized = false;
      _isChecked = true;
      return false;
    } catch (e) {
      // On error, assume not scrutinized to be safe
      _isScrutinized = false;
      _isChecked = true;
      return false;
    }
  }

  static Future<String> _fetchEmployeeID() async {
    try {
      Constants constants = new Constants();
      List<String> tagsList = [constants.accountInfo];
      Map data = {
        "user_id": UserSessions.instance.getUserID,
        "api_tags": jsonEncode(tagsList).toString(),
      };
      var url = constants.getApiBaseURL() + constants.authentication + "information";
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: APIService.getDefaultHeaders(),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String code = body["Code"]?.toString() ?? "0";
        if (code == "1" || body["Code"] == 1) {
          var dataObj = body["Data"];
          var account = dataObj["account"];
          if (account != null && account["emp_id"] != null) {
            String empId = account["emp_id"].toString();
            if (empId.isNotEmpty && empId != "null") {
              UserSessions.instance.setEmployeeID(empId);
              return empId;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail
    }
    return "";
  }

  static void reset() {
    _isScrutinized = false;
    _isChecked = false;
  }
}

