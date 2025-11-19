
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:wwf_apps/Strings/Strings.dart';
import 'package:wwf_apps/screens/general/splash_screen.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'package:wwf_apps/sessions/UserSessions.dart';

class APIService {
  static var client=http.Client();

  static Map<String, String> getDefaultHeaders({Map<String, String> additionalHeaders}) {
    Map<String, String> headers = {};
    
    String token = UserSessions.instance.getToken;
    if (token != null && token.isNotEmpty && token != "null") {
      headers['Authorization'] = 'Bearer $token';
    }
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

static Future<String> postRequest({
   String apiName,
    bool isJson,
    Map<String, dynamic> mapData,
    Map<String, String> headers,UIUpdates uiUpdates}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        uiUpdates.ShowToast(Strings.instance.internetNotConnected);
        return null;
      }
      
      Map<String, String> finalHeaders = getDefaultHeaders(additionalHeaders: headers);
      
      var response = await client.post(
          Uri.parse(constants.getApiBaseURL() + apiName), body: isJson??false?json.encode(mapData):mapData, headers: finalHeaders,encoding: Encoding.getByName("UTF-8"))
          .timeout(const Duration(seconds: 30));
      var statusCode = response.statusCode;
      var jsonString = response.body;
      switch (statusCode) {
        case HttpStatus.ok:
          return jsonString;
          break;
        case HttpStatus.gatewayTimeout:
          uiUpdates.ShowToast(jsonDecode(jsonString)["Data"]??Strings.instance.noServerResponse);
          return null;
          break;
        case HttpStatus.badRequest:
          uiUpdates.ShowToast(jsonDecode(jsonString)["Data"]??Strings.instance.badRequestError);
          return null;
          break;
        case HttpStatus.notFound:
          uiUpdates.ShowToast(jsonDecode(jsonString)["Data"]??Strings.instance.pageNotFound);
          return null;
          break;
        case HttpStatus.internalServerError:
          uiUpdates.ShowToast(jsonDecode(jsonString)["Data"]??Strings.instance.internalServerError);
          return null;
          break;
        default:
          uiUpdates.ShowToast(jsonDecode(jsonString)["Data"]??Strings.instance.somethingWentWrong);
          return null;
          break;
      }
    }catch(e)
  {
    uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
    return null;
  }
}




  static Future<String> getRequest({
      String apiName,
      Map<String, String> headers,UIUpdates uiUpdates}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        uiUpdates.ShowToast(Strings.instance.internetNotConnected);
        return null;
      }
      
      Map<String, String> finalHeaders = getDefaultHeaders(additionalHeaders: headers);
      
      var response = await client.get(
          Uri.parse(constants.getApiBaseURL() + apiName), headers: finalHeaders,)
          .timeout(const Duration(seconds: 30));

      var statusCode = response.statusCode;
      switch (statusCode) {
        case HttpStatus.ok:
          var jsonString = response.body;
          return jsonString;
          break;
        case HttpStatus.gatewayTimeout:
          uiUpdates.ShowToast(Strings.instance.noServerResponse);
          return null;
          break;
        default:
          uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
          return null;
          break;
      }
    }catch(e)
    {
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      return null;
    }
  }



  static void addAuthHeaderToMultipartRequest(http.MultipartRequest request) {
    String token = UserSessions.instance.getToken;
    if (token != null && token.isNotEmpty && token != "null") {
      request.headers['Authorization'] = 'Bearer $token';
    }
  }
}