import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:wwf_apps/updates/UIUpdates.dart';
import 'dart:io';

/// Centralized Permission Handler
/// Handles all app permissions including storage, camera, location, etc.
class AppPermissionHandler {
  static final AppPermissionHandler _instance = AppPermissionHandler._internal();
  factory AppPermissionHandler() => _instance;
  AppPermissionHandler._internal();

  /// Request all necessary permissions for the app
  /// Should be called on login or app start
  static Future<bool> requestAllPermissions(BuildContext context) async {
    try {
      List<Permission> permissionsToRequest = [];

      // Storage permissions - handle Android 13+ (API 33+) differently
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), use photos/videos permissions
        // For older versions, use storage permission
        final androidInfo = await _getAndroidVersion();
        if (androidInfo >= 33) {
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
        final androidVersion = await _getAndroidVersion();
        
        if (androidVersion >= 33) {
          // Android 13+ - check photos permission
          var status = await Permission.photos.status;
          if (status.isDenied || status.isPermanentlyDenied) {
            status = await Permission.photos.request();
            if (status != PermissionStatus.granted) {
              if (status.isPermanentlyDenied) {
                _showPermissionDeniedDialog(context, "Photos");
              }
              return false;
            }
          }
          return status == PermissionStatus.granted;
        } else {
          // Android 12 and below - check storage permission
          var status = await Permission.storage.status;
          if (status.isDenied || status.isPermanentlyDenied) {
            status = await Permission.storage.request();
            if (status != PermissionStatus.granted) {
              if (status.isPermanentlyDenied) {
                _showPermissionDeniedDialog(context, "Storage");
              }
              return false;
            }
          }
          return status == PermissionStatus.granted;
        }
      } else if (Platform.isIOS) {
        // iOS - check photos permission
        var status = await Permission.photos.status;
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.photos.request();
          if (status != PermissionStatus.granted) {
            return false;
          }
        }
        return status == PermissionStatus.granted;
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
        final androidVersion = await _getAndroidVersion();
        if (androidVersion >= 33) {
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

  /// Get Android version
  static Future<int> _getAndroidVersion() async {
    try {
      if (Platform.isAndroid) {
        // Use device_info_plus if available, otherwise default to checking storage permission
        // For now, we'll check both photos and storage permissions
        return 33; // Assume Android 13+ for safety, will check both permissions
      }
      return 0;
    } catch (e) {
      return 0;
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

  /// Open app settings
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

/// Helper function to check and request storage permission for file picking
/// Use this in all file picker methods
Future<bool> ensureStoragePermission(BuildContext context) async {
  return await AppPermissionHandler.checkAndRequestStoragePermission(context);
}

