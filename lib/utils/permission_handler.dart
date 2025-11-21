import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

/// Centralized Permission Handler
/// Handles all app permissions including storage, camera, location, etc.
class AppPermissionHandler {
  static final AppPermissionHandler _instance = AppPermissionHandler._internal();
  factory AppPermissionHandler() => _instance;
  AppPermissionHandler._internal();

  static int _androidSdkVersion = -1;

  /// Get Android SDK version
  static Future<int> _getAndroidSdkVersion() async {
    if (_androidSdkVersion != -1) return _androidSdkVersion;
    
    try {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _androidSdkVersion = androidInfo.version.sdkInt;
        return _androidSdkVersion;
      }
    } catch (e) {
      print("Error getting Android version: $e");
    }
    return 0;
  }

  /// Request all necessary permissions for the app
  /// Should be called on login or app start
  static Future<bool> requestAllPermissions(BuildContext context) async {
    try {
      List<Permission> permissionsToRequest = [];

      // Storage permissions - handle Android 13+ (API 33+) differently
      if (Platform.isAndroid) {
        final sdkVersion = await _getAndroidSdkVersion();
        if (sdkVersion >= 33) {
          // Android 13+ - use granular media permissions
          permissionsToRequest.addAll([
            Permission.photos,
            Permission.videos,
          ]);
        } else {
          // Android 12 and below - use storage permission
          permissionsToRequest.add(Permission.storage);
        }
      } else if (Platform.isIOS) {
        // iOS uses photos permission
        permissionsToRequest.add(Permission.photos);
      }

      // Request all permissions
      if (permissionsToRequest.isNotEmpty) {
        Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();

        // Check if all permissions were granted
        bool allGranted = true;
        for (var permission in permissionsToRequest) {
          if (statuses[permission] != PermissionStatus.granted) {
            allGranted = false;
            break;
          }
        }

        return allGranted;
      }

      return true;
    } catch (e) {
      print("Error requesting permissions: $e");
      return false;
    }
  }

  /// Check and request storage permissions for file picking
  /// Returns true if permission is granted, false otherwise
  static Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        final sdkVersion = await _getAndroidSdkVersion();
        
        if (sdkVersion >= 33) {
          // Android 13+ - check photos permission
          var status = await Permission.photos.status;
          if (!status.isGranted) {
            // Always request permission if not granted (including denied, limited, restricted)
            if (status.isDenied || status.isLimited || status.isRestricted) {
              status = await Permission.photos.request();
            }
            
            // If still not granted after request, check if permanently denied
            if (!status.isGranted) {
              if (status.isPermanentlyDenied) {
                if (context != null) {
                  _showPermissionDeniedDialog(context, "Photos");
                }
                return false;
              }
              // If just denied (not permanently), return false but don't show dialog
              // User can try again and it will request again
              return false;
            }
          }
          return true;
        } else {
          // Android 12 and below - check storage permission
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            // Always request permission if not granted (including denied, limited, restricted)
            if (status.isDenied || status.isLimited || status.isRestricted) {
              status = await Permission.storage.request();
            }
            
            // If still not granted after request, check if permanently denied
            if (!status.isGranted) {
              if (status.isPermanentlyDenied) {
                if (context != null) {
                  _showPermissionDeniedDialog(context, "Storage");
                }
                return false;
              }
              // If just denied (not permanently), return false but don't show dialog
              // User can try again and it will request again
              return false;
            }
          }
          return true;
        }
      } else if (Platform.isIOS) {
        // iOS - check photos permission
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          // Request permission if not granted
          if (status.isDenied || status.isLimited || status.isRestricted) {
            status = await Permission.photos.request();
          }
          
          if (!status.isGranted) {
            return false;
          }
        }
        return true;
      }

      return true;
    } catch (e) {
      print("Error checking storage permission: $e");
      return false;
    }
  }

  /// Check if storage permission is already granted
  static Future<bool> hasStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        final sdkVersion = await _getAndroidSdkVersion();
        if (sdkVersion >= 33) {
          return await Permission.photos.isGranted;
        } else {
          return await Permission.storage.isGranted;
        }
      } else if (Platform.isIOS) {
        return await Permission.photos.isGranted;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    try {
      var status = await Permission.camera.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.camera.request();
        if (status != PermissionStatus.granted) {
          if (status.isPermanentlyDenied) {
            _showPermissionDeniedDialog(context, "Camera");
          }
          return false;
        }
      }
      return status == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }

  /// Request location permission
  static Future<bool> requestLocationPermission(BuildContext context) async {
    try {
      var status = await Permission.location.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.location.request();
        if (status != PermissionStatus.granted) {
          if (status.isPermanentlyDenied) {
            _showPermissionDeniedDialog(context, "Location");
          }
          return false;
        }
      }
      return status == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }


  /// Show dialog when permission is permanently denied
  static void _showPermissionDeniedDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text(
            "$permissionName permission is required to use this feature. "
            "Please enable it in app settings.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

}

/// Helper function to check and request storage permission for file picking
/// Use this in all file picker methods
Future<bool> ensureStoragePermission(BuildContext context) async {
  return await AppPermissionHandler.checkAndRequestStoragePermission(context);
}

/// Helper function to check storage permission without requesting
Future<bool> hasStoragePermission() async {
  return await AppPermissionHandler.hasStoragePermission();
}

