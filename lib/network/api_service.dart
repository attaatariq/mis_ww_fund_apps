
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:welfare_claims_app/Strings/Strings.dart';
import 'package:welfare_claims_app/screens/general/splash_screen.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';
class APIService {
  static var client=http.Client();


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
      var response = await client.post(
          Uri.parse(constants.getApiBaseURL() + apiName), body: isJson??false?json.encode(mapData):mapData, headers: headers,encoding: Encoding.getByName("UTF-8"))
          .timeout(const Duration(seconds: 30));
      print("url:${Uri.parse(constants.getApiBaseURL() + apiName)}:code:${response.statusCode}:${response.body}");
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
    print(e);
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
      if(kDebugMode) print("response:$apiName");
      var response = await client.get(
          Uri.parse(constants.getApiBaseURL() + apiName), headers: headers,)
          .timeout(const Duration(seconds: 30));

      if(kDebugMode)print(response.body);
      var statusCode = response.statusCode;
      switch (statusCode) {
        case HttpStatus.ok:
          var jsonString = response.body;
          if ( kDebugMode) debugPrint(jsonString, wrapWidth: 1024);
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
      print(e);
      uiUpdates.ShowToast(Strings.instance.somethingWentWrong);
      return null;
    }
  }


/*  static Future<String> postRequestWithNoBaseUrl({
      String apiName,
      bool isJson,
      Map<String, dynamic> mapData,
      Map<String, String> headers}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        errorSnackbar("no_internet".tr);
        return null;
      }
      if( kDebugMode) print("response:$apiName");
      var response = await client.post(
          Uri.parse(apiName), body: isJson?json.encode(mapData):mapData, headers: headers)
          .timeout(const Duration(seconds: 30));
      if( kDebugMode)print(response.statusCode);
      if( kDebugMode)print(response.body);
      var statusCode = response.statusCode;
      switch (statusCode) {
        case HttpStatus.ok:
          var jsonString = response.body;

          return jsonString;
          break;
        case HttpStatus.gatewayTimeout:
          errorSnackbar("no_server".tr);
          return null;
          break;
        default:
          var responseData=json.decode(response.body);
          if(responseData.toString().contains("error")){
            errorSnackbar(responseData["error"]["message"]);
          }
          else{
            errorSnackbar("went_wrong".tr+responseData["error"]["message"]);
          }
          return null;
          break;
      }
    }catch(e)
    {
      if( kDebugMode)print(e);
      errorSnackbar("went_wrong".tr+" "+e.toString());
      return null;
    }
  }


  static Future<String?> getRequestWithNoBaseUrl({
      String apiName,
      Map<String, String> headers}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        errorSnackbar("no_internet".tr);
        return null;
      }
      if( kDebugMode) print("response:$apiName");
      var response = await client.get(
          Uri.parse(apiName), headers: headers)
          .timeout(const Duration(seconds: 30));

      if( kDebugMode)print(apiName==URLS.currentLocationDetailNew?utf8.decode(response.bodyBytes):response.body);
      var statusCode = response.statusCode;
      switch (statusCode) {
        case HttpStatus.ok:
          var jsonString = (apiName==URLS.currentLocationDetailNew?utf8.decode(response.bodyBytes):response.body);
          if ( kDebugMode) debugPrint(jsonString, wrapWidth: 1024);
          return jsonString;
          break;
        case HttpStatus.gatewayTimeout:
          errorSnackbar("no_server".tr);
          return null;
          break;
        default:
          errorSnackbar("went_wrong".tr);
          return null;
          break;
      }
    }catch(e)
    {
      if( kDebugMode)print(e);
      errorSnackbar("went_wrong".tr+" "+e.toString());
      return null;
    }
  }


  static Future<String?> uploadFiles(http.MultipartRequest request) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        errorSnackbar("no_internet".tr);
        return null;
      }

      if( kDebugMode) print("response:");
      http.Response response = await http.Response.fromStream(await request.send());

      if( kDebugMode)print(response.body);
      var statusCode = response.statusCode;
      switch (statusCode) {
        case HttpStatus.ok:
          var jsonString = response.body;
          if ( kDebugMode) debugPrint(jsonString, wrapWidth: 1024);
          return jsonString;
          break;
        case HttpStatus.gatewayTimeout:
          errorSnackbar("no_server".tr);
          return null;
          break;
        default:
          errorSnackbar("went_wrong".tr);
          return null;
          break;
      }
    }catch(e)
    {
      if( kDebugMode)print(e);
      errorSnackbar("went_wrong".tr+" "+e.toString());
      return null;
    }
  }*/
}